---
date: 2026-05-05
domain: projects/jump-mat
type: external research
session: home evening, before parts ordering
status: research summary
sources:
  - https://csdt.org/culture/diysportsscience/diyjumpplate.html
  - https://www.instructables.com/How-To-Make-a-DIY-Force-Plate/
  - https://pmc.ncbi.nlm.nih.gov/articles/PMC8065557/
  - https://mhealth.jmir.org/2021/4/e27336
  - https://pmc.ncbi.nlm.nih.gov/articles/PMC7433325/
  - https://pmc.ncbi.nlm.nih.gov/articles/PMC11595741/
  - https://pmc.ncbi.nlm.nih.gov/articles/PMC10224001/
  - https://www.hawkindynamics.com/hd-force-plates
  - https://www.plyomat.com/
  - https://probotics.org/JustJump/JustJump.htm
  - https://store.simplifaster.com/product/just-jump-system/
  - https://simplifaster.com/articles/maximize-just-jump-system/
  - https://kinvent.com/wp-content/uploads/2025/10/portable-force-plates-reliable-valid-tool-for-measuring-cmj.pdf
  - https://github.com/JoshMH-91/ESP32-WiFi-Load-Cell-Monitor
  - https://github.com/CalPlug/Espressif_ESP32-Scale
  - https://github.com/IoTReady/esp32-wifi-ble-weighing-scale
  - https://github.com/amoodygithub/loadcell-esp
  - https://circuitjournal.com/50kg-load-cells-with-HX711
  - https://www.instructables.com/How-to-Convert-Your-HX-711-Board-From-10Hz-to-80Hz/
  - https://forum.arduino.cc/t/need-higher-sampling-frequency-than-80hz-for-load-cell/340321
  - https://www.nature.com/articles/s41598-023-46935-x
  - https://peerj.com/articles/14558/
  - https://pmc.ncbi.nlm.nih.gov/articles/PMC11244033/
---

# Existing DIY & Commercial Jump-Measurement Builds — Research Roundup

Goal: Borrow the best ideas before building Path 3 (4× 50kg half-bridge → HX711 sum mode → ESP32 BLE → PWA). What follows is what other makers and academic teams actually shipped, and where they stumbled.

## 1. Project Roundup

| Project | URL | Sensor | MCU | Cost | Sample rate | Validation |
|---|---|---|---|---|---|---|
| CSDT DIY Jump Plate (high-school workshop) | [csdt.org](https://csdt.org/culture/diysportsscience/diyjumpplate.html) | 1× FSR (Adafruit #166) + TLV2404 op-amp | Arduino + Processing | ~$52 | not stated | none reported (hang-time formula) |
| JMIR Force-Sensitive Mat (Vergara et al.) | [PMC8065557](https://pmc.ncbi.nlm.nih.gov/articles/PMC8065557/) | 16×16 = 256 FSR + Velostat matrix on 30×30 cm | STM32F103C8T6 + HC-05 BT | ~$40 | 200 Hz | vs 120 fps cam: R²=0.996, MAE 0.38 cm, 1.98% rel-error |
| Chronojump (BoscoSystems) | [PMC7433325](https://pmc.ncbi.nlm.nih.gov/articles/PMC7433325/) | A2 contact-mat switch (2 isolated copper layers) | PC-side MCU, 1 ms resolution | low (open HW) | ~1 kHz timing | vs Globus Ergo: r=0.999, ICC 0.999–1.0, 504 CMJs |
| KINVENT K-Deltas (commercial portable plate) | [kinvent PDF](https://kinvent.com/wp-content/uploads/2025/10/portable-force-plates-reliable-valid-tool-for-measuring-cmj.pdf) | strain-gauge plate, BT | proprietary | ~$1.5–2k | 1 kHz | ICC 0.981 vs Chronojump/MyJump (Plakoutsis 2025) |
| Hawkin Dynamics dual plate | [hawkindynamics.com](https://www.hawkindynamics.com/hd-force-plates) | 2× wireless strain plates | proprietary | ~$5–10k | 1 kHz | validated vs Kistler ([PMC10224001](https://pmc.ncbi.nlm.nih.gov/articles/PMC10224001/)) |
| Just Jump System (Probotics) | [probotics.org](https://probotics.org/JustJump/JustJump.htm) | switch mat | handheld timer | ~$300 | flight-time only | r=0.998 vs gold std *but firmware adds 4–7" inflation* (Plyomat critique) |
| Plyomat | [plyomat.com](https://www.plyomat.com/) | switch mat (cleaner FW) | dedicated | ~$300 | flight-time only | marketed as Just-Jump fix; no inflation |
| Instructables "DIY Force Plate" | [instructables](https://www.instructables.com/How-To-Make-a-DIY-Force-Plate/) | 4× 1 kg load cells + INA op-amps | Arduino | not stated | — | none |
| ESP32-WiFi-Load-Cell-Monitor | [github](https://github.com/JoshMH-91/ESP32-WiFi-Load-Cell-Monitor) | HX711 + load cell | ESP32 | DIY | HX711 default | logs to SD + WebUI |
| Project Libra (CalPlug) | [github](https://github.com/CalPlug/Espressif_ESP32-Scale) | HX711 + median filter | ESP32 BLE | DIY | HX711 | working BLE → Android scale (architectural twin to ours) |
| IoTReady esp32-wifi-ble-weighing-scale | [github](https://github.com/IoTReady/esp32-wifi-ble-weighing-scale) | HX711 + WROOM | ESP32 | DIY | HX711 | reference firmware |
| MyJump 2 (smartphone) | [Nature 2023 meta-analysis](https://www.nature.com/articles/s41598-023-46935-x) | iPhone 240 fps cam | iOS | $10 | 240 fps | ICC 0.986, bias ~1.3 cm vs force plate; height valid, derived metrics not |

## 2. Common Patterns — what most builders converge on

1. **Flight-time formula h = g·t²/8 is the universal core.** Every contact-mat, FSR-mat, switch-mat, and even cheap force-plate build computes height from flight time, not from impulse-momentum. Impulse integration is rare outside Hawkin/Kistler-tier kit.
2. **Detection threshold ≈ ~15–20 lb (~7–9 kg) for "off the ground."** Just Jump and clones use this band; below it you trigger on toe-flick, above it you miss the actual takeoff frame.
3. **HX711 is the default ADC** for load-cell DIY because of price and SparkFun-tier docs, *but every build hitting dynamic loads complains about its 80 Hz cap.*
4. **Strain gauges (load cells) > FSR > Velostat** for repeatability, in that order. FSR/Velostat builds (JMIR mat, CSDT) all add a calibration ritual; strain-gauge builds (Chronojump, Hawkin, K-Deltas) do not.
5. **Wireless (BLE/Wi-Fi) is now expected.** Project Libra, K-Deltas, Hawkin, and the IoTReady scale all stream to a phone — ESP32-class MCU is the unspoken default for new builds.

## 3. Divergent Approaches — where opinion splits

- **Sample rate: 80 Hz (HX711) vs 200 Hz (matrix scan) vs 1 kHz (commercial).** The JMIR paper showed error grows exponentially below 50 Hz, especially for jumps <20 cm. K-Deltas and Hawkin sample at 1 kHz. The Arduino forum thread is full of people hitting the [80 Hz HX711 wall](https://forum.arduino.cc/t/need-higher-sampling-frequency-than-80hz-for-load-cell/340321) and switching to ADS1232 / HX710 / Wheatstone shields rated up to 1 kHz.
- **Sum mode vs per-cell read.** Commercial plates read each cell individually (gives center-of-pressure + per-corner force). DIY scales overwhelmingly use sum mode (single HX711) because it's one-eighth the wiring cost. Tradeoff: you lose CoP and you can't detect uneven loading, but for jump height alone, sum is sufficient.
- **50 kg vs 200 kg load cells.** Standard 50 kg half-bridges have ~150% safe overload (75 kg), 300% break (150 kg). Peak landing force in CMJ runs 3–5× bodyweight. For a 70 kg athlete that's 210–350 kg total → **~52–88 kg per cell** with even loading. 50 kg cells will dance with the safety limit; 100 kg cells cost ~the same and give real headroom.
- **Just Jump's 4–7" inflation.** SimpliFaster and Plyomat both call out that Probotics deliberately inflated firmware output for marketing. The hardware is fine; the firmware lies. Lesson: own your pipeline end-to-end if you ever want to sell.
- **MyJump 2 — rejected by Toey, vindicated by science.** 2023 Nature meta-analysis and 2024 PubMed studies put it at ICC ~0.99 vs force plate, with ~1.3 cm bias. Worth re-examining as a calibration baseline even if you don't use it day-to-day.

## 4. Top Actionable Takeaways for OUR build

1. **Upgrade load cells to 100 kg or 200 kg half-bridges.** Same form factor as 50 kg, ~same price (~70–100 THB each on Lazada), 2–4× the headroom. With 4× 50 kg in sum mode at peak landing, a 75 kg sprinter is sitting at ~70% of break load — too close. Spend the extra ฿200 total.
2. **Plan to run HX711 at 80 Hz minimum, and validate empirically against 240 fps phone video before you trust it.** The [80 Hz mod](https://www.instructables.com/How-to-Convert-Your-HX-711-Board-From-10Hz-to-80Hz/) is a single trace cut + jumper. Most off-the-shelf modules ship at 10 Hz. JMIR result: 100 Hz is the floor for sub-5% error on small jumps. If 80 Hz doesn't cut it, swap to ADS1232 (later, not v1).
3. **Sum mode is fine for v1 — but wire it so you can split to 2× HX711 (left/right) later.** Even/uneven take-off detection is the single most-valuable upgrade path; commercial dual-plate systems sell on it. Lay out the PCB so each pair-of-cells can break out independently.
4. **Use takeoff/landing detection at ~75% bodyweight, not at zero.** Just Jump and Chronojump both threshold above zero to ignore mat flex and shoe noise. Calibrate per-user with a 2-second standing tare → set takeoff = bodyweight × 0.25, landing = bodyweight × 0.5 with hysteresis.
5. **Reference Project Libra and IoTReady's repos as architectural baselines.** Both already do HX711 → ESP32 → BLE/Wi-Fi → phone. Your novelty is the jump-detection state machine and PWA, not the data path.

## 5. Open Questions

- **No public repo found for an end-to-end ESP32 + 4-cell + jump-detect + BLE force plate.** The closest are weighing scales. This is a real niche — possibly a competitive opening, possibly a sign nobody could make it accurate enough to ship.
- **Licensing of Chronojump hardware files** — paper says "design files available to the public" but didn't link a repo. Worth digging into [chronojump.org](https://chronojump.org) directly before assuming GPL/MIT.
- **Plyomat's exact sensor architecture is undisclosed** — they market themselves as "the honest Just Jump" but don't publish how. Tear-down YouTube videos may exist; worth a follow-up search.
- **Thai parts availability for ADS1232 / HX710** — HX711 is everywhere on Lazada/Shopee; the upgrade ADCs may need AliExpress with 2-week lead times. Verify before locking architecture.
- **No DIY build I found has done a Bland-Altman comparison vs a Kistler/AMTI plate.** If commercial accuracy is the goal, that test is the gate — and it requires lab access.

## 6. Commercial Landscape

| Tier | Example | Price | What it does that we can't easily |
|---|---|---|---|
| Phone-only | MyJump 2 | $10 | 240 fps cam, 6 yrs of validation papers |
| Switch mat | Just Jump, Plyomat | $300 | rugged mat, decade of coach trust, dedicated timer |
| Portable strain plate | KINVENT K-Deltas | ~$1.5–2k | 1 kHz, BT, app, CE/medical-ish marketing |
| Dual wireless plate | Hawkin Dynamics | $5–10k | 1 kHz, asymmetry analysis, cloud, validated vs Kistler |
| Lab gold standard | AMTI / Kistler / Bertec | $20–40k | 6-DoF, sub-N accuracy, research grade |

**Where Path 3 lands:** functionally between Just Jump ($300) and K-Deltas ($1.5k). Build cost ~฿2,500–4,000 (~$70–110). To sell, you need either: (a) accuracy parity with K-Deltas validated against a real plate, or (b) a price/UX advantage in SEA where K-Deltas is rare and expensive to import. Path (b) is the realistic 2026 play — Lazada has zero credible competitors in the ฿3–10k price band, and Thai S&C coaches still buy Just Jump at ฿15–20k landed.

**Honest caveat:** every cheap DIY build I found that claimed "as good as a force plate" was validated against a phone camera, not against a Kistler. Be careful what you promise.
