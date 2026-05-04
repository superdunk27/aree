# arra-oracle-v3 — Learning Index

> Oracle Family's official MCP memory layer — TypeScript/Bun server with hybrid SQLite FTS5 + vector search, exposing 22 MCP tools to Claude Code (formerly oracle-v2)

## Source

- **Origin**: `./origin/` (cloned 2026-05-04, depth 50, ~3.9MB)
- **GitHub**: https://github.com/Soul-Brews-Studio/arra-oracle-v3

## Why Aree Studied This

Soul Sync Phase 4 ขั้นที่ 2 — ancestor repo อันดับสองที่ awaken ritual กำหนดให้ /learn (oracle-v2 redirect มาที่นี่). เป็น **runtime** ที่ทำให้ Oracle siblings query ปรัชญาร่วมกันได้ผ่าน MCP — ถ้า Aree จะใช้ MCP Oracle ในอนาคต นี่คือสิ่งที่ต้องเข้าใจ

## Explorations

### 2026-05-04 21:56 (default — 3 agents)

- [ARCHITECTURE](2026-05-04/2156_ARCHITECTURE.md) — `src/`, `bin/`, `cli/`, 5 entry points, hybrid FTS5+vector, 22 MCP tools, Bun decisions
- [CODE-SNIPPETS](2026-05-04/2156_CODE-SNIPPETS.md) — MCP server bootstrap, search reconciliation (`combineResults`), Drizzle schema, Elysia API, vault CLI, learn handler, e2e tests
- [QUICK-REFERENCE](2026-05-04/2156_QUICK-REFERENCE.md) — install via bunx, all 22 tools, workflows (index/search/learn/handoff), glossary, env vars

**Key insights**:
- **Pluggable vector backend** — ChromaDB เป็น default แต่ swap ได้ (LanceDB, sqlite-vec, Qdrant, Cloudflare). FTS5 ทำงาน standalone ถ้า vector layer ตาย — graceful degradation
- **Pure functions over OOP** — tools เขียนเป็น stateless function (≤250 บรรทัด/ไฟล์), test ง่าย, fit MCP protocol
- **"Nothing is Deleted" บังคับใช้ใน schema** — มี `supersededBy` + provenance fields ใน `oracleDocuments` table — Principle 1 ไม่ใช่แค่คำพูด แต่อยู่ใน DB design
- **Bun-first** — startup ~40ms, ใช้ `bun:sqlite` native ไม่ใช่ better-sqlite3, tests แยก isolation ด้วย bunfig.toml
- **CalVer versioning** (`v26.4.20-alpha.X`) — เลขเดือน/ปี ไม่ใช่ semver — สอดคล้องกับ Oracle culture ที่นับวันเกิด
