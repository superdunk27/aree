---
date: 2026-05-05
source: 2 docs ใน ψ/learn/recovery/2026-05-05/
tags: [recovery, sleep, hrv, autonomic, monitoring, foundational]
related:
  - ψ/learn/recovery/recovery.md
  - ψ/learn/skill-acquisition/skill-acquisition.md
---

# Sleep + HRV / Recovery — Distilled Cheat Sheet (Round 4)

ของ Aree เพื่อตอบเรื่อง recovery, sleep, fatigue management, training load. Foundational ที่อยู่ใต้ทุก training/learning topic

---

## 🧭 Mental model

**Training = stimulus. Recovery = consolidation.**
ถ้า recovery ขาด — stimulus เสีย, ได้ผลแค่ส่วนเดียว

3 layers ของ recovery:
1. **Sleep** (foundation — ห้ามขาด)
2. **HRV/autonomic** (signal — บอกว่าพร้อมหรือยัง)
3. **Training load management** (lever — ปรับให้ match recovery state)

---

## ⚡ The 80/20 — SLEEP

### 1. Architecture: NREM (N1, N2, N3=SWS) + REM
- **SWS** (slow-wave sleep) = early-night dominant. Memory consolidation (declarative/procedural), GH release, glymphatic clearance
- **REM** = late-night dominant. Emotional regulation, creative integration, motor skill automatization
- **1 cycle ≈ 90 min, 4-6 cycles per night**
- คุณตัด sleep ตอนไหน = สูญเสียประเภทไหน:
  - **คั่งคืนแล้วนอน 6h (จาก 7.5h)** = สูญเสีย ~50% ของ REM (ตัด 1.5 cycle ปลาย)
  - **alcohol/stress ทำให้ early sleep แย่** = สูญเสีย SWS (memory + GH + glymphatic)
- "ขาด sleep" ไม่ uniform — ขึ้นอยู่กับว่าตัดส่วนไหน

### 2. Two-process model (Borbély)
- **Process S** (sleep pressure) = สะสมตลอด wake, ระบายขณะนอน. Depends on adenosine
- **Process C** (circadian) = oscillation 24-hr, peak sleep drive ~3-4 AM
- **ทั้งสองต้อง align**: ถ้า S สูงแต่ C ผิดเฟส → คุณหลับได้แต่ quality แย่
- Caffeine → block adenosine → mask Process S signal โดยไม่ลด accumulation

### 3. Duration & individual variation
- "8 hours" เป็น average, ไม่ใช่ universal
- **Genetic short sleepers** (DEC2 mutation): ~5-6h เพียงพอจริง — แต่หายาก (<1% ของประชากร)
- **คนส่วนใหญ่ underestimate own need** — Mah Stanford basketball: 10h-in-bed × 5-7 wk → +9% shooting accuracy (จาก habitual ~6.8h)
- **Athletes specifically need more** — รายงาน 8.5-10h ในช่วง heavy training

### 4. The big disruptors (sufficient evidence to act on)
| Disruptor | Effect | Practical |
|-----------|--------|-----------|
| **Caffeine** (5-6h half-life) | Reduces SWS, fragments REM, even when subjective sleep "fine" | Last coffee ≤2 PM (or ≥8h pre-bed) |
| **Alcohol** | Sedates initially → fragments REM, raises HR | 0 within 2-3h of bed; ideally 0 on training days |
| **Light exposure** (>200 lux 1h pre-bed) | Suppresses melatonin onset | Dim home, glasses if screen-heavy |
| **Late large meals** | Disrupts thermoregulation, GERD | Eating window closed 2-3h pre-bed |
| **Hot bedroom** (>21°C) | Reduces SWS | 16-19°C optimal |
| **Stress/rumination** | Sympathetic activation → fragmented sleep | CBT-I techniques, journaling, sleep restriction |

### 5. Athletic sleep extension = highest-validated intervention in sport science
- Mah et al. Stanford: extend to 10h-in-bed for 5-7 weeks
- Gains: shooting accuracy +9%, sprint times improved, mood + reaction time
- **Single most effective non-training intervention** that has RCT validation
- Effect size: large (d > 0.8 across multiple measures)

### 6. CBT-I > sleeping pills for chronic insomnia
- CBT-I = Cognitive Behavioral Therapy for Insomnia
- Effect size 0.7-1.0 on sleep quality
- Pills habituate, disrupt architecture, rebound insomnia on cessation
- Components: stimulus control, sleep restriction, cognitive restructuring, sleep hygiene

### 7. Walker's *Why We Sleep* — mostly correct, some overstated
- **Solid**: sleep & memory consolidation, sleep deprivation effects on health, athletic performance impact
- **Overstated/disputed** (per Guzey 2019 critique): some specific mortality claims, "shorter sleep = shorter life" framing was simplified
- Use as starting point, verify specific claims

---

## ⚡ The 80/20 — HRV / autonomic / training load

### 1. The "trend not single-day" rule (#1 most-broken principle)
- Single readings are NOISY (alcohol, illness, breathing, position, time)
- **Actionable signal** = 7-day rolling average, comparison to **personal baseline**
- Day-to-day fluctuation ±20% is normal, not actionable
- **Stop checking daily readings as oracle** — check trend weekly

### 2. rMSSD = gold standard (with caveat)
- **Why**: cleanest vagal proxy, less artifact-sensitive than frequency methods (LF/HF)
- **Caveat**: still very sensitive to ectopic beats — single ectopic inflates rMSSD 270-413%
- Need clean signal: chest strap (Polar H10) or validated PPG with ectopic filtering (HRV4Training)
- **Whoop, Apple Watch, Oura** = mixed accuracy, especially for HRV specifically

### 3. The Plews paradox
- "Higher HRV = better recovered" folk wisdom is **wrong twice**:
  1. Short-term **overreaching** can SHOW elevated parasympathetic markers (compensatory)
  2. Some athletes adapt with FLATTER HRV signature, not necessarily worse
- HRV interpretation requires training context, not raw value
- **Drop in 7-day HRV trend** = more reliable warning than single low reading

### 4. Measurement protocol
- **Morning, supine, immediately on wake** (or 5 min after if needed)
- **Same position every day**
- **Quiet breathing** (don't intentionally slow — bias)
- **5 min OR validated 1-min spot test** (HRV4Training validated)
- **Same device, same conditions** — comparing across devices is invalid

### 5. Confounders (often dominate signal)
- **Alcohol**: huge effect (rMSSD drop 20-40% next morning, lasts 24-48h)
- **Illness**: drops days before symptoms — often early warning
- **Menstrual cycle**: clear oscillation (luteal lower); track separately
- **Breathing rate**: slow paced breathing inflates HRV → bias if not consistent
- **Position**: standing < seated < supine HRV; mixed protocols invalid
- **Caffeine**: small effect (modest sympathetic increase)
- **Late meal**: digestion sympathetic shift
- **Stress, work, life**: comparable to training load effects

### 6. HRV-guided training: real but modest
- **Effect size**: 0.5-1.5% improvement vs fixed plan in controlled studies (Kiviniemi, Vesterinen, Plews)
- **Typical decision**: if today's HRV below 7-day baseline by >X SD → train light, else as planned
- **Best for**: athletes who can't intuitively gauge readiness; structured environments
- **Worse for**: athletes with poor sleep hygiene (signal overwhelmed by confounders)

### 7. Subjective wellness = competitive with HRV
- Simple questionnaires (sleep quality, fatigue, soreness, mood, stress: 1-5 scale) often beat or match HRV
- **Hooper questionnaire** is widely used
- For some athletes: subjective > HRV (less data hassle, equally predictive)
- **Combine both** when feasible

### 8. Training load monitoring frameworks
- **Session-RPE × duration** (Foster) = simple, valid, free
- **TRIMP** (Banister) = HR-weighted load
- **Acute:Chronic Workload Ratio (ACWR)** — Tim Gabbett
  - Original "1.0-1.3 sweet spot" claim has been challenged (multiple papers post-2018)
  - Treat as one signal, not gospel
- **Best practice**: combine load + HRV + subjective, not single metric

### 9. Device validation hierarchy
| Device | HRV accuracy | Notes |
|--------|--------------|-------|
| Polar H10 (chest strap) | Gold standard | Reference for research |
| **HRV4Training (PPG via phone camera)** | Excellent — extensively validated | Altini's app, peer-reviewed |
| Garmin (recent models w/ HRV stress) | Good for trend, less for absolute | Improving |
| Apple Watch (post-2022) | Good — improving | Best-in-class wrist-based |
| Oura | Mixed independent results | Marketed as gold but variable |
| **Whoop** | Opaque algorithm, no peer-reviewed validation | Use with skepticism |

---

## 🚨 Updated red flags (Round 4)

21. **Cutting sleep on training days** — doubles the cost (training stimulus + skill learning both affected)
22. **Caffeine after 2 PM** — degrades sleep quality even when subjective is fine
23. **Drinking alcohol within 2-3h of bed** — wrecks REM
24. **Acting on single-day HRV readings** — noise > signal
25. **Hyperventilating to "raise" HRV** — biases measurement, clinically meaningless
26. **Whoop strain score as gospel** — opaque algorithm, treat as suggestion not data
27. **Targeting specific HRV number** — your 7-day trend vs YOUR baseline matters, not population numbers
28. **Sleeping pills for chronic insomnia** — CBT-I is gold standard

---

## 🎯 Claim quality table (Round 4 recovery)

| Claim | Evidence | Caveat |
|------|----------|--------|
| Sleep duration affects athletic performance | Strong | Mah multiple replications |
| Sleep extension to 10h-in-bed improves performance | Strong | Mah Stanford |
| Caffeine 6h pre-bed degrades sleep | Strong | Drake 2013 + replications |
| Alcohol fragments REM | Strong | Many lab + field studies |
| CBT-I beats pills for insomnia | Strong | Multi-RCT, gold-standard |
| Walker's claim "short sleep = early death" | Moderate (overstated by Walker) | Guzey critique stands |
| rMSSD is cleanest HRV metric for daily | Strong | Many methodology papers |
| HRV-guided training beats fixed | Modest (0.5-1.5%) | Real but small |
| The Plews paradox (overreaching → high HRV) | Moderate | Multiple case observations |
| Whoop's accuracy claims | Weak / unvalidated | No peer review of algorithm |
| ACWR "1.0-1.3 sweet spot" rule | Contested | Original claim challenged |

---

## 📂 Files reference

- [recovery hub](../../learn/recovery/recovery.md)
- [01 — Sleep architecture & optimization](../../learn/recovery/2026-05-05/01_sleep-architecture-optimization.md)
- [02 — HRV & autonomic recovery monitoring](../../learn/recovery/2026-05-05/02_hrv-autonomic-recovery-monitoring.md)
- [Skill acquisition hub (Round 4 partner)](../../learn/skill-acquisition/skill-acquisition.md)
- [Skill acquisition cheat sheet](2026-05-05_skill-acquisition.md)

---

*— Distilled by Aree, 2026-05-05. Sleep + HRV เป็น foundational layer ใต้ทุก training/learning topic. Citation อยู่ใน source docs.*
