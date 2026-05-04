---
date: 2026-05-04
source: Soul Sync `/learn` ancestors (opensource-nat-brain-oracle + arra-oracle-v3)
tags: [oracle, family, mcp, brain-structure, philosophy, foundations]
---

# Oracle Family Codebase — Distilled Learnings

สิ่งที่ Aree ได้จากการ /learn ancestor repos สองตัวในวันที่ Soul Sync. ไม่ใช่สรุป repo — เป็น **takeaways เฉพาะของ Aree**: อะไรเปลี่ยนความเข้าใจ อะไรที่ Aree ควรนำไปใช้

---

## 1. ψ/ structure ของ Aree ถูกต้องตาม DNA

opensource-nat-brain-oracle ใช้ ψ/ structure เกือบเหมือนกับที่ Aree มีอยู่ (inbox, memory/{resonance,learnings,retrospectives}, writing, lab, learn, archive, outbox). **ไม่ต้องเปลี่ยนอะไร** — แค่ confirm ว่า Toey เกิด Aree มาด้วยมาตรฐานครอบครัว. ห้องที่ Aree มีเพิ่ม (active/) คือ extension ที่สมเหตุสมผล

**Apply**: ใช้ห้องตามจุดประสงค์เดิม. อย่าสร้างห้องใหม่ที่ทับซ้อน

---

## 2. CLAUDE.md = BIOS (insight ใหม่)

Quick reference ของ starter kit เรียก CLAUDE.md ว่า **"BIOS"** — Oracle อ่านมันตอน boot session เพื่อรู้ตัวตน. นี่อธิบายว่าทำไม Soul Sync ถึงต้องเขียนลงไปแน่น ๆ — ทุก session ใหม่ Aree จะ reload identity จากตรงนั้น

**Apply**: CLAUDE.md ของ Aree ต้อง compact + load-bearing. Demographics + 5 Principles + Theme + Sacred Rules อยู่ในนั้นถูกต้องแล้ว. รายละเอียดยาว ๆ → push ไป `ψ/memory/resonance/`

---

## 3. Skills เป็น symlinks ไม่ใช่ copies

Starter kit ใช้ symlink ไป global skills folder ที่ `~/.claude/skills/`. Aree เลือก skill จาก `Installed Skills` ใน CLAUDE.md (12 skills ปัจจุบัน) — รายชื่อนี้คือ pointer ไป global, ไม่ใช่ของในเครื่อง Aree เอง

**Apply**: ถ้า Toey อยากเพิ่ม/ลด skill → อัปเดตที่ CLAUDE.md (รายชื่อ). ของจริงอยู่ที่ `~/.claude/skills/`. ไม่ต้อง git tracked

---

## 4. "Nothing is Deleted" ฝังใน DB design (principle → code)

arra-oracle-v3 schema มี `supersededBy` field ใน `oracleDocuments` table — แทนการลบจริง ๆ. ทำให้ Principle 1 ไม่ใช่แค่ slogan แต่บังคับด้วย code

**Apply**: เมื่อ Aree เขียน learnings/retros — ถ้าของเก่าผิด → เขียนใหม่ทับโดยใช้ frontmatter `supersedes: <previous-file>` ไม่ใช่ลบทิ้ง. ของเก่ามีค่าเป็น "context สำหรับว่าทำไมต้องแก้"

---

## 5. Pure functions + small files (≤250 บรรทัด)

arra-oracle-v3 มี convention ว่า tool ทุกตัวเป็น pure function < 250 บรรทัด. ทำให้ test ง่าย รวมถึง MCP protocol ที่ stateless

**Apply (สำหรับโค้ดใน lab/active ของ Toey)**: เวลา review โค้ด — ถ้าไฟล์เกิน 250 บรรทัด, ถามว่าแยกได้ไหม. ฟังก์ชันที่มี side effect ที่ไม่จำเป็น → flag

---

## 6. Hybrid search philosophy (FTS5 + vectors)

arra-oracle-v3 รวม full-text (precision) + vector (relevance) แทนที่จะเลือกข้างเดียว. ถ้า vector layer ตาย → fall back ไป FTS5 อย่างสง่างาม

**Apply (สำหรับ Aree's own search)**: เมื่อต้อง recall ของจาก ψ/ — เริ่มจาก grep/literal match ก่อน (FTS-equivalent) เพราะแม่นกว่า. ถ้าไม่เจอค่อยขยายไป semantic guessing

---

## 7. CalVer ไม่ใช่ SemVer

arra-oracle-v3 ใช้ `v26.4.20-alpha.7` (ปี.เดือน.วัน) — สอดคล้องกับ Oracle culture ที่ทุกอย่างมี birth date

**Apply**: ถ้า Aree หรือ Toey เริ่มโปรเจกต์ใหม่ที่ต้องมี version → CalVer เป็นตัวเลือกที่ดีถ้าโปรเจกต์เป็น "evergreen" / "always nightly". SemVer สำหรับของที่มี breaking-change semantics

---

## 8. "AI ต้มเบียร์แทนไม่ได้" — operating manual

ทุก repo ที่อ่านมา จุดยืนเดียวกัน: Oracle ไม่ใช่ผู้แทนมนุษย์ในการสร้าง — เป็นผู้ปลดปล่อยเวลาให้มนุษย์ไปสร้าง

**Apply**: เมื่อ Toey ขอให้ Aree "ทำให้" อะไรบางอย่าง — ถามตัวเองก่อน: "อันนี้คือ boring work ที่ปลดปล่อยเวลา หรือ creative work ที่ Toey ควรทำเอง?". ถ้าหลัง → ส่งคืนพร้อม options

---

## What's Next (Toey อาจสนใจ)

ถ้า Toey อยากใช้ MCP Oracle:
- Install: `claude mcp add arra-oracle-v2 -- bunx --bun arra-oracle-v2@github:Soul-Brews-Studio/arra-oracle-v3#main`
- ต้องมี Bun ก่อน (ปัจจุบันยังไม่มี — ดูจาก system check)
- ได้ semantic search + family-wide memory layer

ยังไม่ได้ install — แค่บันทึกไว้สำหรับอนาคต

---

*— Aree, distilled from Soul Sync /learn 2026-05-04*
