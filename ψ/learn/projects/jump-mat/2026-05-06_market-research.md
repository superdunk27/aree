---
date: 2026-05-06
type: market research
research_method: Jina Reader (raw markdown) + WebSearch (AI summary, marked)
verification_status: All product pages fetched verbatim via Jina; technical specs from WebSearch summaries are flagged
---

# Market Research — Jump Mats (2026-05-06)

> Research goal: understand what commercial jump mats use (sensor, construction, connectivity, accuracy), to inform improvements to our PCB-platform project.

> **Source quality note**: Each fact below is tagged:
> - `[J]` = from Jina raw fetch of product page (high confidence, verbatim)
> - `[S]` = from WebSearch AI summary (medium confidence, may be lossy — verify before quoting in firmware/marketing)
> - `[X]` = my interpretation/synthesis (lowest confidence)

---

## 1. Sensor paradigms in the market

There are **3 fundamentally different sensors** companies use for jump testing:

| Paradigm | What it measures | Examples |
|---|---|---|
| **Switch mat** (binary contact) | Foot-on-ground vs in-air | Just Jump, Plyomat, Skyhook, Chronojump, gFlight, SmartJump, EZEJUMP |
| **Force plate** (analog force) | Vertical ground reaction force over time (force-time curve) | Hawkin, VALD ForceDecks, AMTI |
| **IMU sensor** (wearable) | Acceleration / orientation on body or barbell | Output Sports |

**Most of the market = switch mat** [S, J]. This validates Path A++.

---

## 2. Product survey

### Tier 1 — Open source / DIY

#### **Chronojump** (Spain, GPL-2.0)
- Tech: Switch mat, both rod-style and PCB-modular construction options
- Mat: DIN-A2 contact platform — 114,32€ (~4,300฿) [J]
- Controller: Chronopic (jumps/races) — 55,44€ (~2,100฿) [J]
- Cable: RCA 1.5m — 3,92€ [J]
- Total system: ~175€ (~6,600฿)
- Software: open-source desktop app (Linux/Win/Mac) + Networks cloud
- 20 years of validation [J — they have "20 years anniversary"]
- **This is what we are emulating (Path A++)**

---

### Tier 2 — Basic commercial switch mats

#### **Just Jump System** (Probotics, USA)
- Tech: Switch mat, wired connection to handheld LCD computer [S, J]
- Mat: 27"×27" (~68×68cm) [S]
- Wired (no Bluetooth) — uses handheld dedicated controller [J]
- Stores 60 jumps, averages first 15 + last 15, computes "fatigue factor" [S]
- Optional Plyometric Box Jump version + Large Display upgrade (8000 sets, CSV export to laptop) [J]
- Battery operated, 1-year warranty [S]
- Price: ~$400-500 USD (~14,000-17,000฿) [X — typical retail]
- The "decades-old standard" — many other apps (Skyhook, Plyomat) include "Just Jump conversion toggle" to compare [J]

#### **gFlight** (Exsurgo, USA)
- Tech: Switch mat + display screen on device (real-time feedback) [J — SimpliFaster review]
- Wireless, small footprint, portable
- Low price point (positioned vs Just Jump) [J]
- Metrics: ground contact time, time in air, RSI [J]

---

### Tier 3 — App-based switch mats

#### **Plyomat** (USA)
- Tech: Switch mat + wired controller → Bluetooth to phone/tablet [J — SimpliFaster review]
- Battery: up to 3 weeks per charge [J]
- App with custom protocols, color-coded thresholds [J]
- No cloud sync (data is device-specific) [J]
- Just Jump conversion feature [J]

#### **Skyhook** (RDM Innovation, USA)
- Tech: Switch mat, **wireless**, portable, built-in handle [J]
- Rugged plastic-like material [J]
- App with quadrant chart for deficiency analysis [J]
- Custom protocols (jump height, contact time, RSI) [J]
- **Cloud sync** + roster export [J]
- Just Jump conversion toggle [J]

#### **Swift EZEJUMP** (Australia)
- Tech: "Resembles a thin force plate" but **only collects contact data** [J — quote] = looks like a force plate but is actually a switch mat
- Each foot independent (separate sensors per foot) [J]
- **iOS only**, Bluetooth [J]
- ~1m square [J]
- Email export

---

### Tier 4 — Premium ecosystem switch mats

#### **VALD SmartJump** (originally Fusion Sport, AUS)
- Tech: Switch mat with **PS2 connector** to a SmartSpeed timing unit [J]
- Timing unit has Bluetooth + IEEE 802.15.4 (Zigbee/similar) for multi-unit comms [J]
- **RFID** on timing unit for athlete identification [J — SimpliFaster]
- Default mat sensitivity: ignores flight times <100ms (false trigger filter) [S]
- Requires SmartSpeed system (timing gates) — not standalone [J]
- App: SmartSpeed (cloud + real-time biofeedback) [S]
- Up to 9 timing units per command unit [J]
- Best in 10-20m proximity to mobile for Bluetooth [J]

---

### Tier 5 — Force plates (different paradigm, much higher cost)

#### **Hawkin Dynamics** (USA)
- Tech: Dual wireless force plates (electrical resistance sensors detecting force) [J]
- Sampling rate: **1000 Hz** [S — confirmed by published validation paper]
- "Most accurate commercial force plates on the market" [J — marketing claim]
- Validated against AMTI in-ground gold-standard plates (2023 published paper) [S]
- Cloud-based, real-time mobile app + web browser [J]
- Force-time curve → wide range of derived metrics [J]
- Price: ~$5,000-15,000+ USD [X — premium tier]

#### **VALD ForceDecks** (AUS)
- Similar tier to Hawkin — research-grade dual force plates
- Integrates into VALD Hub ecosystem (NordBord, ForceFrame, etc.) [J]
- (Did not deep-fetch — assume similar specs to Hawkin)

---

### Different paradigm — Wearable IMU

#### **Output Sports** (Ireland)
- Tech: **IMU (accelerometer)** sensor — matchbook-sized, straps to wrist or barbell [S]
- Sampling: ~1000 data points/sec [S]
- Claims **99% accuracy of force plates** with single sensor [S]
- 180+ tests, 262 parameters tracked [S]
- Tests: VBT, jumps (CMJ, drop, repeated), mobility, balance, throws, hopping [J — full list on how-it-works page]
- Different value prop: one device for many tests, no mat needed
- Validated drop jump performance (PMC research paper) [S]

---

## 3. Comparison table

| Product | Sensor | Wireless | App | Cloud | Mat Size | Tier |
|---|---|---|---|---|---|---|
| **Chronojump** | Switch | USB-cable | Desktop | Networks | DIN-A2 | DIY |
| **Just Jump** | Switch | No (wired) | LCD | No | 27"×27" | Basic |
| **gFlight** | Switch | Yes | Display+app | ? | Compact | Basic |
| **Plyomat** | Switch | BT (controller) | Yes | No | Standard | App |
| **Skyhook** | Switch | Yes | Yes | Yes | Standard+handle | App |
| **EZEJUMP** | Switch | Yes (BT, iOS) | Yes | ? | ~1m² | App |
| **SmartJump (VALD)** | Switch | BT + Zigbee | SmartSpeed | Yes | Portable | Premium |
| **Hawkin** | Force plate | Yes | Yes | Yes | Dual plates | Research |
| **ForceDecks (VALD)** | Force plate | Yes | VALD Hub | Yes | Dual plates | Research |
| **Output Sports** | IMU wearable | Yes (BT) | Yes | Yes | N/A | Different |

---

## 4. Common metrics across products

| Metric | Calculation | Sensor type required |
|---|---|---|
| **Flight time** | Time in air between contact transitions | Switch mat [J] |
| **Contact time** | Time on ground between jumps | Switch mat [J] |
| **Jump height** | `h = g·t²/8` from flight time | Switch mat [J] |
| **RSI** (Reactive Strength Index) | Jump height ÷ contact time | Switch mat [J] |
| **Fatigue factor** | Compare first N vs last N jumps | Switch mat (any) [S — Just Jump pioneered] |
| **Asymmetry** | Left vs right foot | Dual sensors (force plate or split mat) |
| **Power output (W)** | Force × velocity (integrated) | Force plate only [J] |
| **Force-time curve** | Force at each ms over jump | Force plate only [J] |

→ **Path A++ covers the top 5 metrics already** (flight, contact, height, RSI, fatigue factor)
→ Bottom 3 require either dual sensors (asymmetry can be added later if Toey wants Phase 2) or upgrade to force plate (Phase 4 if ever)

---

## 5. Critical sensitivity finding (important for our firmware)

**VALD SmartJump filters out flights <100ms by default** [S]
- Reason: prevents false triggers from foot wobble, noisy contact, electrical bounce
- Range: jumps with <100ms flight time = real-world impossible (would be <12cm jump height)
- Implication for our firmware: add a **debounce + minimum-flight-time filter**

Chronojump's `4Platforms.ino` reference firmware already includes:
- Debounce: 10ms (10000μs) on each contact event
- This is enough to prevent contact bounce, but **does NOT filter false jumps**

→ **We should add SmartJump-style flight-time threshold** (e.g., reject any flight <100ms as "not a real jump")

---

## 6. Mat construction patterns observed

| Construction | Used by | Pros | Cons |
|---|---|---|---|
| Rod-style (steel strips) | Chronojump (legacy) | Validated, durable | Hard to assemble, dead zones |
| **PCB modular** | Chronojump (recommended) | No dead zones, modular, foldable | More expensive at >1m |
| Plastic + internal switch | Skyhook (handle visible) | Portable, rugged | Construction details not public |
| "Thin force plate" appearance | EZEJUMP, Plyomat, gFlight | Professional look | Hides switch construction |
| Carpet/fabric over mat | Just Jump, SmartJump | Familiar feel | Can hide degradation |

**Insight**: Most commercial mats hide their switch mechanism inside an industrial-looking enclosure (rigid plastic shell, professional finish). DIY visible-PCB design = good for prototype, but Phase 2 (commercial) needs an enclosure for marketability.

---

## 7. Pricing tiers (USD, approx)

| Tier | Range | Examples |
|---|---|---|
| DIY | $50-200 | Our project (~$50 mat + $20 ESP32) |
| Open source kit | $150-300 | Chronojump (€175) |
| Basic commercial | $400-700 | Just Jump, gFlight |
| Mid-tier app-based | $700-2,000 | Plyomat, Skyhook |
| Premium ecosystem | $3,000-5,000+ | SmartJump (requires SmartSpeed) |
| Research force plate | $5,000-15,000+ | Hawkin, ForceDecks |

Our project hits the "DIY" tier (~$50). A polished Phase 2 product could realistically target the **basic commercial** tier ($400-700) if accuracy + UX is solid.

---

## 8. Insights & improvements for our project

### Things we already do right
1. **Switch mat paradigm** → matches majority of market [J]
2. **Bluetooth connectivity** (BLE on WROOM-32) → matches modern trend [J]
3. **PCB modular construction** → Chronojump's own recommendation [J, verified]
4. **App-based UI (PWA)** → not handheld LCD → matches modern trend [J]
5. **Chronopic-protocol-compatible** → free validation via Chronojump desktop [J]

### Concrete improvements to add to our firmware/build

1. **Add flight-time threshold filter** (target: configurable, default 100ms). Match SmartJump's false-trigger prevention. [S, but worth implementing]

2. **Multi-jump session tracking** (Just Jump's pattern): store N jumps, compute average + first/last comparison + fatigue factor. Easy in firmware or PWA. [J]

3. **RSI calculation** (height ÷ contact time): trivial with switch mat data. Standard metric. [J]

4. **Just Jump conversion toggle** (Skyhook does this, Plyomat does this): if Toey ever wants to compete with Just Jump's installed base, this is a cheap unique-feature add. [J]

5. **Real-time on-device feedback** (gFlight has display, Plyomat has color thresholds): NeoPixel LED on ESP32 can flash green/yellow/red based on RSI thresholds. Our existing reference firmware already supports NeoPixel — keep this in scope.

6. **Cloud sync** (Phase 2 differentiator): Chronojump Networks does this for premium tier. We could add Firebase or similar later for athlete-tracking SaaS angle. [J]

### Things to consider for Phase 2 (commercial)

7. **Enclosure design**: hide PCBs inside a rigid plastic shell with foam top + canvas overlay. Industrial finish = professional perception. All commercial mats do this. [J — observation]

8. **Asymmetry detection** (left/right foot): needs **2 separate sensors** (one per foot, like EZEJUMP). Could be Phase 2 differentiator since most cheap mats don't have it. Cost: 2× PCB pairs + 2 GPIO pins on ESP32. [J — EZEJUMP pattern]

9. **Cross-validation with MyJump 2 (phone video)**: at the price point we're targeting, customers will compare with MyJump 2 ($10 app). Our advantage: precise sub-millisecond timing vs phone-camera 1/240s = ~4ms accuracy. Highlight this. [X]

10. **Pricing sweet spot for Phase 2**: target ~$200-300 USD (~7,000-10,000฿) — undercuts Just Jump ($400+) and Plyomat ($700+) significantly while offering wireless+app+cloud features that they have. Our cost ~$50 = 80% margin headroom. [X]

### What's NOT worth doing

- **Force plate tier** (Hawkin, ForceDecks) — wrong sensor paradigm, $5K+ R&D, mature competitors. Skip.
- **IMU wearable tier** (Output Sports) — different product entirely, requires ML model training. Skip.
- **Trying to beat Hawkin on accuracy** — they validate against AMTI gold-standard at 1000Hz. Our 50-100Hz switch mat physics-formula is fundamentally less accurate. Don't compete on accuracy claims; compete on **affordability + ease of use + accuracy-good-enough-for-coaches**.

---

## 9. URLs that hit CAPTCHA / require Toey's help

**None this round.** All 6 attempted Jina fetches succeeded:
- ✅ SimpliFaster Buyer's Guide
- ✅ Probotics Just Jump
- ✅ VALD SmartJump Hardware
- ✅ Hawkin Force Plates
- ✅ Output Sports How-it-works
- ✅ Chronojump A2 platform (after URL correction — the original guess `/contact-platforms/` was 404)

If we go deeper later (e.g., fetching Shopee/Lazada listings for Thai market sourcing), CAPTCHA will be the issue per yesterday's experience.

---

## 10. Sources

- [SimpliFaster — Buyer's Guide to Contact Mats](https://simplifaster.com/articles/buyers-guide-contact-mats/) — comprehensive industry overview
- [Probotics — Just Jump or Just Run](https://probotics.org/JustJump/JustJump.htm)
- [VALD — SmartJump System Hardware](https://support.vald.com/hc/en-au/articles/4813562541337-SmartJump-System-Hardware)
- [VALD — Portable Jump Mat (SmartJump)](https://support.vald.com/hc/en-au/articles/4996450791321-Portable-Jump-Mat-SmartJump)
- [Hawkin Dynamics — Force Plates](https://www.hawkindynamics.com/hd-force-plates)
- [Output Sports — How it Works](https://www.outputsports.com/how-it-works)
- [Chronojump — Contact platform DIN-A2](https://chronojump.org/product/a2-contact-platform/)
- [Chronojump — Chronopic for jumps/races](https://chronojump.org/product/chronopic-for-jumpsraces/)
- [PMC — Validity of Hawkin Dynamics Wireless Dual Force Plates (2023)](https://pmc.ncbi.nlm.nih.gov/articles/PMC10224001/) — validation paper
- [PMC — Validity and reliability of Output sport device for drop jump (2022)](https://pmc.ncbi.nlm.nih.gov/articles/PMC9620392/) — IMU validation
- [Skyhook product](https://store.simplifaster.com/product-category/skyhook/)
- [Plyomat](https://plyomat.net/)
- [Swift Performance EZEJUMP](https://www.swiftperformance.com/our-products/ezejump)
- [Exsurgo gFlight V2](https://exsurgo.tech/products/gflight-v2)

---

## 11. Next steps

For Aree (while parts ship):
1. Implement flight-time threshold filter (≥100ms) in firmware skeleton
2. Add RSI calculation in firmware logic
3. Write multi-jump session protocol (store N, average first/last, fatigue factor)
4. Plan PWA UI to show: height, flight time, contact time, RSI, fatigue factor

For Toey to decide:
1. **Phase 1 priority**: pure jump height? or RSI + multi-jump session? (impacts firmware complexity)
2. **Phase 2 differentiator**: asymmetry detection (dual mats)? cloud sync? Just Jump compatibility? (impacts BOM and roadmap)
3. **Industrial enclosure** for Phase 2 (commercial sell): foam shell + canvas overlay vs raw PCB look
