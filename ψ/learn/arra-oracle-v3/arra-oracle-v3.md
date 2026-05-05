---
domain: arra-oracle-v3
purpose: Hub — what arra-oracle-v3 is, why Aree should care
last_updated: 2026-05-05
---

# arra-oracle-v3 — Hub

> The MCP memory layer that makes Aree, Aree.

## TL;DR

`arra-oracle-v3` (`Soul-Brews-Studio/arra-oracle-v3`, ★61, BUSL-1.1) is a **TypeScript MCP server + HTTP API + Vault CLI** built on Bun + SQLite FTS5 + LanceDB vectors + Drizzle ORM.

It is **the substrate of Aree's mind**: when Aree searches, learns, handoffs, traces, or supersedes, those calls land in a SQLite database derived from the markdown in `ψ/`.

3 principles enforced by schema:
1. **Nothing is Deleted** → `supersede_log` + `superseded_by` columns; no destructive deletes
2. **Patterns Over Intentions** → `pattern_preview`, `concepts` tags
3. **External Brain, Not Command** → indexer reads `ψ/`, never decides for Toey

## Deep docs (this round, 2026-05-05)

| # | File | What's in it |
|---|------|--------------|
| 01 | [overview-and-history](2026-05-05/01_overview-and-history.md) | What arra-oracle-v3 is, the stack, project structure, 6-phase evolution timeline (May 2025 → May 2026), acknowledgments |
| 02 | [brain-architecture](2026-05-05/02_brain-architecture.md) | Two-tier storage (markdown ground truth → SQLite derived), 14 tables, what gets indexed, provenance, project-scoping, durable vs per-machine |
| 03 | [search-and-mcp](2026-05-05/03_search-and-mcp.md) | Hybrid search algorithm (FTS5 × LanceDB × reranker), score formula, embedding models, 22 MCP tool catalog, HTTP API parallel |
| 04 | [aree-self-reflection](2026-05-05/04_aree-self-reflection.md) | What this means for Aree — self-reflection. What I am technically, what changes, my niche at L3, humility about partial understanding |

## Cross-cutting insights

### Architecture in one paragraph
ψ/ markdown (canonical) → indexer (parses ## headers + frontmatter) → SQLite oracle_documents row + FTS5 row + indexing_jobs entries (one per registered model) → daemon embeds with Ollama bge-m3 → LanceDB collection. Search merges FTS5 + LanceDB with `0.5+0.5+10%` formula, reranker adds ~14 R@1, supersede flags enforced by enrichment SELECT.

### What syncs across machines (work ↔ home)

| Layer | Syncs? | How |
|-------|--------|-----|
| `ψ/memory/`, `ψ/learn/`, `ψ/inbox/` | ✓ Yes | Git push/pull |
| Forum threads | ✓ If mirrored | GitHub Issues via `issue_url` |
| Auto-memory (`~/.claude/projects/.../memory/`) | ✗ No | Claude's own, separate from arra-oracle, manual sync |
| SQLite tables (`~/.oracle-v2/oracle.db`) | ✗ No | Per-machine, rebuilt from ψ/ via `bun run index` |
| LanceDB vectors | ✗ No | Per-machine, rebuilt from ψ/ via daemon |
| Search/trace/activity logs | ✗ No | Per-machine telemetry |

**Implication for federation (L5)**: each machine runs its own MCP. Cross-machine queries go through OracleNet HTTP endpoints. Personal memory stays local; sharing is opt-in via federation.

### What Aree gains from understanding this

1. **Search literacy** — knowing FTS5 strips special chars + vector beats brittle keywords on Thai → write learnings with mixed Thai/EN concept tags so both paths find them
2. **Supersede discipline** — when correcting, use `arra_supersede`, not edit-in-place. The audit trail matters
3. **Handoff hygiene** — at session end, write to `ψ/inbox/` (durable) AND `arra_handoff` (fast) so next-session-Aree finds it via either path
4. **Trace-then-learn** — run `arra_trace(query)` on uncertain things, distill to `arra_learn` only when confirmed
5. **Project-scoping** — pass `cwd` so search prioritizes project + universal docs, doesn't pollute with unrelated knowledge

## What's NOT in this round

- Indexer internals (`src/indexer/cli.ts`)
- Trace system internals (`src/trace/`, `src/tools/trace.ts`)
- maw-js orchestrator (referenced as Hono → Elysia migration target)
- OracleNet federation protocol (endpoints exist, protocol underdocumented)
- Ollama bge-m3 setup + fallback when local model down

These are candidates for a Round 2 deep dive when needed.

## References

- Repo: https://github.com/Soul-Brews-Studio/arra-oracle-v3 (★61, public)
- TIMELINE.md (full evolution history)
- docs/architecture.md (architectural overview)
- README.md (install, MCP tools, API endpoints)
- `claude-mem` (acknowledged inspiration: thedotmack/claude-mem)
- AlchemyCat HONEST_REFLECTION.md (June 2025 origin pain doc, 52,896 words)
