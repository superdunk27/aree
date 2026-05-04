# Arra Oracle v3 - Code Snippets

## 1. MCP Server Entry Point & Tool Registration

**File**: `src/index.ts` (lines 77–293)

The `OracleMCPServer` class bootstraps the MCP server, initializes database and vector store, and routes tool calls to handlers. The `setupHandlers()` method registers the ListTools endpoint (which advertises all 15+ tools) and the CallTool handler (which dispatches requests to specific handlers).

```typescript
class OracleMCPServer {
  private server: Server;
  private sqlite: Database;
  private db: BunSQLiteDatabase<typeof schema>;
  private vectorStore: VectorStoreAdapter;
  private vectorStatus: 'unknown' | 'connected' | 'unavailable' = 'unknown';

  constructor(options: { readOnly?: boolean; toolGroups?: ToolGroupConfig } = {}) {
    this.readOnly = options.readOnly ?? false;
    this.repoRoot = REPO_ROOT;
    this.vectorStore = createVectorStore({
      type: 'lancedb',
      collectionName: 'oracle_knowledge_bge_m3',
      embeddingProvider: 'ollama',
      embeddingModel: 'bge-m3',
    });
    this.server = new Server(
      { name: MCP_SERVER_NAME, version: this.version },
      { capabilities: { tools: {} } }
    );
    const { sqlite, db } = createDatabase(DB_PATH);
    this.sqlite = sqlite;
    this.db = db;
    this.setupHandlers();
  }

  private setupHandlers(): void {
    // List available tools
    this.server.setRequestHandler(ListToolsRequestSchema, async () => {
      const allTools = [
        searchToolDef, learnToolDef, listToolDef, statsToolDef,
        // ... 11+ more tools
      ];
      let tools = allTools.filter(t => !this.disabledTools.has(t.name));
      if (this.readOnly) {
        tools = tools.filter(t => !WRITE_TOOLS.includes(t.name));
      }
      return { tools };
    });

    // Handle tool calls — route to extracted handlers
    this.server.setRequestHandler(CallToolRequestSchema, async (request): Promise<any> => {
      const ctx = this.toolCtx;
      try {
        switch (request.params.name) {
          case 'arra_search':
            return await handleSearch(ctx, request.params.arguments as unknown as OracleSearchInput);
          case 'arra_learn':
            return await handleLearn(ctx, request.params.arguments as unknown as OracleLearnInput);
          // ... more cases
          default:
            throw new Error(`Unknown tool: ${request.params.name}`);
        }
      } catch (error) {
        return {
          content: [{ type: 'text', text: `Error: ${error instanceof Error ? error.message : String(error)}` }],
          isError: true
        };
      }
    });
  }
}

async function main() {
  const readOnly = process.env.ORACLE_READ_ONLY === 'true' || process.argv.includes('--read-only');
  const server = new OracleMCPServer({ readOnly });
  await server.preConnectVector();
  await server.run();
}
```

---

## 2. Hybrid Search Tool Implementation

**File**: `src/tools/search.ts` (lines 15–305)

The `arra_search` tool definition shows the MCP interface; the `handleSearch` function orchestrates hybrid search by running FTS5 and vector queries in parallel, then combining results with deduplication and scoring.

```typescript
export const searchToolDef = {
  name: 'arra_search',
  description: 'Search Oracle knowledge base using hybrid search (FTS5 keywords + ChromaDB vectors)...',
  inputSchema: {
    type: 'object',
    properties: {
      query: { type: 'string', description: 'Search query' },
      type: { type: 'string', enum: ['principle', 'pattern', 'learning', 'retro', 'all'] },
      limit: { type: 'number', default: 5 },
      mode: { type: 'string', enum: ['hybrid', 'fts', 'vector'], default: 'hybrid' },
      model: { type: 'string', enum: ['nomic', 'qwen3', 'bge-m3'] }
    },
    required: ['query']
  }
};

export async function handleSearch(ctx: ToolContext, input: OracleSearchInput): Promise<ToolResponse> {
  const { query, type = 'all', limit = 5, offset = 0, mode = 'hybrid', project, cwd, model } = input;
  const safeQuery = sanitizeFtsQuery(query);
  const resolvedProject = (project ?? detectProject(cwd))?.toLowerCase() ?? null;

  let ftsRawResults: any[] = [];
  if (mode !== 'vector') {
    // FTS5 search
    const stmt = ctx.sqlite.prepare(`
      SELECT f.id, f.content, d.type, d.source_file, d.concepts, rank
      FROM oracle_fts f
      JOIN oracle_documents d ON f.id = d.id
      WHERE oracle_fts MATCH ? ${projectFilter}
      ORDER BY rank
      LIMIT ?
    `);
    ftsRawResults = stmt.all(safeQuery, ...projectParams, limit * 2);
  }

  // Vector search (async, can fail gracefully)
  let vectorResults = [];
  if (mode !== 'fts') {
    vectorResults = await vectorSearch(ctx, safeQuery, type, limit, model);
  }

  // Combine and rank
  const combined = combineResults(ftsResults, vectorResults);
  const final = combined.slice(offset, offset + limit);

  return {
    content: [{ type: 'text', text: JSON.stringify(final) }]
  };
}
```

---

## 3. Hybrid Search Reconciliation

**File**: `src/tools/search.ts` (lines 189–305)

The `combineResults` function deduplicates by document ID, merges FTS and vector scores, applies a 10% boost for hybrid matches, and sorts by combined score.

```typescript
export function combineResults(
  ftsResults: Array<{ id: string; type: string; content: string; score: number; source: 'fts' }>,
  vectorResults: Array<{ id: string; score: number; distance: number; model: string; source: 'vector' }>,
  ftsWeight: number = 0.5,
  vectorWeight: number = 0.5
): Array<{ id: string; score: number; source: 'fts' | 'vector' | 'hybrid'; ftsScore?: number; vectorScore?: number }> {
  const resultMap = new Map<string, any>();

  // Add FTS results
  for (const result of ftsResults) {
    resultMap.set(result.id, {
      id: result.id,
      type: result.type,
      content: result.content,
      ftsScore: result.score,
      source: 'fts',
    });
  }

  // Add/merge vector results
  for (const result of vectorResults) {
    const existing = resultMap.get(result.id);
    if (existing) {
      // Duplicate found — mark as hybrid
      existing.vectorScore = result.score;
      existing.source = 'hybrid';
      existing.distance = result.distance;
      existing.model = result.model;
    } else {
      resultMap.set(result.id, {
        id: result.id,
        type: result.type,
        vectorScore: result.score,
        source: 'vector',
      });
    }
  }

  // Calculate hybrid scores with 10% boost
  const combined = Array.from(resultMap.values()).map((result) => {
    let score: number;
    if (result.source === 'hybrid') {
      const fts = result.ftsScore ?? 0;
      const vec = result.vectorScore ?? 0;
      score = ((ftsWeight * fts) + (vectorWeight * vec)) * 1.1; // 10% boost
    } else if (result.source === 'fts') {
      score = (result.ftsScore ?? 0) * ftsWeight;
    } else {
      score = (result.vectorScore ?? 0) * vectorWeight;
    }
    return { ...result, score };
  });

  combined.sort((a, b) => b.score - a.score);
  return combined;
}
```

---

## 4. Drizzle Schema — Core Document Table

**File**: `src/db/schema.ts` (lines 11–33)

The main `oracleDocuments` table stores indexed documents with metadata, timestamps, "Nothing is Deleted" supersession tracking, and provenance.

```typescript
export const oracleDocuments = sqliteTable('oracle_documents', {
  id: text('id').primaryKey(),
  type: text('type').notNull(),
  sourceFile: text('source_file').notNull(),
  concepts: text('concepts').notNull(), // JSON array
  createdAt: integer('created_at').notNull(),
  updatedAt: integer('updated_at').notNull(),
  indexedAt: integer('indexed_at').notNull(),
  // Supersede pattern (Issue #19) - "Nothing is Deleted"
  supersededBy: text('superseded_by'),      // ID of newer document
  supersededAt: integer('superseded_at'),   // When superseded
  supersededReason: text('superseded_reason'), // Why (optional)
  // Provenance tracking (Issue #22)
  origin: text('origin'),                   // 'mother' | 'arthur' | 'volt' | 'human' | null
  project: text('project'),                 // 'github.com/laris-co/arra-oracle'
  createdBy: text('created_by'),            // 'indexer' | 'arra_learn' | 'manual'
}, (table) => [
  index('idx_source').on(table.sourceFile),
  index('idx_type').on(table.type),
  index('idx_superseded').on(table.supersededBy),
  index('idx_origin').on(table.origin),
  index('idx_project').on(table.project),
]);
```

---

## 5. HTTP API Server (Elysia)

**File**: `src/server.ts` (lines 138–226)

The Hono/Elysia HTTP server composes 15+ route modules, handles CORS with Private Network Access preflight, and includes error handling for database locks during indexing.

```typescript
const app = new Elysia()
  .use(pnaMiddleware)  // Private Network Access preflight
  .use(
    cors({
      origin: (request) => {
        const origin = request.headers.get('origin');
        return originAllowed(origin) !== null;
      },
      credentials: true,
      methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
    }),
  )
  .onAfterHandle(({ set }) => {
    set.headers['Cache-Control'] = 'no-cache, no-store, must-revalidate';
    set.headers['X-Content-Type-Options'] = 'nosniff';
    set.headers['X-Frame-Options'] = 'DENY';
  })
  .onError(({ code, error, set }) => {
    if (code === 'NOT_FOUND') {
      set.status = 404;
      return { error: 'Not found' };
    }
    const msg = (error as any)?.message ?? String(error);
    const isDbLock = msg.includes('disk I/O') || msg.includes('database is locked');
    if (isDbLock) {
      set.status = 503;
      return { error: 'Database temporarily unavailable (indexing in progress)', indexing: true };
    }
    set.status = 500;
    return { error: msg };
  })
  .get('/', () => ({
    server: MCP_SERVER_NAME,
    version: pkg.version,
    status: 'ok',
    docs: '/swagger',
  }));

const apiModules = [authRoutes, searchRoutes, knowledgeRoutes, forumApi, tracesApi, /* ... 10+ more */];
for (const mod of apiModules) app.use(mod as any);

export default {
  port: Number(PORT),
  fetch: app.fetch,
};
```

---

## 6. Vault CLI Command — Plugin Installation

**File**: `cli/src/commands/plugins-install.ts` (lines 1–80)

The `oracle-vault` CLI installs plugins by parsing a manifest (name, version, wasm artifact) and copying binaries to `~/.oracle/plugins/`.

```typescript
export interface InstallManifest {
  name: string;
  version: string;
  description?: string;
  author?: string;
  wasm: string;           // Path to WASM artifact
  build?: string;
  exports?: unknown;
}

export function parseInstallManifest(raw: string): InstallManifest {
  let obj: unknown;
  try {
    obj = JSON.parse(raw);
  } catch (e) {
    throw new Error(`invalid plugin.json: ${(e as Error).message}`);
  }
  if (!obj || typeof obj !== "object") {
    throw new Error("plugin.json must be a JSON object");
  }
  const m = obj as Record<string, unknown>;
  if (typeof m.name !== "string" || !NAME_RE.test(m.name)) {
    throw new Error(
      `plugin.json: name must match /^[a-z0-9-]+$/, got ${JSON.stringify(m.name)}`,
    );
  }
  if (typeof m.version !== "string" || m.version.length === 0) {
    throw new Error("plugin.json: version is required");
  }
  if (typeof m.wasm !== "string" || m.wasm.length === 0) {
    throw new Error("plugin.json: wasm (artifact path) is required");
  }
  return m as InstallManifest;
}

function pluginsRoot(): string {
  return process.env.ORACLE_PLUGIN_HOME ?? join(homedir(), ".oracle", "plugins");
}
```

---

## 7. Learn Tool Handler

**File**: `src/tools/learn.ts` (lines 1–120)

The `arra_learn` tool adds new patterns to the knowledge base. It normalizes project names, coerces concepts, and creates a markdown file in `ψ/memory/learnings/` with a slug-based filename.

```typescript
export const learnToolDef = {
  name: 'arra_learn',
  description: 'Add a new pattern or learning to the Oracle knowledge base...',
  inputSchema: {
    type: 'object',
    properties: {
      pattern: { type: 'string', description: 'The pattern or learning to add' },
      source: { type: 'string', description: 'Optional source attribution' },
      concepts: { type: 'array', items: { type: 'string' }, description: 'Concept tags' },
      project: { type: 'string', description: 'Source project (ghq or GitHub URL)' }
    },
    required: ['pattern']
  }
};

export function normalizeProject(input?: string): string | null {
  if (!input) return null;
  if (input.match(/^github\.com\/[^\/]+\/[^\/]+$/)) return input.toLowerCase();
  const urlMatch = input.match(/https?:\/\/github\.com\/([^\/]+\/[^\/]+)/);
  if (urlMatch) return `github.com/${urlMatch[1].replace(/\.git$/, '')}`.toLowerCase();
  const shortMatch = input.match(/^([^\/\s]+\/[^\/\s]+)$/);
  if (shortMatch) return `github.com/${shortMatch[1]}`.toLowerCase();
  return null;
}

export function coerceConcepts(concepts: unknown): string[] {
  if (Array.isArray(concepts)) return concepts.map(String);
  if (typeof concepts === 'string') return concepts.split(',').map(s => s.trim()).filter(Boolean);
  return [];
}

export async function handleLearn(ctx: ToolContext, input: OracleLearnInput): Promise<ToolResponse> {
  const { pattern, source, concepts, project: projectInput } = input;
  const now = new Date();
  const dateStr = now.toISOString().split('T')[0];
  const slug = pattern
    .substring(0, 50)
    .toLowerCase()
    .replace(/[^a-z0-9\s-]/g, '')
    .replace(/\s+/g, '-')
    .replace(/-+/g, '-')
    .replace(/^-|-$/g, '');
  const filename = `${dateStr}_${slug}.md`;
  // Creates file in ψ/memory/learnings/ with normalized project and concepts
}
```

---

## 8. E2E Test — Search Hybrid Reconciliation

**File**: `src/tools/__tests__/search.test.ts` (lines 113–161)

Unit tests verify that FTS and vector results merge correctly with deduplication, scoring, and the 10% hybrid boost.

```typescript
describe('combineResults', () => {
  const ftsResults = [
    { id: 'doc1', type: 'principle', content: 'Content 1', source_file: 'f1.md', concepts: ['trust'], score: 0.8, source: 'fts' as const },
    { id: 'doc2', type: 'learning', content: 'Content 2', source_file: 'f2.md', concepts: ['pattern'], score: 0.6, source: 'fts' as const },
  ];

  const vectorResults = [
    { id: 'doc1', type: 'principle', content: 'Content 1', source_file: 'f1.md', concepts: ['trust'], score: 0.9, source: 'vector' as const },
    { id: 'doc3', type: 'retro', content: 'Content 3', source_file: 'f3.md', concepts: ['decision'], score: 0.7, source: 'vector' as const },
  ];

  it('should mark duplicates as hybrid', () => {
    const combined = combineResults(ftsResults, vectorResults);
    const doc1 = combined.find(r => r.id === 'doc1');
    expect(doc1?.source).toBe('hybrid');
    expect(doc1?.ftsScore).toBe(0.8);
    expect(doc1?.vectorScore).toBe(0.9);
  });

  it('should apply 10% boost for hybrid results', () => {
    const combined = combineResults(ftsResults, vectorResults, 0.5, 0.5);
    const doc1 = combined.find(r => r.id === 'doc1');
    // ((0.5 * 0.8) + (0.5 * 0.9)) * 1.1 = 0.935
    expect(doc1?.score).toBeCloseTo(0.935, 2);
  });

  it('should sort by score descending', () => {
    const combined = combineResults(ftsResults, vectorResults);
    for (let i = 1; i < combined.length; i++) {
      expect(combined[i - 1].score).toBeGreaterThanOrEqual(combined[i].score);
    }
  });

  it('should handle empty inputs', () => {
    expect(combineResults([], [])).toEqual([]);
    expect(combineResults(ftsResults, [])).toHaveLength(2);
  });
});
```

---

## Key Patterns

- **MCP Server Bootstrap**: `OracleMCPServer` class manages DB, vector store, and tool registration via ListTools and CallTool handlers.
- **Hybrid Search**: FTS5 + vector in parallel, deduped by ID, hybrid matches get 10% scoring boost.
- **Schema Design**: "Nothing is Deleted" via `supersededBy` fields; provenance tracking (origin, project, createdBy).
- **HTTP API**: Elysia sub-apps per cluster (search, forum, traces, etc.), with graceful indexing lock handling.
- **Learn & Vault**: Normalized project paths (ghq format), slug-based filenames, plugin manifest parsing.
- **Testing**: Pure helper functions exported for unit tests (sanitizeFtsQuery, combineResults, etc.).
