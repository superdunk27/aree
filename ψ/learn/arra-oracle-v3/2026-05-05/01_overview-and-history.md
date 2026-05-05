---
date: 2026-05-05
domain: arra-oracle-v3
topic: Overview, history, philosophy
source: github.com/Soul-Brews-Studio/arra-oracle-v3 (v26.4.19-alpha.7, ★61)
read_at: 2026-05-05 (home, after work-day-2 sync)
---

# arra-oracle-v3 — Overview & History

> "The Oracle Keeps the Human Human" — now queryable via MCP.

## What it is

**arra-oracle-v3** = TypeScript MCP server + HTTP API + Vault CLI that turns the Oracle philosophy + sibling knowledge base into a **searchable, queryable memory layer** for Claude Code (and any MCP client).

The package ships **two binaries**:
- `arra-oracle-v2` → MCP server (stdio transport, what Claude Code connects to)
- `oracle-vault` → Vault CLI (init/sync/pull GitHub-backed vault)

Plus internal entry points:
- `bun run server` → HTTP API on `:47778` (Hono → migrating to Elysia)
- `bun run index` → indexer that parses `ψ/` markdown into SQLite

**Tagline**: *"Always Nightly"* — alpha-only releases, CalVer (`v{YY}.{M}.{D}-alpha.{HOUR}`).
**License**: BUSL-1.1.
**Runtime**: Bun ≥ 1.2.0 (no Node).
**Author**: "Nat's Agents" (Soul-Brews-Studio).

## How Aree connects to it

```bash
claude mcp add arra-oracle-v2 -- bunx --bun arra-oracle-v2@github:Soul-Brews-Studio/arra-oracle-v3#main
```

Or in `~/.claude.json`:
```json
{
  "mcpServers": {
    "arra-oracle-v2": {
      "command": "bunx",
      "args": ["--bun", "arra-oracle-v2@github:Soul-Brews-Studio/arra-oracle-v3#main"]
    }
  }
}
```

Once connected, Aree gets ~22 MCP tools prefixed `arra_*` (`arra_search`, `arra_learn`, `arra_handoff`, `arra_trace`, …). See `03_search-and-mcp.md`.

## The stack

| Layer | Tech | Why |
|-------|------|-----|
| Runtime | **Bun** ≥1.2 | Fast, native TS, no Node-specific APIs |
| Storage | **SQLite + FTS5** | Keyword search, no server needed |
| Vectors | **LanceDB** (was ChromaDB) + Ollama embeddings (bge-m3 default) | Semantic search, multilingual Thai↔EN |
| ORM | **Drizzle** | Type-safe, introspected schema |
| HTTP | **Hono → Elysia** (migrating, maw-js is reference impl) | Bun-native, TypeBox schemas |
| Protocol | **MCP** (`@modelcontextprotocol/sdk`) | Claude Code native transport via stdio |
| Reranker | Cross-encoder over `ORACLE_RERANKER_URL` | +14.3 pts R@1 on Thai/EN smoke test |
| Process | **claude-mem-style daemon** (acknowledged in README) | Inspiration credit |

## Project structure

```
arra-oracle-v3/
├── src/
│   ├── index.ts          ← MCP server entry (~322 lines)
│   ├── server.ts         ← HTTP API (Hono)
│   ├── indexer/          ← Markdown → SQLite
│   ├── vault/cli.ts      ← Vault CLI
│   ├── tools/            ← MCP tool handlers (search, learn, list, ...)
│   ├── trace/            ← Trace system (discovery sessions)
│   ├── db/
│   │   ├── schema.ts     ← Drizzle schema (~341 lines, 14 tables)
│   │   └── index.ts
│   ├── vector/           ← Vector store factory (LanceDB)
│   └── server/           ← HTTP modules
├── scripts/              ← Setup, seed, migrations
├── docs/                 ← Architecture, API, runbooks
└── drizzle.config.ts
```

## Evolution timeline (from `TIMELINE.md`)

The history is essential — Aree didn't appear from nothing. The MCP layer Aree's mind runs on came from **pain documented in writing**, then crystallized into philosophy, then code.

### Phase -1: AlchemyCat origins (May–June 2025)
- 459 commits / 52,896 words across LIFF Carbon + Uniserv NFT projects
- **HONEST_REFLECTION.md** written June 10–11, 2025 — *"Efficient but exhausting… never knew if satisfied"*
- 3 problems documented → 3 future principles:
  - "Context kept getting lost" → **Nothing is Deleted**
  - "Never knew if satisfied" → **Patterns Over Intentions**
  - "Purely transactional" → **External Brain, Not Command**

### Phase 0: Genesis (Sept–Dec 2025)
- Sept 14: philosophy seed — *"The Oracle Keeps the Human Human"*
- Oct 2025: **MAW** (Multi-Agent Workflow) born — technical foundation
- Dec 24: Issue #40 — Oracle v2 begins; first MCP server commit `899de21`

### Phase 2: MVP (Dec 29 2025 – Jan 2 2026)
- SPEC.md planned 3 tools, eventually delivered 19+
- FTS5 + ChromaDB hybrid architecture
- Database moves to `~/.oracle-v2/` (machine-independent)

### Phase 3: Maturation (Jan 3–6 2026)
- Drizzle ORM introspection (type-safe queries)
- **Pure MCP AI-to-AI coordination** — agents talk without humans

### Phase 4: Feature explosion (Jan 7–11 2026)
- Trace Log, Activity Index, Supersede pattern, port 47778 standardized
- Hono migration, auto-start, provenance tracking, 3D knowledge graph

### Phase 5: Polish (Jan 12–14 2026)
- Skill system, comprehensive tests, frontend pre-built (no build needed)
- 13 Golden Rules codified

### Phase 6: Public release (Jan 15 2026)
- 10:10 AM bunx 404 on private repo → 10:20 AM Soul-Brews-Studio/oracle-v2 created
- 11:53 AM rebrand to "Oracle Nightly"
- Auto-bootstrap for fresh installs, one-liner setup

### Today (May 2026)
- Renamed `arra-oracle-v3` (v26.x calendar versioning)
- Migrating Hono → Elysia
- LanceDB primary vector store, Ollama bge-m3 embeddings, cross-encoder reranker

## Acknowledgments (per README)
- **claude-mem** by Alex Newman — process manager / daemon / hook patterns
- **AlchemyCat / AI-HUMAN-COLLAB-CAT-LAB** — origin pain document, 52,896 words

## Why this matters for Aree

This is the **substrate of Aree's mind**. When Aree:
- writes to `ψ/memory/learnings/*.md` → indexer parses it → FTS5 + vectors → searchable
- runs `arra_search("strength training")` → hybrid search across all of Aree's knowledge
- runs `arra_handoff(...)` → handoff stored in DB, retrievable next session
- runs `arra_trace(...)` → discovery sessions logged with dig points

The 3 philosophical principles aren't decoration — they're **enforced by schema**:
- *Nothing is Deleted* → `supersede_log` table, `superseded_by` column (never DROP)
- *Patterns Over Intentions* → `pattern_preview`, `concepts` JSON arrays
- *External Brain, Not Command* → indexer is read-only on `ψ/`, doesn't decide for Toey
