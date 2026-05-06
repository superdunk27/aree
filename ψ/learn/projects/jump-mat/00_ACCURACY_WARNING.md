---
date_flagged: 2026-05-06
flagged_by: Aree
priority: high
---

# ⚠️ Accuracy Warning — Files in this folder

## ปัญหา

ไฟล์ที่ลงวันที่ **2026-05-05** ในโฟลเดอร์นี้ทั้งหมด เขียนจากข้อมูล **WebFetch summary** ซึ่งคือ AI ตัวเล็กกว่าอ่านหน้าเว็บแล้วสรุปให้ — **ไม่ใช่ raw text**

วันที่ 2026-05-06 จับได้ว่ามีจุดผิดอย่างน้อย 1 จุดสำคัญ: **โครงสร้าง rod-style ของ Chronojump** Aree เคยอธิบายว่าเป็น "เหล็ก 1 ชั้น + สายไฟลอกฉนวน" แต่จริง ๆ คือ **"เหล็ก 2 ชั้นประกบ tape คั่น"** (Toey เป็นคนจับได้)

ที่สำคัญกว่า: Chronojump บอกในหน้าเว็บอย่างชัดเจนว่า **"recommend PCB platform INSTEAD of this rods platform"** — บรรทัดนี้ไม่ถูก surface ใน 3 รอบ WebFetch

## ไฟล์ที่อาจมีข้อผิดพลาด (ยังไม่ audit)

- `2026-05-05_chronojump-deep-dive.md` — น่าจะมีจุดเข้าใจผิดเรื่องโครงสร้าง
- `2026-05-05_research-existing-builds.md` — survey 12 projects, อาจ underweight Chronojump
- `2026-05-05_design-options.md` — 4 option analysis, baseline assumption อาจผิด

## วิธีใช้ข้อมูลในไฟล์เหล่านี้

- ✅ **OK ใช้เป็น context ทั่วไป** ("มีโปรเจกต์อะไรบ้าง", "trend ทั่วไป")
- ❌ **ห้ามใช้สำหรับตัดสินใจ technical** โดยไม่ verify จาก source ใหม่ก่อน
- ❌ **ห้าม quote spec / step-by-step** จากไฟล์เหล่านี้โดยตรง

## วิธี verify

ใช้ Jina Reader: `curl https://r.jina.ai/<url>` → อ่าน raw markdown โดยตรง

ดูรายละเอียด protocol ใน memory: `feedback_web_research.md`

## ของที่ verify แล้ว ณ 2026-05-06

- โครงสร้าง rod-style แบบที่ 1 (Chronojump): **2 เส้นเหล็กประกบ tape spacer คั่น** — ตรวจจาก raw text ที่ Toey paste + Jina Reader
- โครงสร้างแบบที่ 2 (PCB platform): **2 แผ่น PCB ทองแดงเข้าหากัน, tape ขอบเป็น spacer 1-2mm** — ตรวจจาก raw text ที่ Toey paste
- Chronojump's official recommendation: **PCB > rods**
