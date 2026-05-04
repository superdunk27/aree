# Arra Oracle v3 — Quick Reference

> **Arra Oracle** is a TypeScript MCP server that makes Oracle philosophy queryable. It combines SQLite FTS5 keyword search with ChromaDB semantic vectors to index and retrieve wisdom from markdown files (principles, patterns, learnings, retrospectives). Exposes 22 MCP tools to Claude Code + HTTP API for dashboards and vault CLI for GitHub-backed knowledge sync.

**Who uses it:** Claude Code agents + dashboard UIs + CLI automation  
**Problem solved:** Turn scattered markdown philosophy into a searchable memory layer with versioning ("Nothing is Deleted")

---

## Install / Run Cheat Sheet

### Via bunx (recommended — no local clone)
```bash
# Add to Claude Code
claude mcp add arra-oracle-v2 -- bunx --bun arra-oracle-v2@github:Soul-Brews-Studio/arra-oracle-v3#main

# Run MCP server standalone
bunx --bun arra-oracle-v2@github:Soul-Brews-Studio/arra-oracle-v3#main

# Run HTTP API
bunx --bun --package arra-oracle-v2@github:Soul-Brews-Studio/arra-oracle-v3#main bun run server

# Run vault CLI
bunx --bun --package arra-oracle-v2@github:Soul-Brews-Studio/arra-oracle-v3#main oracle-vault --help
```

### From source (dev)
```bash
git clone https://github.com/Soul-Brews-Studio/arra-oracle-v3.git
cd arra-oracle-v3 && bun install

bun run dev             # MCP server (stdio transport)
bun run server          # HTTP API on :47778
bun run index           # Index ψ/memory files → SQLite + ChromaDB
bun test                # Run test suite
```

### First-time setup (fresh install)
```bash
# Database schema
bun db:push

# Seed philosophy files
ORACLE_REPO_ROOT=~/.oracle/seed bun run index

# Verify
curl http://localhost:47778/api/stats
```

---

## 22 MCP Tools (Alphabetical)

| Tool | Purpose |
|------|---------|
| `arra_concepts` | List all concept tags / topic coverage |
| `arra_handoff` | Save session context + inbox message for next agent |
| `arra_inbox` | List pending handoff messages |
| `arra_learn` | Add new pattern / principle / learning to knowledge base |
| `arra_list` | Browse documents; filter by type, project, concepts |
| `arra_read` | Get full content of a document by ID or file path |
| `arra_reflect` | Random wisdom (pick a document, return one principle) |
| `arra_schedule_add` | Create calendar event / appointment |
| `arra_schedule_list` | List scheduled entries (events, reminders, followups) |
| `arra_search` | Hybrid keyword (FTS5) + semantic (vector) search; filters by type/project/concepts |
| `arra_stats` | Database metrics (doc count, types, memory usage, indexing status) |
| `arra_supersede` | Mark old document as outdated; link to new version (Nothing is Deleted) |
| `arra_thread` | Create forum thread or send message in existing thread |
| `arra_thread_read` | Get all messages in a thread |
| `arra_thread_update` | Update thread status / title |
| `arra_threads` | List all threads with filters |
| `arra_trace` | Log a discovery session (files, commits, issues found; dig points) |
| `arra_trace_chain` | Get full linked chain of related traces (parent → child → ...) |
| `arra_trace_get` | Get full trace details including all dig points |
| `arra_trace_link` | Connect two traces as a chain (prev → next) |
| `arra_trace_list` | Find traces by query, project, status, depth |
| `arra_trace_unlink` | Break a link between two traces |
| `arra_verify` | Verify document authenticity / integrity |

---

## Common Workflows

### Index a Knowledge Base
```bash
# Structure your markdown
~/.oracle/seed/ψ/memory/
├── resonance/
│   ├── oracle.md         # Core principles
│   └── patterns.md       # Decision patterns
└── learnings/
    └── skill-training.md # Lessons learned

# Index it
ORACLE_REPO_ROOT=~/.oracle/seed bun run index

# Server picks it up next restart
bun run server
```

### Search for Wisdom
```bash
# Via MCP (from Claude Code)
arra_search(query: "nothing deleted", type: "principle", limit: 5)

# Via HTTP API
curl "http://localhost:47778/api/search?q=nothing+deleted&type=principle"

# Via CLI (planned)
arra-vault search "force push safety"
```

### Add a Learning
```bash
# When you discover something new
arra_learn(
  content: "Force push breaks history for teammates. Use regular push unless rebasing your own branch.",
  type: "principle",
  concepts: ["git", "safety", "team"]
)

# File goes to:
# ψ/memory/learnings/2026-05-04_force-push.md
# (generated filename + indexed instantly)
```

### Handoff to Next Session
```bash
# Save context + inbox message
arra_handoff(
  content: "Discovered 3 critical refactors needed in indexer.ts. See trace #abc123.",
  relatedTraceId: "abc123"
)

# Next agent reads it
arra_inbox()  # → lists all handoff messages
```

### Trace Discovery Journey
```bash
# Log what you found while exploring
arra_trace(
  query: "How does FTS5 indexing work?",
  foundFiles: [
    { path: "src/indexer.ts", type: "other", confidence: "high" },
    { path: "docs/architecture.md", type: "resonance", confidence: "medium" }
  ],
  foundCommits: [
    { hash: "a1b2c3d", message: "Add FTS5 search layer", date: "2026-04-15" }
  ],
  scope: "project"
)

# Chain related traces
arra_trace_link(prevTraceId: "trace1", nextTraceId: "trace2")

# View the chain
arra_trace_chain(id: "trace1")
```

---

## Glossary (Codebase Context)

**Vault**  
GitHub-backed knowledge storage. CLI commands (`oracle-vault init`, `oracle-vault sync`) sync ψ/ to/from a GitHub repo — enables multi-human collaboration on knowledge.

**Indexer**  
`src/indexer.ts` + `src/indexer/cli.ts`. Scans ψ/memory/ tree, parses markdown (split by `###` bullets for principles, `##` headers for learnings), writes to SQLite + ChromaDB. Run via `bun run index`.

**MCP**  
Model Context Protocol. Binds tools to Claude Code via stdio transport. Server lives in `src/index.ts`, handlers in `src/tools/`.

**oracle_learn**  
Tool that captures new patterns. Writes `.md` file to ψ/memory/, auto-indexes, returns document ID.

**oracle_supersede**  
Mark an old document as superseded by a new one. Old document stays in DB (Nothing is Deleted), but `superseded_by` field points to the newer version. Used when knowledge evolves.

**FTS5**  
SQLite Full-Text Search extension. Fast keyword matching with phrase & boolean operators. Fallback when ChromaDB unavailable.

**ChromaDB / LanceDB**  
Vector database for semantic search. Stores embeddings (BGE-M3 via Ollama). `arra_search` with `mode: vector` uses it; gracefully falls back to FTS5 if unavailable.

**Trace**  
Discovery log. Records: what was explored, files found, commits discovered, GitHub issues, scope (project vs cross-project vs human). Traces can be linked into chains. Used for audit + future re-exploration.

---

## Configuration Touchpoints

**Environment Variables**  
| Var | Default | Purpose |
|-----|---------|---------|
| `ORACLE_REPO_ROOT` | `~/.oracle` (if ψ/ exists, else PROJECT_ROOT) | Where ψ/memory/ lives |
| `ORACLE_DATA_DIR` | `~/.oracle` | Where `.db`, `.lancedb/`, seed files go |
| `ORACLE_DB_PATH` | `~/.oracle/oracle.db` | SQLite database path |
| `ORACLE_PORT` | `47778` | HTTP server port |
| `VECTOR_URL` | `` (empty = local) | Optional vector proxy URL |
| `VECTOR_FALLBACK` | `fts5` | When vector unavailable: `fts5` (FTS5 only) or `fail` |

**Files to Know**  
| File | Purpose |
|------|---------|
| `drizzle.config.ts` | Database schema config + table list |
| `src/config.ts` | Resolves REPO_ROOT, DATA_DIR, DB_PATH (never use cwd!) |
| `src/db/schema.ts` | Drizzle ORM table definitions (oracle_documents, search_log, trace_log, etc.) |
| `src/tools/index.ts` | Tool definitions + exports |
| `bunfig.toml` | Bun runtime config (test roots, node_modules path) |

**Database Schema Workflow**  
```bash
# Update src/db/schema.ts, then:
bun db:generate    # Generate migration
bun db:push        # Apply to SQLite
bun db:studio      # Open Drizzle Studio GUI
```

---

## 5 Non-Obvious Things

### 1. **REPO_ROOT Never Falls Back to cwd()**  
`src/config.ts` has a three-tier priority: (1) `ORACLE_REPO_ROOT` env var, (2) `ORACLE_DATA_DIR/ψ/` if exists, (3) `PROJECT_ROOT/ψ/` if exists, (4) default to `ORACLE_DATA_DIR`. This prevents parasitic ψ/ folders from spawning in random directories when MCP server starts. **Always set `ORACLE_REPO_ROOT` explicitly in production.**

### 2. **ChromaDB Not Required — FTS5 Is Enough**  
Vector search is optional. If ChromaDB hangs or uvx is unavailable, indexer + search fallback to FTS5-only. `vectorStatus` field in `ToolContext` tells tools whether vectors are `connected` or `unavailable`. Hybrid search still works; just no semantic ranking.

### 3. **Nothing is Deleted — Use oracle_supersede for Versioning**  
Old documents never leave the DB. Instead, mark them with `superseded_by: newer_doc_id`. Tools filter superseded docs from results by default, but audit trails stay intact. This honors the "Nothing is Deleted" philosophy.

### 4. **Tool Groups Can Be Disabled**  
`src/config/tool-groups.ts` + `tool-groups.json` allow disabling entire tool groups (e.g., forum, trace, schedule). Read-only mode also disables write tools. Use to lock down production Claude instances.

### 5. **Traces Form Chains, Not Trees**  
Each trace can have one parent + one child (forward/backward links via `arra_trace_link`). This creates a doubly-linked list, not a tree. `arra_trace_chain()` walks the full chain in one direction. Useful for reconstructing investigation workflows.

---

**Tech Stack Summary:**  
Bun 1.2+ | TypeScript | SQLite + FTS5 | Drizzle ORM | Elysia (migrating from Hono) | MCP SDK | LanceDB/ChromaDB | BGE-M3 embeddings

**Repo:** https://github.com/Soul-Brews-Studio/arra-oracle-v3  
**Docs:** `docs/architecture.md`, `docs/API.md`, `docs/INSTALL.md`, `docs/LOCAL-DEV.md`  
**Reference:** `src/index.ts` (MCP server), `src/server.ts` (HTTP API), `src/tools/` (tool handlers)
