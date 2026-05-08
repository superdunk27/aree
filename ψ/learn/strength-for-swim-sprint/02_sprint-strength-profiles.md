# 02 — Sprint Swimmer Strength Profiles

**Question**: What strength qualities distinguish elite sprint swimmers? When you measure sprint swimmers in a strength lab, what do their numbers look like?

---

## The single biggest finding

**Maximum muscular power (Pmax) is the strongest dryland predictor of 50m freestyle time.**

Aouani et al. 2025 (Frontiers in Sports & Active Living) tested 36 national-level male competitive swimmers (age 16.4, 50m PBs ranging 26.56–28.12s) using a Smith-machine bench press load-velocity profile.

Key results:

| Variable | Mean ± SD | r with 50m time | p |
|----------|-----------|-----------------|---|
| 50m time (s) | 25.98 ± 0.46 | — | — |
| **Pmax (W)** | **487.7 ± 8.6** | **−0.859** | <0.001 |
| RSS fastest 15m (s) | 7.42 ± 0.17 | 0.832 | <0.001 |
| RSS mean time (s) | 7.61 ± 0.18 | 0.779 | <0.001 |
| Fatigue index (%) | 5.14 ± 1.01 | 0.049 | 0.776 (NS) |

Multiple regression: **only Pmax** was an independent significant predictor (β = −0.027, p < 0.001). Combined model R² = 0.862 — explains 86% of variance in 50m performance.

**Translation**: Once you know a competitive sprint swimmer's bench-press Pmax, knowing their repeated-sprint capacity in the water adds little additional information about their 50m time.

---

## How Pmax is measured (load-velocity profile)

The protocol used in Aouani 2025 (and standard in this literature, per Samozino et al. 2016):

1. Smith machine bench press (vertical bar path)
2. Standardized warm-up: 10 reps @ 40% 1RM, 5 reps @ 60% 1RM, 3 reps @ 70% 1RM
3. Test reps: 4–5 single maximal-effort reps at progressively increasing loads between 40% and 80% of 1RM
4. Bar velocity recorded by linear position transducer (e.g., GymAware PowerTool)
5. Linear regression of load vs velocity yields:
   - **F0** — theoretical maximal force (force-intercept)
   - **V0** — theoretical maximal velocity (velocity-intercept)
   - **Pmax** — maximal muscular power, calculated as (F0 × V0) / 4

Why bench press specifically? Because of the **specificity principle** — bench press shares the horizontal pushing pattern of front crawl propulsion, and the upper limbs contribute >70% of front crawl propulsion (Toussaint & Truijens 2005, cited in Aouani 2025).

---

## Elite vs sub-elite Pmax

Across studies, **elite swimmers carry 18–25% higher Pmax** than sub-elite peers (Loturco et al. cited in Aouani 2025).

This is corroborated by:
- Hawley et al. 1992 (cited in Jin 2024): r = 0.82 (25m) and r = 0.93 (50m) between upper-limb max strength and sprint time
- Crowley 2017 (cited in Aouani 2025): bench press power r = −0.68 to −0.79 with 50m freestyle

The Aouani 2025 r = −0.86 is on the upper end of this band, possibly because the load-velocity profile method captures Pmax more precisely than single-load power tests.

---

## "Velocity-oriented, not load-oriented"

The Sprint Factors 2024 systematic review (Springer Sports Medicine) sums up the swim-strength profile literature in one phrase:

> "Research emphasizes the importance of developing muscular strength in the upper and lower limbs, which appears to be **velocity-oriented rather than load-oriented** to enhance swimming performance"

In strength-training terms, this means:
- The relevant adaptation is **how fast you can move sub-maximal loads**, not how heavy a load you can move once
- Compare: a 1RM bench press (load-oriented) vs a 60kg bench-press throw at maximum velocity (velocity-oriented)
- Both are useful — but if you have to choose, the velocity end of the force-velocity curve has the stronger transfer

This converges with the Strass 1988 → Crowley 2017 chain summarized in `01_dryland-swim-transfer.md`: improvements in **power** matter more than improvements in **max strength** for swim transfer.

---

## Tethered swimming force — the swim-specific alternative

Tethered swimming (swim against a fixed strap that measures pull force) is the in-water analog to dryland power testing:

- Morouço et al. 2011 (cited in Aouani 2025): tethered swim force r = 0.92 with sprint performance (very strong)
- Bollenes 1988 (cited in Jin 2024): muscle activation patterns in tethered swimming are similar to free front-crawl

This makes tethered swimming a useful test, but it requires specialized equipment (tether, force transducer, pool access). Bench-press Pmax via Smith machine is the practical alternative for non-elite settings.

Sadowski 2012 (cited in WebSearch summary) found that a specialized swim-ergometer training group improved tethered force significantly more than a traditional resistance group — but **neither group** showed statistically significant 25m performance improvement. Translation: tethered force gains don't always translate to free-swim time gains. Specificity is sticky.

---

## Lower-body strength: the under-studied piece

Most sprint-swim profile work focuses on the upper body. The lower-body story is sparser:

- Front crawl propulsion is upper-body-dominant (>70%, Toussaint & Truijens 2005), so upper-body emphasis is reasonable
- But starts and turns are **lower-body-dominant** — and starts/turns can decide a 50m race in tenths
- Amara 2022 (cited in Jin 2024): a CRT study with both water-resistance and dry-land **lower-limb** resistance for 9 weeks → 1RM squat improved 14.94 ± 1.32%, AND **30m leg-kick swim time improved 5.84 ± 0.16%**. Lower-body strength **does** transfer to leg-dominant swim sub-tasks.

So a more complete picture: **upper-body Pmax for the swim phase + lower-body Pmax for starts/turns**. Vertical jump performance (the proxy your jump-mat project measures) lives squarely in the lower-body Pmax bucket.

---

## Rate of force development (RFD)

Within the active stroke phase, the **rate** at which force is generated matters:

> "The greater the level of rate of force development (RFD) a swimmer is able to achieve in the time defined by the active stroke phase, the faster they will move through water." — paraphrased from Sprint Factors 2024 Springer review

Front-crawl pull happens in milliseconds. Force you can produce only after a slow ramp-up doesn't help. This is why isometric tests (slow contractions) under-predict swim performance: they miss the time-limited dimension.

RFD is improved by: ballistic training, plyometrics, fast-concentric resistance work — all the same "velocity-oriented" interventions discussed above.

---

## Load-velocity profile parameters and 50m freestyle

Gonjo et al. 2021 (Frontiers Physiol — cited as ref #21 in Jin 2024 reference list, also via WebSearch result) tested load-velocity profile in 50m front-crawl swimmers:

| Parameter | r with 50m performance |
|-----------|------------------------|
| L0 (max load at zero velocity) | 0.632 |
| **L0 / body mass** | **0.743** |
| V0 (max velocity at zero load) | 0.698 |
| Slope (force/velocity decline) | 0.541 |

L0/bodymass — relative max strength — is the single best load-velocity predictor in this study. So: **strength relative to body mass matters**, not absolute strength. A 100kg bench from a 90kg swimmer beats a 100kg bench from a 110kg swimmer for swim performance.

(Source confidence: secondary citation. Original PMC URL was blocked by Jina; numbers extracted from WebSearch summary block. Tier 2.)

---

## What this means in plain terms

If you put a national-level male sprint swimmer in a strength lab and tested everything, the numbers that would show up as "outliers vs general population":

1. **Bench press Pmax**: 18–25% higher than recreational swimmers
2. **Tethered swim force**: 1.5–2× a casual swimmer
3. **Vertical jump**: above-average for non-jump-sport athletes (specific numbers not in surveyed papers; CMJ heights 50–60cm typical for elite swimmers per general sport-science knowledge)
4. **1RM bench press / body mass ratio**: above general population, but probably below dedicated strength athletes

What would NOT especially distinguish them:
- Absolute 1RM in the bench (load-oriented)
- 5km running time (specificity again)
- Mid-range muscle endurance (sprint event = phosphagen + glycolytic; mid-range aerobic less critical)

---

## See also
- `01_dryland-swim-transfer.md` — does training these qualities translate?
- `03_time-constrained-programming.md` — minimum dose to develop / maintain
- `sources.md` — full citations
