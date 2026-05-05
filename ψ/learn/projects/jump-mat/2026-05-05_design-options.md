---
date: 2026-05-05
domain: projects/jump-mat
type: design analysis
session: home-evening, after Day 2 sync + Round 6 study
status: design decision pending Toey
---

# Vertical Jump Mat — Design Options Analysis

> Toey กำลังสร้าง DIY vertical jump mat ใช้เอง (ระยะสั้น) → ถ้า traction ดี = ขาย (ระยะยาว)
> ปัจจุบัน: guide ที่มีอยู่ที่ `C:\Users\toey0\Desktop\Project\jump_mat_build_guide.html`

## ปัญหาของ design ปัจจุบัน (foam-with-holes + foil cross)

Original guide ใช้:
- EVA foam เจาะรู 63 จุด (8cm grid)
- foil tape บนเป็นแถวขนาน, foil tape ล่างหมุน 90° → cross-pattern
- ESP32 อ่าน GPIO (HIGH ผ่าน 10kΩ pull-up, LOW เมื่อ foil contacts ผ่านรู)
- ส่งข้อมูลผ่าน BLE — flight time → `h = g·t²/8`

**จุดอ่อน**:
1. เจาะรู 63 จุด manual = ใช้เวลา + ไม่ repeatable
2. ฟอยล์ต้อง align cross — เคลื่อนนิดเดียว = พลาด
3. Foam compresses ตามเวลา → contact geometry drift
4. Foil tape แตกเร็ว — กระโดด ~1000 ครั้ง = เปลี่ยน tape
5. **ไม่ scale สำหรับ commercial production**

## หลักการ — mat ทำหน้าที่อะไรจริงๆ

แค่ตอบคำถาม **"มีคนยืนบนแผ่นไหม?"** ใน <5ms latency
- t_flight = ระยะเวลา open
- jump_height = g·t²/8 (kinematic equation)
- ground contact time (GCT) = ระยะเวลา closed ระหว่าง landing → next takeoff
- RSI (reactive strength index) = jump_height / GCT

ถ้าต้องการ force-time curve (RFD, peak force, eccentric/concentric phases) → ต้องการ analog force sensing ไม่ใช่แค่ on/off

## 4 ทางเลือกที่ดีกว่า (ranked)

### Option A — FSR 4 ตัวที่มุม ⭐ MVP recommended

```
Plywood/MDF top
  ↓ (4 corners)
FSR-402 × 4  →  ESP32 GPIO 32-35 (analog)
  ↓
Plywood/MDF bottom
```

| Property | Value |
|----------|-------|
| Cost added | ~600-1,200 บาท (FSR-402 × 4 ตัว, ตัวละ 150-300) |
| Pins used | 4 analog (GPIO 32-35) |
| Logic | ทั้ง 4 < threshold = airborne |
| Assembly time | 2-3 ชม. (vs 6-8 ชม. ของ original) |
| Holes drilled | 0 |
| Durability | สูงมาก — ไม่มี foil เสีย |
| Commercial readiness | ✓ — Just Jump, Smartspeed ใช้ pattern นี้ |
| Bonus diagnostic | weight distribution, asymmetry detection |

### Option B — Velostat sheet (pressure-sensitive plastic)

```
foil top + Velostat sheet + foil bottom
```
ไม่ต้องเจาะรู — pressure ตก → resistance ลด → analog read

| Property | Value |
|----------|-------|
| Cost added | ~250-400 บาท (Velostat 30×30 — อาจต้อง tile หรือซื้อ roll) |
| Pins used | 1 analog |
| Assembly time | 1-2 ชม. |
| Drawback | hysteresis ~10ms ตอนปล่อย → jump time off เล็กน้อย ต้อง cal |
| Bonus | force หยาบๆ — ขั้นตอนสู่ Option C |

### Option C — Strain gauge บน plywood (mini force plate) 🚀 Pro version

```
4 strain gauges → Wheatstone bridge → HX711 ADC → ESP32
```

| Property | Value |
|----------|-------|
| Cost added | ~600-800 บาท (gauges 4 × 100 + HX711 40 + parts) |
| Output | **force-time curve จริง** — RFD, peak force, eccentric/concentric phases, GCT แม่นยำ |
| Difficulty | สูง — ตั้ง bridge + cal sensitivity |
| Sell as | "DIY force plate" — commercial force plate $1k-$10k+, niche ราคาถูกแทบไม่มี |
| Market | sport science labs, S&C coaches, serious athletes |

### Option D — Capacitive touch (ESP32 native T0-T9)

ESP32 มี touch pins ในตัว — แผ่น conductive ใต้ rubber บาง

| Property | Value |
|----------|-------|
| Cost added | ~0 |
| Pins used | T0-T9 (GPIO 4, 0, 2, 15, 13, 12, 14, 27, 33, 32) |
| ปัญหา | ผ่าน sole รองเท้าหนา? Barefoot ใช่ได้ ใส่รองเท้ากีฬา = ต้องทดสอบ |
| Verdict | น่าสนใจ research แต่ใช้งานจริงเสี่ยง |

## เปรียบเทียบรวม

| | Original | A (FSR) | B (Velostat) | C (Strain) | D (Cap) |
|---|---|---|---|---|---|
| ต้นทุนเพิ่ม (บาท) | 0 | +800 | +300 | +700 | 0 |
| Assembly (ชม.) | 6-8 | 2-3 | 1-2 | 4-5 | 2-3 |
| Repeatable | ✗ | ✓ | ✓ | ✓ | ✓ |
| 10k jumps durability | ✗ | ✓ | ✓ | ✓ | ✓ |
| Force curve | ✗ | ✗ | ~ | ✓ | ✗ |
| Commercial-ready | ✗ | ✓ | ~ | ✓✓ | ? |
| Risk | low | low | medium (hysteresis) | high (cal) | high (shoes) |

## คำแนะนำของ Aree (or whoever takes this next)

**Phase 1 (MVP — เดือนนี้)**: ทำ Option A (FSR 4 corners)
- ทดสอบ concept ใช้เอง
- ถ่ายคลิป unboxing/test ลง social
- เก็บ feedback จาก academy/ยิม 2-3 แห่ง
- เป้า: validate "คนไทยอยากซื้อแบบนี้ไหม?" ก่อนลงทุนเพิ่ม

**Phase 2 (ถ้า traction ดี — 3-6 เดือน)**: pivot ไป Option C (strain gauge)
- Sell as "DIY force plate" ราคา $200-400 USD
- Niche: sport scientists, S&C coaches, serious lifters
- Commercial force plates $1k-$10k → market gap ใหญ่

## สิ่งที่ต้องตัดสินใจ (waiting on Toey)

- เลือก Option ไหนสำหรับ MVP?
- ถ้า A: ต้องการ wiring + code skeleton ไหม? lookup parts ใน Lazada/Shopee?
- ถ้า scope ใหญ่กว่านั้น: market research ของ vertical jump mat ในไทย/อาเซียน?

## Reference

Original guide: `C:\Users\toey0\Desktop\Project\jump_mat_build_guide.html`
Stack เดิม: ESP32 + MT3608 + TP4056 + 18650 + buzzer + LED
Budget เดิม: 2,095 บาท
ขนาด: 60×80 cm
