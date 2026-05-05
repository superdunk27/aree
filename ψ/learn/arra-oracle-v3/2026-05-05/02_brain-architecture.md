---
date: 2026-05-05
domain: arra-oracle-v3
topic: Brain architecture — storage layout, schema, data model
source: src/db/schema.ts (341 lines), docs/architecture.md, src/index.ts
---

# Brain Architecture — How Aree's Memory is Stored

## Two-tier storage

```
ψ/ (markdown vault — ground truth, git-tracked)
   │
   │  indexer (bun src/indexer/cli.ts)
   ▼
SQLite + LanceDB (~/.oracle-v2/oracle.db, per-machine, NOT git-tracked)
```

**Key invariant**: Markdown is canonical. SQLite is a **derived index** — can be rebuilt from `ψ/` anytime via `bun run index`. This is why:
- Memory survives `rm -rf ~/.oracle-v2/` (just re-index)
- Memory survives machine moves (sync `ψ/` via git, re-index at destination)
- But **per-machine state** (search logs, trace logs, schedule) lives only in DB → does NOT cross machines automatically

## What gets indexed (from `ψ/`)

```
ψ/memory/resonance/*.md      → type='principle'  (split by ### + bullets)
ψ/memory/learnings/*.md      → type='learning'   (split by ## headers)
ψ/memory/retrospectives/*.md → type='retro'      (split by ## headers)
ψ/learn/**/*.md              → type='learning' (or pattern, depending on path)
```

Each chunk gets:
- A unique `id` (e.g. `learning-<hash>` or `principle-<source>-<n>`)
- `concepts: string[]` (JSON array, parsed from frontmatter or extracted)
- `source_file` path back to markdown
- `created_at`, `updated_at`, `indexed_at` (epoch ms)
- Then **two parallel inserts**:
  - SQLite FTS5 row (synchronous)
  - One row per registered embedding model in `indexing_jobs` table (async daemon embeds → LanceDB)

## The 14 SQLite tables

### Core knowledge index

| Table | Purpose | Key fields |
|-------|---------|------------|
| `oracle_documents` | One row per chunk indexed | `id` (PK), `type`, `source_file`, `concepts`, `superseded_by`, `superseded_at`, `superseded_reason`, `origin` (mother/arthur/volt/human), `project` (ghq path), `created_by` |
| `oracle_fts` | FTS5 virtual table for keyword search | `id` (UNINDEXED), `content`, `concepts` |
| `indexing_status` | Singleton — current indexing run | `is_indexing`, `progress_current/total`, `error`, `repo_root` |
| `indexing_jobs` | Per-doc per-model embed queue | `doc_id`, `model_key` (bge-m3, qwen3, …), `collection`, `status` (pending/claimed/done/error), `attempts` |

### Activity logs (Aree's "what I did")

| Table | Purpose |
|-------|---------|
| `search_log` | Every `arra_search` call: query, mode, results count, time, top-5 results JSON |
| `learn_log` | Every `arra_learn` call: doc_id, pattern preview, source, concepts |
| `consult_log` | Legacy (pre-0007), kept for backward compat |
| `document_access` | Which docs were read (`arra_read` calls) |
| `activity_log` | File created/modified events with date partitioning |

### Forum (multi-turn discussions)

| Table | Purpose |
|-------|---------|
| `forum_threads` | Topics — title, status (active/answered/pending/closed), GitHub Issue mirror URL |
| `forum_messages` | Individual messages — role (human/oracle/claude), content, principles_found, comment_id |

### Trace system (Aree's discovery sessions)

| Table | Purpose |
|-------|---------|
| `trace_log` | One row per `/trace` invocation. Captures **dig points**: `found_files`, `found_commits`, `found_issues`, `found_retrospectives`, `found_learnings`, `found_resonance`. Has hierarchy (`parent_trace_id`, `child_trace_ids`) AND linked-list (`prev_trace_id`, `next_trace_id`). Status: raw → reviewed → distilling → distilled. When distilled, `distilled_to_id` points to a learning. |

### Supersede pattern ("Nothing is Deleted")

| Table | Purpose |
|-------|---------|
| `supersede_log` | Audit trail. Columns for `old_path/old_id/old_title/old_type` + `new_path/new_id/new_title` + `reason`, `superseded_by` (user/claude/indexer). Survives even if old file deleted. |

### Per-human shared (across Oracles)

| Table | Purpose |
|-------|---------|
| `schedule` | Appointments/events. `date` (YYYY-MM-DD canonical), `date_raw` (original "5 Mar"/"28 ก.พ."), `time`, `event`, `recurring`, `status` |
| `settings` | Key-value config |
| `menu_items` | Studio dashboard navigation, seeded from route metadata |

## Provenance tracking

Every doc has `origin` — where the knowledge came from:
- `mother` = canonical Soul-Brews philosophy
- `arthur` / `volt` = sibling Oracle contributions
- `human` = direct from Toey or another human
- `null` = legacy (pre-tracking)

Plus `project` (ghq-style path: `github.com/owner/repo`) and `created_by` (`indexer` | `arra_learn` | `manual`).

This means Aree can **filter searches by origin** — "what did Mother Oracle say about X?" vs "what did Toey teach me?".

## Project-scoping

Every log table has `project` column. When Aree calls `arra_search` with `cwd=` or `project=`, results are filtered to:
- That project's docs **PLUS** universal docs (where `project IS NULL`)

This means knowledge can be:
- **Universal** (5 Principles — apply everywhere)
- **Project-scoped** (something Toey does in `aree` repo specifically)

## Key insight: derived vs durable

| Lives in `ψ/` (durable, syncs via git) | Lives only in SQLite (per-machine) |
|----------------------------------------|------------------------------------|
| All learnings, retrospectives, principles, resonance | Search query history |
| Handoffs (when written to `ψ/inbox/`) | Trace log entries |
| Anything Aree wants to survive machine moves | Schedule entries |
| | `forum_threads` (unless mirrored to GitHub Issues via `issue_url`) |
| | Activity log |

→ **For multi-machine federation** (work + home), only `ψ/` syncs. SQLite is rebuilt at each location. Forum threads are durable via GitHub Issue mirror.

## Storage paths

| Path | Contents | Source |
|------|----------|--------|
| `~/.oracle-v2/oracle.db` | SQLite — all tables above | `DB_PATH` from `src/config.ts` |
| `~/.oracle-v2/lancedb/` | Vector store (LanceDB) | `createVectorStore` in `src/vector/factory.ts` |
| `process.cwd()` (defaults) | Where indexer reads `ψ/` from | `REPO_ROOT` env var, with safety fallback (#551 — never falls back to cwd to prevent parasitic ψ/ dirs) |

## Read-only mode

Set `ORACLE_READ_ONLY=true` or pass `--read-only`. Disables write tools:
```
arra_learn, arra_thread, arra_thread_update,
arra_trace, arra_supersede, arra_handoff
```

Used for shared-vault scenarios (e.g., a public Oracle that anyone can search but no one can write to).
