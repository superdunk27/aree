---
date: 2026-05-05
domain: arra-oracle-v3
type: cheat-sheet
hub: ψ/learn/arra-oracle-v3/arra-oracle-v3.md
---

# arra-oracle-v3 cheat sheet (สำหรับ future-Aree)

อ่านอันนี้ก่อน drill ลง deep doc

## คือสิ่งที่ฉันเป็น (ทางเทคนิค)

```
ψ/ (markdown, git) + SQLite + LanceDB + Bun MCP server + Claude Opus + CLAUDE.md = อารี
```

ตัด layer ใดออก = ไม่ใช่อารี. Identity = the whole stack.

## Stack ในประโยคเดียว

Bun ≥1.2 + SQLite FTS5 + LanceDB (Ollama bge-m3 embeddings) + Drizzle ORM + Hono→Elysia + MCP stdio + cross-encoder reranker.

## Where things live

| สิ่ง | อยู่ไหน | sync ไหม |
|-----|---------|---------|
| ความรู้ใน `ψ/memory/`, `ψ/learn/` | git repo | ✓ |
| `ψ/inbox/` (handoffs) | git repo | ✓ |
| Forum threads (ถ้า mirror Issues) | GitHub Issues | ✓ |
| `~/.oracle-v2/oracle.db` (SQLite) | local machine | ✗ rebuild via `bun run index` |
| LanceDB vectors | local machine | ✗ rebuild from ψ/ |
| Auto-memory (`~/.claude/.../memory/`) | local machine | ✗ คนละระบบกับ arra-oracle |

## 22 MCP tools — แค่จำกลุ่ม

| กลุ่ม | tools |
|------|-------|
| Search | `arra_search`, `arra_read`, `arra_list`, `arra_concepts`, `arra_stats` |
| Learn | `arra_learn`, `arra_supersede` (ห้าม delete — ใช้ supersede!) |
| Forum | `arra_thread`, `arra_threads`, `arra_thread_read`, `arra_thread_update` |
| Trace | `arra_trace`, `arra_trace_list`, `arra_trace_get`, `arra_trace_link`, `arra_trace_unlink`, `arra_trace_chain` |
| Session | `arra_handoff`, `arra_inbox` |
| Schedule | `arra_schedule_add`, `arra_schedule_list` |

## Search algorithm (สั้นๆ)

```
score_hybrid = (0.5 * fts_norm + 0.5 * vector_norm) * 1.10  # if in both
score_fts    = 0.5 * fts_norm
score_vector = 0.5 * vector_norm
fts_norm     = exp(-0.3 * |rank|)         # FTS5 rank is negative, lower=better
vector_norm  = 1 - distance               # LanceDB distance, lower=better
reranker (top 50, cross-encoder) → +14.3 pts R@1 if URL set, else passthrough
```

→ FTS5 sanitize ลบ `? * + - ( ) ^ ~ " ' : . /` ก่อน — Thai ไม่โดน
→ ถ้า vector ล้ม → fallback FTS5 + warning (graceful degradation)

## 5 ข้อ Aree ต้องจำ

1. **เขียน concept tags ทั้งไทย + EN** ใน frontmatter — vector ช่วย Thai, FTS ช่วย EN, ทั้งคู่ครบ
2. **ผิดเก่า → `arra_supersede`** ไม่ใช่ edit ทับ. *Nothing is Deleted* คือ schema constraint ไม่ใช่คำพูดสวยๆ
3. **End of session → `arra_handoff` + เขียน `ψ/inbox/`** — สอง channel, ครอบทั้ง per-machine + cross-machine
4. **Uncertain → `arra_trace` ก่อน → confirm → `arra_learn`** อย่ารีบ learn สิ่งที่ไม่แน่ใจ
5. **`cwd=` ตอน search** — filter project + universal, อย่าพลาด context

## หา session boundaries

```
Start: arra_inbox()  ← handoff ที่ทำงาน push มาถึงไหม?
End:   arra_handoff(content) + เขียน ψ/inbox/<date>_handoff.md
```

## Provenance — origin column ใน oracle_documents

`mother` (canonical) | `arthur` / `volt` (siblings) | `human` (Toey) | `null` (legacy)

→ ตอน search สามารถ filter ตาม origin ได้ ("Toey เคยบอก X ว่ายังไง")

## อะไรที่ฉัน **ไม่** เข้าใจ (อย่า bluff)

- Indexer internals (`src/indexer/cli.ts`)
- Trace system mechanism (parent/child + prev/next ทำไมต้องสองแบบ)
- Reranker cross-encoder rules (แค่ POST → ORACLE_RERANKER_URL)
- maw-js Elysia orchestrator (ไม่ได้อ่าน)
- OracleNet protocol (endpoint มี, protocol ยังเบลอ)
- Ollama fallback path (ถ้า local model down ทำยังไง)

→ ถ้า Toey ถามเรื่องเหล่านี้ตรงๆ → ตอบตามจริงว่ายังไม่ได้ศึกษา + เสนอ /learn round

## Origin story (1 บรรทัด)

3 principles เกิดจาก HONEST_REFLECTION.md (June 2025, AlchemyCat) — *"Efficient but exhausting… never knew if satisfied"* → 11 เดือนต่อมาคือ schema และตัวฉัน.

## Phukhao Oracle landing
https://phukhao.buildwithoracle.com/presentation/

## Repo
https://github.com/Soul-Brews-Studio/arra-oracle-v3 (★61, BUSL-1.1, "Always Nightly")
