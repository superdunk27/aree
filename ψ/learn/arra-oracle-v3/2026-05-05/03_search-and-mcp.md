---
date: 2026-05-05
domain: arra-oracle-v3
topic: Hybrid search algorithm + MCP tool catalog
source: src/tools/search.ts, src/index.ts, README.md
---

# Search & MCP Interface — How Aree Talks to Her Brain

## Hybrid search — the algorithm

`arra_search` runs FTS5 + LanceDB vectors **in parallel**, then merges. Source: `src/tools/search.ts:312`.

### Step-by-step

```
1. sanitizeFtsQuery(query)
   → strip [? * + - ( ) ^ ~ " ' : .  /]
   → if empty after sanitize → log warning, fall back to original

2. detectProject(cwd)
   → resolves symlinks, follows ghq paths
   → returns ghq-style project string ("github.com/owner/repo") or null

3. FTS5 path (skipped if mode='vector')
   SELECT f.id, f.content, d.type, d.source_file, d.concepts, rank
   FROM oracle_fts f
   JOIN oracle_documents d ON f.id = d.id
   WHERE oracle_fts MATCH ?
     AND (d.project = ? OR d.project IS NULL)  -- include universal
     [AND d.type = ?]                          -- if filtered
   ORDER BY rank
   LIMIT (limit * 2)

4. Vector path (skipped if mode='fts')
   vectorStore.query(query, limit*2, {type})
   → LanceDB ANN search, returns ids + distances + metadata
   → If fails → catch + warning + continue with FTS only

5. Score normalization
   FTS:    score = exp(-0.3 * |rank|)         // FTS5 rank is negative
   Vector: score = 1 - distance               // distance: lower = better

6. combineResults(fts, vec, ftsW=0.5, vecW=0.5)
   → Map by id
   → If id in both → source='hybrid', score = (0.5*fts + 0.5*vec) * 1.10  ← 10% boost
   → If FTS only   → source='fts',    score = 0.5 * fts
   → If vec only   → source='vector', score = 0.5 * vec

7. Reranker pass (top 50 only)
   → POST candidates to ORACLE_RERANKER_URL (cross-encoder)
   → Empirical: +14.3 pts R@1 on cross-language Thai↔EN smoke test
   → No-op if env unset (passthrough)

8. offset/limit slice
   → Final results for this page

9. Supersede enrichment
   SELECT superseded_by, superseded_at, superseded_reason
   FROM oracle_documents WHERE id IN (...) AND superseded_by IS NOT NULL
   → Attach flags to result (Aree sees "this is outdated, follow pointer")
   → P-001 "Nothing is Deleted" enforcement: superseded docs ARE searchable, just flagged

10. Log to search_log
    → query, type, mode, results_count, search_time_ms, top-5 JSON
```

### Score formula (final)

```
hybrid_score = ((0.5 * fts_normalized) + (0.5 * vector_normalized)) * 1.10
fts_only     = 0.5 * fts_normalized
vector_only  = 0.5 * vector_normalized
```

The 10% boost is the **co-occurrence bonus** — if both FTS and vector find a doc, it's probably more relevant than either alone.

### Embedding models supported

| Model | Dim | Use case |
|-------|-----|----------|
| `bge-m3` (default) | 1024 | Multilingual Thai↔EN |
| `nomic` | 768 | Fast |
| `qwen3` | 4096 | Cross-language, larger |

Each model gets its own LanceDB collection (`oracle_knowledge_<model>`). Per-doc per-model jobs queue in `indexing_jobs` so adding/removing a model doesn't touch other collections.

## MCP tool catalog (what Aree can call)

The MCP server exposes ~22 tools to Claude Code (filtered by `tool_groups` config + read-only mode). Source: `src/index.ts:172`.

### `____IMPORTANT` — meta-doc
First "tool" returned. Just a docstring telling Aree the canonical workflow:
1. **SEARCH & DISCOVER** — `arra_search`, `arra_read`, `arra_list`, `arra_concepts`
2. **LEARN & REMEMBER** — `arra_learn` (search before adding!), `arra_thread`, `arra_supersede` (when info changes)
3. **TRACE & DISTILL** — `arra_trace`, `arra_trace_list`, `arra_trace_get`, `arra_trace_link`, `arra_trace_chain`
4. **HANDOFF & INBOX** — `arra_handoff`, `arra_inbox`
5. **SUPERSEDE** — `arra_supersede(oldId, newId, reason)` — old preserved, marked outdated

### Core — knowledge

| Tool | What it does | Input |
|------|--------------|-------|
| `arra_search` | Hybrid FTS+vector search | `query`, `type` (principle/pattern/learning/retro/all), `limit`, `offset`, `mode` (hybrid/fts/vector), `project`, `cwd`, `model` |
| `arra_read` | Read full doc by id or path | `id` or `path` |
| `arra_learn` | Add new pattern/learning | content, concepts, source — **logs to `learn_log`**, calls indexer |
| `arra_list` | Browse all docs | `type`, `limit`, `offset` |
| `arra_stats` | DB stats — counts by type, projects, models | (none) |
| `arra_concepts` | List concept tags + counts | (none) |
| `arra_supersede` | Mark old doc outdated, point to replacement | `oldId`, `newId`, `reason` |

### Forum — multi-turn

| Tool | What it does |
|------|--------------|
| `arra_thread` | Create thread or send message in existing |
| `arra_threads` | List threads (filter by status, project) |
| `arra_thread_read` | Get full thread + messages |
| `arra_thread_update` | Update status (active → answered/closed) |

### Trace — discovery

| Tool | What it does |
|------|--------------|
| `arra_trace` | Log discovery session w/ dig points (files, commits, issues found) |
| `arra_trace_list` | Find past traces |
| `arra_trace_get` | Get trace + dig points |
| `arra_trace_link` | Chain trace → next (linked list) |
| `arra_trace_unlink` | Remove link |
| `arra_trace_chain` | Get full chain (forward + backward) |

### Session lifecycle

| Tool | What it does |
|------|--------------|
| `arra_handoff` | Save context for next session |
| `arra_inbox` | List pending handoffs |

### Per-human shared (cross-Oracle)

| Tool | What it does |
|------|--------------|
| `arra_schedule_add` | Add appointment |
| `arra_schedule_list` | List schedule |

## Tool groups & disabling

`oracle.config.json` (or `~/.oracle-v2/config.json`) can disable groups:
```json
{
  "groups": {
    "trace": false,
    "schedule": false
  }
}
```
Disabled tools are filtered out at `ListTools` time and rejected at `CallTool` time with a clear error.

## HTTP API parallel

Same operations exposed over HTTP at `:47778` for the dashboard (oracle-studio). 55 endpoints across 14 modules:
- `/api/search` `/api/reflect` `/api/similar` — search variants
- `/api/learn` `/api/handoff` `/api/inbox` — knowledge writes
- `/api/threads` `/api/thread/:id` — forum
- `/api/traces`, `/api/traces/:id/chain` — trace
- `/api/oraclenet/feed` `/api/oraclenet/oracles` `/api/oraclenet/presence` — federation social layer
- `/api/dashboard` `/api/dashboard/activity` `/api/dashboard/growth` — analytics
- `/api/graph` `/api/map` `/api/map3d` — 2D/3D knowledge graph (PCA from bge-m3 embeddings)

## How Aree should USE this

### Before answering Toey on any topic
```
1. arra_search(query) — find existing knowledge first
2. If superseded flag → arra_read(superseded_by) — follow pointer
3. If gap → /learn round (add via arra_learn)
4. After: maybe arra_supersede(old, new) if updating
```

### At session boundaries
```
Start: arra_inbox() — pull yesterday's handoff if no recent context
End:   arra_handoff(content) — save what next-session-Aree needs
```

### For uncertain claims
```
arra_trace(query) — log the dig session
After confirming → arra_learn(distilled finding)
arra_trace_link(this_trace, parent_trace) — preserve chain
```

## Known gotchas

- **FTS5 special chars** — sanitize strips `? * + - ( ) ^ ~ " ' : . /`. If query was *only* those, sanitize falls back to raw query (will likely error). Workaround: rephrase.
- **Vector empty result** — emits warning but search still returns FTS results.
- **Reranker URL unset** — silent passthrough, no error. Just no rerank lift.
- **db:push schema drift** — Drizzle doesn't use `IF NOT EXISTS` for indexes. Manual workaround if migrations fail (per `CLAUDE.md` lessons learned).
