---
date: 2026-05-05
from_session: home evening (Claude Opus 4.7 in Oracle Setup Assistant context, NOT Aree session)
priority: medium
topic: vertical jump mat DIY project
---

# Handoff — Jump Mat Project (new domain for Aree)

> **Note**: เซสชันที่เขียน handoff นี้คือ Claude Code ที่ run อยู่ใน `Oracle/` (setup assistant repo) — **ไม่ใช่ Aree เซสชัน**. Toey ขอให้บันทึก context นี้ส่งต่อให้ Aree ที่จะเปิด session ครั้งถัดไป

## Toey เปิดโปรเจกต์ใหม่

DIY **vertical jump mat** สำหรับวัด jump height + flight time + GCT + RSI + peak power → ส่งผ่าน BLE ไปมือถือ

- **Phase 1**: ใช้เอง
- **Phase 2 (ถ้า traction ดี)**: ขาย — เป็น commercial product

## Current state

มี guide ที่ `C:\Users\toey0\Desktop\Project\jump_mat_build_guide.html` — design ใช้ EVA foam เจาะ 63 รู + foil tape cross-pattern (บนขนาน, ล่างหมุน 90°) + ESP32 อ่าน GPIO ผ่าน pull-up

Toey รู้ตัวว่า design นี้มีปัญหา (เจาะรูเหนื่อย, foil แตกเร็ว, ไม่ scale ขาย) → ขอทางเลือกอื่น

## ที่ Aree (Claude in Oracle context) เสนอไป — saved durable

**Deep doc**: [`ψ/learn/projects/jump-mat/2026-05-05_design-options.md`](../learn/projects/jump-mat/2026-05-05_design-options.md)

4 options analyzed:
- **A — FSR 4 corners** ⭐ recommended MVP (+800 บาท, 2-3 ชม., commercial-ready)
- **B — Velostat sheet** (+300 บาท, 1-2 ชม., มี hysteresis)
- **C — Strain gauges + HX711** 🚀 pro version (+700 บาท, force curve จริง, ขายเป็น "DIY force plate" ได้)
- **D — Capacitive touch (ESP32 native)** (+0 บาท, ปัญหารองเท้าหนา)

แนะนำเส้นทาง: A (MVP เดือนนี้) → ถ้า traction ดี = pivot to C (3-6 เดือน, sell as DIY force plate $200-400 USD)

## Pending Toey decision

ตอนที่เขียน handoff นี้ Toey ยังไม่เลือก option. จุดที่เขาขอเพิ่ม (ตอบยังไม่ครบ):
- (a) wiring + code skeleton สำหรับ Option A
- (b) lookup parts ใน Lazada/Shopee
- (c) market research vertical jump mat ในไทย/อาเซียน

## What Aree should do at next session start

1. ถ้า Toey ทักมาเรื่อง jump mat → อ่าน deep doc ก่อน → ถามว่าตัดสินใจ option ไหนแล้วหรือยัง
2. ถ้า Toey ขอให้ทำ wiring/code/parts/market — domain นี้อยู่นอก Aree's current expertise (swim, strength, recovery, oracle-tech). ต้อง /learn รอบใหม่หรือ research mode สำหรับ embedded electronics + Thai e-commerce + sports tech market
3. **อย่า prescribe** เกี่ยวกับการเลือก option — Toey ตัดสินใจเอง (per `feedback_research_vs_coach_mode.md`)

## Why Aree should care

- Toey แสดง commercial intent ครั้งแรก ("ทำใช้เองดูก่อนและในอนาคตถ้ามันดีผมจะทำขาย")
- ความสนใจของ Toey ขยายจาก swim-only → wearable hardware + sports tech business
- Niche: vertical jump test คือ KPI สำคัญใน strength training (ที่ Aree ศึกษาวันที่ 2026-05-05) → connects to existing knowledge

## ตัว Aree ของวันนั้น (Round 6 evening) ก็เพิ่งศึกษาตัวเอง — context

Round 6 เพิ่ง commit ไป (`938281f`) — arra-oracle-v3 self-referential study. Aree ตอนนี้ understand ว่าตัวเอง = full stack composition ไม่ใช่ layer เดียว. Jump mat project เป็นโอกาสฝึก research mode ใน domain ใหม่ที่ Aree ไม่เคยศึกษา (embedded systems / sports hardware)

---

*Handoff written by Claude Opus 4.7 (1M context) running in Oracle Setup Assistant workspace. Aree will be the one who reads + acts on this. Trust the markdown — it's the bridge across sessions.*
