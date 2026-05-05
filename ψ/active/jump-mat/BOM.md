# Bill of Materials — Jump Mat (Path A++)

**Last updated**: 2026-05-05
**Status**: draft, awaiting Toey's mat-construction choice
**Total range**: 800-2,800฿ depending on mat construction option

---

## 1. Electronics — common to all options

### Required (~500-800฿ if ESP32 + power parts NOT in hand)

| Item | Spec / model | Search keywords (TH) | Qty | Est. price |
|------|-------------|----------------------|-----|------------|
| **ESP32-S3 dev board** | XIAO ESP32-S3 (compact, ref V1/V2) **or** ESP32-S3 DevKit (ref V4) | `XIAO ESP32-S3` หรือ `ESP32-S3 DevKitC` | 1 | 250-450฿ |
| NeoPixel RGB LED | WS2812B individually addressable, 4 pixels (matches ref firmware) | `WS2812B 4 LED` หรือ `NeoPixel 4` | 1 strip/ring | 30-80฿ |
| Push button (power) | momentary, 6×6 mm tactile | `tactile button 6mm` | 1 | 5-10฿ |
| Jumper wire M-F + heat shrink | dupont 20cm, mixed | `jumper wire dupont` | 1 set | 50-80฿ |
| 10kΩ resistors (pull-up/down redundancy) | 1/4 W | `resistor 10k 1/4W` | 10 | 20฿ |

### Power (skip if Toey has from prior `jump_mat_build_guide.html` plan)

| Item | Spec | Qty | Est. price |
|------|------|-----|------------|
| TP4056 charging module | with protection | 1 | 30-50฿ |
| MT3608 boost converter | adjustable 2-24V output | 1 | 30-50฿ |
| 18650 Li-ion cell | 2500-3500 mAh, button top | 1 | 150-300฿ |
| 18650 holder | single cell, with leads | 1 | 20-40฿ |
| Power switch | toggle SPDT | 1 | 10-20฿ |

**Subtotal electronics**: ~700-1,300฿ (depending on parts in hand)

---

## 2. Mat construction — pick ONE option

### Option A: **Rod-style** (Chronojump original)

Closest to validated reference. Cost €73 in their guide (~2,800฿).

| Item | Spec | Qty | Est. price |
|------|------|-----|------------|
| Tempered steel strap | 13mm wide × 0.5mm thick, total 21m | 1 spool | 400-600฿ |
| Double-sided 3M tape | 19mm × 1.5m | 1 | 50฿ |
| Wide double-sided tape | 5cm × 30m | 1 | 150-200฿ |
| Transparent plastic sheet (PVC/polycarbonate) | 1m × 1m × 0.5mm | 2 | 300-500฿ |
| Canvas / fabric backing | 1m × 1m | 2 | 200-300฿ |
| Aluminum/steel rivets | 2.1mm | 30 | 50-100฿ |
| Washers | for rivets | 30 | 30฿ |
| Cable (peeled at intervals) | 6m double-conductor | 1 | 80-120฿ |
| American (cloth) tape | 5m | 1 | 40฿ |

**Subtotal Option A**: ~1,300-1,950฿

**Pros**: validated design, durable, professional look
**Cons**: most expensive, hardest to assemble (rivet 30 rods), 7cm spacing has dead zones (Chronojump warns to go finer)

---

### Option B: **FSR 4-corner** (simple, durable)

4 force-sensitive resistors at corners of a plywood/MDF plate. Threshold = "on ground".

| Item | Spec | Qty | Est. price |
|------|------|-----|------------|
| FSR-402 (or equivalent FSR 12.7mm round) | 0.2-20 N range, ~150 KOhm unloaded | 4 | 150-300฿ × 4 = 600-1,200฿ |
| Plywood/MDF | 60×80 cm, 12-18mm | 2 sheets | 200-400฿ |
| 10kΩ resistors (FSR voltage divider) | already in common parts | - | - |
| Foam pads / spacers | between plates | 4 | 30-50฿ |
| Anti-slip rubber feet | bottom | 4 | 20-40฿ |

**Subtotal Option B**: ~850-1,690฿

**Pros**: simple wiring (4 analog reads), durable, no dead zones, slight pressure info for Phase 4 upgrade
**Cons**: FSR drift over years (not sessions), saturate at high force (doesn't matter for binary)

---

### Option C: **Foil sandwich** (cheapest, fast)

2 conductive foil layers separated by foam with holes. When pressed → foils touch through holes → circuit closes.

| Item | Spec | Qty | Est. price |
|------|------|-----|------------|
| Aluminum foil tape (conductive) | 50mm wide × 25m | 2 rolls | 200-400฿ |
| Closed-cell foam | 60×80 cm × 5-10mm | 1 sheet | 150-300฿ |
| Plywood/MDF | 60×80 cm, 12-18mm | 2 sheets | 200-400฿ |
| Anti-slip rubber feet | 4 | 20-40฿ |

**Subtotal Option C**: ~570-1,140฿

**Pros**: cheapest, fastest assembly (1-2h)
**Cons**: foil oxidizes / breaks (Toey's original concern!), foam compresses over time. **NOT recommended for commercial path** — same flaw as original guide.

---

### Option D: **Contact-switch grid** (custom, low-tech)

DIY array of small contact pads (e.g., aluminum plates separated by foam ring), wired in parallel to detect ANY contact.

| Item | Spec | Qty | Est. price |
|------|------|-----|------------|
| Aluminum sheet | 0.5mm thick, cut into 16-25 small pads (5×5 or 5×3 grid) | 1 sheet | 200-300฿ |
| Foam ring spacer (silicon ring or foam tape squares) | between pad pairs | 16-25 | 100-150฿ |
| Wire | thin (28-30 AWG) | 5m | 50฿ |
| Plywood/MDF | 60×80 cm | 2 | 200-400฿ |

**Subtotal Option D**: ~550-900฿

**Pros**: cheap, customizable density, no dead zones if grid fine enough
**Cons**: many solder joints, not professional looking

---

## 3. Tools (assumed in hand)

- Soldering iron + solder
- Multimeter
- Drill + bits (M5 if Option A)
- Screwdriver set
- Hot glue gun (optional, for assembly)
- Cutting tools (utility knife, wire stripper)

---

## 4. Total cost summary

| Configuration | Min | Max |
|---------------|-----|-----|
| Electronics only (no power, all in hand) | 350฿ | 600฿ |
| Electronics + power (full new) | 700฿ | 1,300฿ |
| **+ Option A (rod-style)** | 2,000฿ | 3,250฿ |
| **+ Option B (FSR 4-corner)** | 1,550฿ | 2,990฿ |
| **+ Option C (foil sandwich)** | 1,270฿ | 2,440฿ |
| **+ Option D (contact-switch grid)** | 1,250฿ | 2,200฿ |

---

## 5. Aree's recommendation

**For Phase 1 MVP**: **Option B (FSR 4-corner)**.

Rationale:
- Cleanest wiring (4 analog reads → ESP32-S3)
- Maps directly to Chronopic 4 reference (which uses 4 sensor pins)
- Durable for years of use
- Slight pressure info gives smooth upgrade path to Phase 4 force plate (just swap FSR for load cells, same 4-pin architecture)
- No dead-zone problem of Option A
- Avoids fragility of Option C (Toey's original rejected design)

**Alternative**: Option A if Toey wants closest match to validated Chronojump design and accepts higher cost + assembly time.

---

## 6. Lazada/Shopee shopping notes

- Cross-check seller ratings before ordering FSR or load cells (lots of fakes)
- Search English keywords too — better selection
- Some sellers ship in 24h within Bangkok, 3-7 days otherwise
- Heat shrink + soldering supplies often cheaper at Banzaab / local electronics shops than online

## 7. Decision needed before Aree finalizes shopping list

1. **Mat construction option (A / B / C / D)** — Aree recommends B
2. **ESP32-S3 form factor** (XIAO compact / DevKit standard)
3. **Power circuit parts in hand?** (TP4056, MT3608, 18650, holder, switch)
