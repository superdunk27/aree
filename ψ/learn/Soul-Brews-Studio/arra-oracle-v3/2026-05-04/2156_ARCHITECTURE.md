# Arra Oracle v3 - Architecture Overview

**Version**: 26.5.2-alpha.1704  
**Runtime**: Bun ≥1.2.0  
**Last Updated**: 2026-05-04

## Directory Layout

```
arra-oracle-v3/
├── bin/
│   └── arra.ts                  # HTTP server entry point (wraps src/server.ts via Bun.serve)
├── src/
│   ├── index.ts                 # MCP server entry (StdioServerTransport, tool routing)
│   ├── server.ts                # HTTP API (Elysia, 55 endpoints across 15 modules)
│   ├── indexer/
│   │   ├── cli.ts               # Indexer CLI entry (bun src/indexer/cli.ts)
│   │   ├── index.ts             # OracleIndexer class (markdown parsing, document discovery)
│   │   ├── scan.ts              # File discovery (recursively scan ψ/ and ghq repos)
│   │   ├── parser.ts            # Frontmatter extraction, concept tagging
│   │   ├── collectors.ts        # Multi-root document collection
│   │   └── discovery.ts         # File type detection (Markdown, JSON, YAML)
│   ├── vault/
│   │   └── cli.ts               # Vault CLI entry (oracle-vault init|sync|pull|status)
│   ├── db/
│   │   ├── schema.ts            # Drizzle ORM schema (13 tables, FTS5 virtual table)
│   │   ├── index.ts             # Database client factory (bun:sqlite + Drizzle)
│   │   └── migrations/          # Auto-generated migration files
│   ├── tools/                   # MCP tool handlers (22 tools, pure functions)
│   │   ├── index.ts             # Tool registration & type exports
│   │   ├── search.ts            # Hybrid FTS5+vector search with sanitization
│   │   ├── learn.ts             # Document learning (accept new patterns)
│   │   ├── list.ts              # Browse documents by type
│   │   ├── stats.ts             # Database statistics
│   │   ├── concepts.ts          # List concept tags
│   │   ├── forum.ts             # Thread CRUD (forum_threads, forum_messages)
│   │   ├── trace.ts             # Trace system (discovery digpoints, linked chains)
│   │   ├── supersede.ts         # Mark documents as outdated
│   │   ├── handoff.ts           # Session handoff record
│   │   ├── inbox.ts             # Message queue for async notifications
│   │   └── types.ts             # Tool input/output types
│   ├── vector/
│   │   ├── factory.ts           # Vector store factory (supports 5 backends)
│   │   ├── types.ts             # VectorStoreAdapter interface
│   │   ├── embeddings.ts        # Embedding provider factory (Ollama, OpenAI, CF)
│   │   ├── config.ts            # Vector config parser (load from vector-server.json)
│   │   └── adapters/
│   │       ├── lancedb.ts       # LanceDB (default, 1024-dim bge-m3)
│   │       ├── sqlite-vec.ts    # SQLite + sqlite-vec extension
│   │       ├── chroma-mcp.ts    # ChromaDB via MCP
│   │       ├── qdrant.ts        # Qdrant REST API
│   │       └── cloudflare-vectorize.ts
│   ├── routes/                  # Elysia sub-apps (15 clusters, 55 endpoints)
│   │   ├── auth/                # Login, logout, status
│   │   ├── search/              # FTS5 + vector search, reflect, similar
│   │   ├── knowledge/           # Learn, handoff, inbox
│   │   ├── forum/               # Threads, messages, sync to GitHub
│   │   ├── traces/              # Traces, digpoints, linked chains
│   │   ├── health/              # Health check, stats, active Oracles
│   │   ├── dashboard/           # Session stats, growth, activity
│   │   ├── settings/            # App config, auth settings
│   │   ├── supersede/           # Supersede log, chains
│   │   ├── schedule/            # Events, appointments
│   │   ├── files/               # File access (ghq-aware), graph, logs
│   │   ├── plugins/             # Plugin registry, load info
│   │   ├── vector/              # Vector status (dimension, collection count)
│   │   ├── vault/               # Vault sync info
│   │   └── indexer/             # Indexing status
│   ├── server/                  # HTTP server utilities (logging, project detection)
│   ├── gateway/                 # Plugin loader (hooks, middleware)
│   ├── trace/                   # Trace system (records digpoints, links)
│   ├── menu/                    # Studio navigation seeder
│   ├── forum/                   # Forum utilities
│   ├── config.ts                # Config loader (env, data dir, DB path)
│   ├── const.ts                 # Constants (MCP_SERVER_NAME, COLLECTION_NAME)
│   └── types.ts                 # Shared TypeScript types
├── cli/
│   ├── src/cli.ts               # CLI plugin runner (arra-cli command)
│   ├── src/commands/            # Menu, session, plugin management subcommands
│   ├── src/plugin/              # Plugin loader, manifest, registry
│   └── src/plugins/             # Plugins (export-obsidian, etc.)
├── scripts/
│   ├── setup.sh                 # Environment setup
│   ├── calver.ts                # CalVer bumper (YY.M.D-alpha.HH)
│   ├── gen-endpoints.ts         # Auto-gen endpoint table for README
│   └── index-model.ts           # Vector indexing for specific models
├── docs/
│   ├── LOCAL-DEV.md             # Development environment setup
│   ├── API.md                   # API documentation
│   └── CONTRIBUTING-AWAKENING.md
├── tests/
│   ├── integration/             # Full stack tests (DB, HTTP, MCP)
│   └── e2e/                     # Playwright E2E tests
├── package.json                 # Bun workspace, 3 bin entries
├── bunfig.toml                  # Bun test config (roots, isolation)
├── drizzle.config.ts            # Drizzle migration config
└── vitest.config.ts             # Unit test config
```

## Entry Points & Binaries

Three executable binaries from single package:

| Binary | Entry | Command | Purpose |
|--------|-------|---------|---------|
| `arra-oracle-v2` (MCP) | `src/index.ts` | `bunx --bun arra-oracle-v2@github:...` | Claude Code integration via MCP protocol |
| `arra-oracle-v3` (HTTP) | `bin/arra.ts` → `src/server.ts` | `bun run server` or `bunx --bun arra-oracle-v3@github:...` | REST API on port 47778 (default) |
| `arra-cli` | `cli/src/cli.ts` | `bunx --bun arra-cli@github:...` | Plugin runner, menu/session management |
| `oracle-vault` | `src/vault/cli.ts` | `bunx --bun --package arra-oracle-v2@github:... oracle-vault` | Vault sync, GitHub integration |
| Indexer | `src/indexer/cli.ts` | `bun run index` | Knowledge base indexer (markdown discovery + FTS5 + vector indexing) |

## Data Layer: SQLite FTS5 + Vector Hybrid

**Core Strategy**: Two-tier search reconciliation—keyword precision (FTS5) + semantic relevance (vectors).

### SQLite (Full-Text Search)

**Schema** (`src/db/schema.ts:11`):
- **`oracle_documents`**: Main index (id, type, sourceFile, concepts[JSON], timestamps, supersede tracking, provenance)
- **`oracle_fts`**: FTS5 virtual table (raw SQL, managed outside Drizzle; indexes sourceFile + body)
- **Log tables**: search_log, learn_log, document_access, consult_log (backward compat), forum_threads, forum_messages, trace_log, activity_log, settings, schedule, menu_items

**Indexes**: sourceFile, type, supersededBy, origin, project (schema.ts:28-32)

**Why FTS5?**
- Instant keyword matching (sub-millisecond on cold DB)
- Robust fallback when ChromaDB/vector backend unavailable
- Tokenization handles Thai, CJK, mixed scripts well

### Vector Search (Pluggable)

**Factory** (`src/vector/factory.ts:49`):
- **LanceDB** (default): Fast columnar, supports multiple embedding models, local or remote
- **sqlite-vec**: Native SQLite with vector extension
- **ChromaDB**: Python MCP server (optional, requires external process)
- **Qdrant**: REST-based vector DB
- **Cloudflare Vectorize**: Serverless embeddings + vector storage

**Embedding Models** (registry, `factory.ts:135`):
- `bge-m3`: 1024-dim, multilingual (Thai↔English), default
- `nomic-embed-text`: 768-dim, fast baseline
- `qwen3`: 4096-dim, cross-language (future)

**Why pluggable?**
- Different deployments have different vector infrastructure (Ollama vs. OpenAI vs. Cloudflare)
- Model registry allows dual-index search (query both bge-m3 + nomic in same request)
- Graceful degradation: if vector backend unavailable, FTS5 alone still works

### Hybrid Search Reconciliation

**`src/tools/search.ts`** (search handler):
1. Query FTS5 for keyword matches → normalized scores (0-1, exponential decay on rank)
2. Query vector store (if available) for semantic matches → cosine similarity scores
3. Combine results: merge by document ID, weighted average of scores
4. Filter by type (principle, pattern, learning, retro)
5. Log to search_log (query, mode, results count, timing)

**Mode options** (schema:44-46):
- `hybrid`: FTS5 + vectors (default)
- `fts`: Keywords only (instant, no vector latency)
- `vector`: Semantic only (no keyword constraints)

## MCP Tool Surface (22 Tools)

**Registration** (`src/index.ts`):
- Each tool has a definition (name, description, inputSchema) and handler function
- Handlers imported from `src/tools/index.ts` and composed into MCP server

**Core Tools**:

| Tool | Handler | Purpose |
|------|---------|---------|
| `arra_search` | `handleSearch` | Hybrid search (FTS5 + vectors) |
| `arra_reflect` | `handleReflect` | Random wisdom from knowledge base |
| `arra_learn` | `handleLearn` | Add new document/pattern to vault |
| `arra_list` | `handleList` | Browse documents (paginated) |
| `arra_stats` | `handleStats` | DB statistics (doc count, last indexed) |
| `arra_concepts` | `handleConcepts` | List unique concept tags |
| `arra_verify` | `handleVerify` | Verify document accuracy |
| `arra_read` | `handleRead` | Read full document by ID |
| `arra_supersede` | `handleSupersede` | Mark doc as outdated, link to replacement |
| `arra_handoff` | `handleHandoff` | Session handoff record (context transfer) |
| `arra_inbox` | `handleInbox` | Async message queue |
| `arra_thread` | `handleThread` | Create forum thread or send message |
| `arra_threads` | `handleThreads` | List threads (paginated) |
| `arra_thread_read` | `handleThreadRead` | Read thread + all messages |
| `arra_thread_update` | `handleThreadUpdate` | Update thread status (active→answered) |
| `arra_schedule_add` | `handleScheduleAdd` | Add appointment/event |
| `arra_schedule_list` | `handleScheduleList` | List upcoming events |
| `arra_trace` | `handleTrace` | Create digpoint (trace discovery) |
| `arra_trace_list` | `handleTraceList` | List traces |
| `arra_trace_get` | `handleTraceGet` | Get trace by ID |
| `arra_trace_link` | `handleTraceLink` | Link two traces (prev→next) |
| `arra_trace_unlink` | `handleTraceUnlink` | Remove trace link |

**Tool Groups** (`src/config/tool-groups.ts`):
- Tools can be disabled per group (read-only mode disables `arra_learn`, `arra_thread`, `arra_trace`, `arra_supersede`, `arra_handoff`)
- Controlled via `.claude.json` or environment variables

## Build & Runtime

**Package Management**: Bun workspace
- **Lockfile**: `bun.lock` (no npm dependencies; Bun-native)
- **Runtime**: Bun 1.2+ (required in package.json:19)

**Scripts** (`package.json:28`):

| Script | Purpose |
|--------|---------|
| `bun run dev` | Watch MCP server (stdout/stdio) |
| `bun run server` | HTTP API (port 47778) |
| `bun run vector` | Vector server (proxy to LanceDB/Chroma) |
| `bun run index` | Run knowledge base indexer |
| `bun test` | Unit + integration tests |
| `bunx drizzle-kit migrate` | Apply schema migrations |
| `bunx drizzle-kit studio` | GUI schema editor |
| `bun run vault:sync` | Sync vault to GitHub |

**Bun-Specific Features**:
- **Native SQLite**: `bun:sqlite` (built-in, no Node.js dependency)
- **File I/O**: Bun's `fs` module (faster than Node)
- **HTTP server**: Bun.serve() in `bin/arra.ts` for direct socket binding
- **Test isolation**: `bunfig.toml:9` sets `isolate = true` to prevent SQLite locks between parallel test files

## Architectural Decisions

### 1. Why Hybrid SQLite FTS5 + Vector Instead of One?

**Trade-off resolved**: Precision (keyword) vs. Relevance (semantic).

- **FTS5 strengths**: Deterministic, instant, handles Thai tokenization, no external process required
- **Vector strengths**: Captures meaning ("force push safety" ≈ "dangerous git operations"), multilingual
- **Hybrid approach**: User types keyword → fast FTS5 result + semantic enrichment from vectors
  - If either backend unavailable, search still works (degradation is graceful, not catastrophic)
  - Dual-model search allows comparing embeddings across models (bge-m3 vs. nomic) in one request

**Why not pure vector DB?**
- Latency: Vector queries require round-trip to embedding API (Ollama, OpenAI) or ChromaDB process
- Determinism: Keyword search is reproducible; vector similarity is stochastic
- Dependency: Pure vector approach creates hard dependency on external service

### 2. Why Bun Not Node?

- **Startup speed**: MCP server must start <100ms for Claude Code; Bun achieves ~40ms cold
- **Native SQLite**: No binding layer, direct syscalls to `bun:sqlite`
- **Single-threaded but async**: Bun's event loop handles I/O-bound workloads (DB, HTTP, MCP) efficiently
- **File system**: Bun's fs is optimized for metadata queries (heavy in indexer)

**Trade-off**: Smaller ecosystem than Node, but arra-oracle intentionally minimizes external deps.

### 3. Tool Registration as Pure Functions (Not Classes)

**Pattern** (`src/tools/search.ts:15-63`):
- Tool definition (`searchToolDef`) is exported constant
- Handler (`handleSearch`) is pure async function taking (input, context) → ToolResponse
- Enables easy testing (no mocking, no class instantiation)
- Each tool file ≤250 lines (project convention, `CLAUDE.md`)

**Why not OOP?**
- MCP protocol is stateless (each call is independent)
- Pure functions are easier to test, reason about, and parallelize
- Reduces cognitive load when adding new tools

### 4. Elysia (Bun-Native Web Framework)

**Rationale** (CLAUDE.md, "Migrating Hono → Elysia"):
- Hono was placeholder for Node compatibility; Elysia is Bun-native
- TypeBox schema validation is built-in (type-safe query/body parsing)
- Elysia plugins compose naturally (cors, swagger, auth)
- Migration path: new routes in `src/routes-elysia/`, old Hono in `src/routes/`, swap when complete

**Current state**: Elysia in `src/server.ts`, routes imported from `src/routes/` (Hono apps converted to Elysia sub-apps).

## Data Provenance & Versioning

**Supersede Pattern** (schema.ts:19-22):
- No hard deletes: documents marked `supersededBy` instead of deleted
- Enables audit trail, conflict resolution, version history
- Supports "nothing is deleted" Oracle philosophy

**Provenance Tracking** (schema.ts:24-26):
- `origin`: where document came from (mother, arthur, volt, human, null)
- `project`: ghq-style path (github.com/owner/repo)
- `createdBy`: indexer, arra_learn, or manual

**CalVer Versioning** (`scripts/calver.ts`):
- Always alpha: `v{YY}.{M}.{D}-alpha.{HOUR}`
- Bumped via dedicated `bump/alpha.N` PR for clean release workflows

---

**Total Endpoints**: 55 across 15 route clusters (auth, search, forum, traces, dashboard, schedule, vault, indexer, etc.)

**Total Tools**: 22 via MCP (searchable, learnable, threadable, traceable, schedulable)

**Database Tables**: 13 managed by Drizzle + 1 FTS5 virtual table = queryable knowledge base with full-text + semantic search reconciliation.
