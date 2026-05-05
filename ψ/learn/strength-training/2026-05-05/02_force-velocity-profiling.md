# Force-Velocity (F-V) Profiling for Sprint Swimmers

**Author**: Aree
**Date**: 2026-05-05
**Topic**: Mechanical force-velocity profiling — dryland (Samozino jump method) and in-pool (semi-tethered load-velocity) — applied to 50 m freestyle sprinters
**Status**: Knowledge build (research doc, not coaching prescription)

---

## 1. Executive Summary

- **F-V profiling** asks not "how strong is the athlete?" but "*where on the force-velocity continuum* does the athlete leak performance?" — and prescribes training to fix the leak (Samozino et al., 2012; Jiménez-Reyes et al., 2017).
- **Dryland method** (Samozino 2008/2014): perform a series of loaded jumps (5+ loads, 0–60% BW), measure jump height + push-off distance + body mass, fit a linear regression → extract **F0** (theoretical max force at zero velocity), **V0** (theoretical max velocity at zero load), **Pmax = F0·V0/4**, and the slope **Sfv**. Compare actual Sfv to optimal Sfv → **FVimb** percentage.
- **In-pool method** (Dominguez-Castells & Arellano 2012; Gonjo, Olstad et al. 2020): semi-tethered front crawl with progressive loads (typically 1, 5, 9 kg for males) yields a **load-velocity** (L-V) profile with **V0** (theoretical max swim velocity at zero load), **L0** (theoretical max load at zero velocity), and slope **Slv**. ICC 0.92–0.98 for reliability (Olstad et al., 2020).
- **In-pool V0 correlates ~r=0.70 with 50 m freestyle time**; L0 normalized to body mass correlates ~r=0.74 (Gonjo et al., 2021). Butterfly V0 correlates r=0.89 with race velocity (Dos Santos et al., 2020).
- **Force-deficit** swimmers (high L0, low V0, steep slope) → heavy resistance training (80–95% 1RM, low-velocity, low-rep). **Velocity-deficit** swimmers (low L0, high V0, flat slope) → ballistic / light-load high-velocity work (<30% BW, jump squats, contrast methods). Training to fix FVimb produced **+12–14% jump height gains in 9 weeks** vs unclear results in non-individualized programs (Jiménez-Reyes et al., 2017).
- For 50 m freestyle specifically: most pool-only swimmers drift toward **velocity-rich / force-poor** in dryland (because the pool selects for high-velocity, low-resistance neuromuscular patterns) but toward **force-rich / velocity-poor** in-pool (a 50 m sprint demands force application against water that they are not used to producing). Cameron McEvoy's post-2024 trap-bar deadlift + bench pivot (87 → 94 kg bodyweight) is a textbook **force-deficit correction** [interpretation, see ψ/learn/swimming/cameron-mcevoy].
- **Honest limit**: in-pool F-V is a 2020-onward methodology. Reliability is excellent, but **prescriptive validation** (Jiménez-Reyes-style RCT showing in-pool FVimb correction → faster 50 m) **does not yet exist**. Treat in-pool L-V as a **monitoring + diagnostic tool**, not yet a closed-loop prescription engine.

---

## 2. The F-V Relationship — Mechanical Theory in Plain Language

Hill (1938) showed that an isolated muscle's force output is inversely related to its shortening velocity: maximum force at zero velocity (isometric), and force drops as velocity rises until at maximum velocity, force is zero. Whole-limb push-offs (jumps, sprints, swim pulls) preserve this shape but become approximately **linear** rather than hyperbolic when measured across a range of external loads (Samozino et al., 2012; Morin & Samozino, 2016).

Two parameters define the line:

- **F0** — theoretical maximum force the system can produce at zero velocity (intercept on force axis)
- **V0** — theoretical maximum velocity the system can reach with zero load (intercept on velocity axis)

The line slope **Sfv = −F0/V0** describes the **mechanical "personality"** of the athlete. Two athletes with identical max power (Pmax = F0·V0/4) can have radically different profiles: one steep (high F0, low V0 — a "force athlete") and one flat (low F0, high V0 — a "velocity athlete"). Samozino & Morin's central insight: **for any given ballistic task there is an optimal slope**, and deviation from it costs performance even when Pmax is preserved (Samozino et al., 2012, *Int J Sports Med*).

The performance penalty: subjects in the original 2012 paper lost 0–30 % of jump height purely due to F-V *imbalance*, independent of how much power they could produce (Samozino et al., 2012; PMID 24227123).

---

## 3. Dryland F-V Testing — Protocol, Equations, Equipment

### Protocol (Samozino 2008/2014; Jiménez-Reyes et al., 2017)

1. Warm-up + 2–3 unloaded squat jumps (SJ) or countermovement jumps (CMJ).
2. Perform jumps at 5 loads (typical: 0, 15, 30, 45, 60 % body weight, via barbell or trap-bar).
3. Record **jump height** (h, in m) — via jump mat, force plate, or validated app (MyJump 2 has ICC > 0.95 vs force plate; Balsalobre-Fernández et al., 2015).
4. Record **push-off distance** (h_po, in m) — leg length minus crouch position, or estimated from leg length × 0.4–0.45.
5. Linear-regress mean force vs mean velocity across the 5 loads.

### Equations (Samozino et al., 2008, *J Biomech*; PMID 18789803)

For each loaded jump:

```
F̄ = m · (g + h / h_po)              [mean force, N]
v̄ = √(g · h / 2) · √(h / h_po + 1)   [mean velocity, m/s, approximation]
P̄ = F̄ · v̄                          [mean power, W]
```

Where m = body mass + load (kg), g = 9.81 m/s², h = jump height (m), h_po = push-off distance (m).

Linear regression of F̄ on v̄ across loads:

```
F(v) = F0 − Sfv · v
V0   = F0 / Sfv
Pmax = F0 · V0 / 4
```

### FVimb (force-velocity imbalance)

Samozino's optimal slope **Sfv_opt** depends on Pmax, h_po, and gravitational constants. The exact formula (Samozino et al., 2012):

```
Sfv_opt = −(g / h_po) · √(h_po / (2·g) + Pmax_rel² / g²) − Pmax_rel / g · ...
```

In practice it is computed by the Morin/Samozino spreadsheet (jbmorin.net). The actionable output is:

```
FVimb (%) = 100 · |1 − Sfv / Sfv_opt|
```

Categorization (Jiménez-Reyes et al., 2017, Table 1):

| Sfv / Sfv_opt | Category |
|---|---|
| < 60 % | High force deficit |
| 60–90 % | Low force deficit |
| 90–110 % | Well-balanced |
| 110–140 % | Low velocity deficit |
| > 140 % | High velocity deficit |

### Equipment options

- **Gold standard**: force plate + linear position transducer.
- **Field standard**: jump mat (Optojump, Chronojump) + barbell.
- **Cheap & reliable**: smartphone slow-mo + **MyJump 2** app (Balsalobre-Fernández et al., 2015). ICC 0.95+ vs force plate. The same author's **MySprint** does the equivalent for 30-m sprint F-V.

---

## 4. In-Pool F-V Testing — Tethered/Semi-Tethered Swim Methodology

### Why in-pool is harder than dryland

A jumper has gravity as the resistance constant. A swimmer has *active drag* — a velocity-dependent, technique-dependent, body-shape-dependent variable resistance. So the "F-V" measured in the pool is really a **load-velocity** (L-V) profile against an externally applied known load while drag still acts. Hence the convention: pool literature calls intercepts **V0** and **L0** (load), not F0.

### Protocol (Dominguez-Castells & Arellano, 2012; Gonjo, Olstad et al., 2020)

1. **Equipment**: 1080 Sprint robotic resistance device (or weight-stack pulley with low-friction overhead system), positioned ~1 m above pool deck at start. Cord clipped to swimmer's pelvic belt.
2. **Loads** (Olstad 2020 protocol):
   - **5-load** (gold): females 1, 2, 3, 4, 5 kg; males 1, 3, 5, 7, 9 kg.
   - **3-load** (practical): females 1, 3, 5 kg; males 1, 5, 9 kg. ICC remains 0.90–0.98 (Olstad et al., 2020).
3. Swimmer performs **25 m semi-tethered** front crawl from a push-off start at maximal effort under each load.
4. Mean velocity is computed over **3 stroke cycles in the mid-pool zone (5–20 m)** to avoid push-off and end-wall effects.
5. **Velocity correction** for the device's overhead height (1 m): V_H = V · cos[sin⁻¹(1.00 / L_C)], where L_C is cord length to swimmer (Gonjo et al., 2021).
6. Linear regression: V = V0 − Slv · L. Extract V0 (m/s), L0 (kg) = V0/Slv, slope Slv (−m/s/kg).

### Reported reliability (Olstad et al., 2020; Gonjo et al., 2021)

- ICC for V0, L0, slope: 0.90–0.98
- CV: 1.4–3.1 %
- R² of the L-V line per swimmer: typically 0.95–0.99

### Reported values in male sprint swimmers (Gonjo et al., 2021; n=14 national-level)

| Parameter | Mean ± SD | Correlation with 50 m time |
|---|---|---|
| V0 (m/s) | 1.80 ± 0.07 | r = −0.70, p = 0.006 |
| L0 (kg) | 21.83 ± 5.69 | r = −0.63, p = 0.015 |
| L0 / body mass | — | r = −0.74, p = 0.002 |
| Slope (Slv, m/s/kg) | −0.09 ± 0.02 | r = 0.54, p = 0.046 |

(Negative correlation with race time = positive correlation with race speed.)

For butterfly (Dos Santos et al., 2020; PMID 32059244): V0 correlated r = 0.89 with race velocity. The L-V approach generalizes across strokes.

---

## 5. Reading the Profile — F0/V0/Pmax/Sfv in Practice

### What each parameter tells you

- **F0 (or L0)** — the "anchoring strength." If low, the athlete cannot grip the water (or ground) to push hard at slow velocities. Directly trainable via heavy resistance.
- **V0** — the "open-throttle ceiling." If low, the athlete cannot recruit fast motor units / cycle limbs quickly even at no load. Directly trainable via ballistic, light-load, high-velocity work.
- **Pmax = F0·V0/4** — the apex of the power curve. *Necessary but not sufficient*; two athletes with identical Pmax can perform very differently.
- **Sfv (slope)** — the **shape**. The actionable metric. Compared against Sfv_opt → FVimb.

### Worked example (hypothetical 50 m sprinter, masters age 31)

Dryland CMJ profile:
- F0 = 32 N/kg, V0 = 3.0 m/s, Pmax = 24 W/kg, h_po = 0.40 m
- Sfv_opt computed (via Samozino spreadsheet) ≈ −12 N·s/(m·kg)
- Actual Sfv = F0/V0 = 32/3.0 = −10.7
- Sfv / Sfv_opt = 10.7 / 12 ≈ **89 %** → **low force deficit**

In-pool L-V profile (3-load, 1/5/9 kg, 25 m semi-tethered):
- V0 = 1.78 m/s, L0 = 18 kg, Slv = −0.099
- 50 m PB stable around 24.1 s → V_avg ≈ 2.07 m/s (push-off + glide explains the gap to 1.78 m/s V0)
- L0/BM = 18/74 ≈ 0.24 (vs Gonjo 2021 mean ~0.30) → **below-average force expression in water**

Combined read: dryland says "slightly force-deficient", in-pool says "force expression in water is below the L0/BM benchmark." Convergent signal → bias 9-week training toward heavier dryland (trap-bar 80–90 % 1RM, deadlift, bench pull) + sport-specific in-water resisted work (3–5 × 25 m at 5–9 kg load on the 1080) before adding more ballistic/velocity work.

### What changes the read

- **Loaded squat depth** changes h_po → changes computed F0 [methodological caveat: see Cuk et al., 2014 on knee angle effects].
- **Stroke technique drift** under heavy in-pool load can collapse coordination (Dominguez-Castells & Arellano, 2012) → use only loads where stroke pattern preserved (anecdotally, rate drop > 8 % means abandon that load).

---

## 6. Force-Deficient vs Velocity-Deficient Training Prescriptions

Programs from Jiménez-Reyes et al., 2017 (9-week intervention, 2 sessions/week, 18 weekly sets):

### Force-deficit program (FVimb < 90 %)

- Back squat / leg press / trap-bar deadlift @ **80–95 % 1RM**, 3–5 reps × 4–6 sets
- Slow eccentric (3–4 s lowering)
- Goal: raise F0
- Result in original study: **+24 % F0**, jump height +14.2 %

For swimmers, swap leg press → trap-bar deadlift (squat ankle-stiffness issue per McEvoy/Tim Lane case; ψ/learn/swimming/cameron-mcevoy/2026-05-04/2310_PRIMARY-SOURCE-EXTRACTION.md). Add heavy lat pulldowns / weighted pull-ups (the lat pulldown showed strongest dryland-→-in-pool transfer in Raineteau et al., 2026; PMC12967223).

### Velocity-deficit program (FVimb > 110 %)

- Loaded jumps @ **<30 % BW** (jump squats, broad jumps, depth jumps)
- Assisted jumps (band-overhead) for super-maximal velocity
- Olympic lift derivatives (hang clean, hang snatch) at 50–70 % 1RM
- Goal: raise V0
- Result in original study: **+17.9 % V0**, jump height +12.7 %

For swimmers, add **sport-specific overspeed**: assisted swim sprints (1080 in towed-mode at +10–20 % overspeed, 2–4 × 15 m, full rest) — analogous to overspeed running for sprinters (Loturco et al., 2018, *J Sports Sci*).

### Well-balanced (FVimb 90–110 %)

- Mixed loading across the curve
- Maintenance / general progression
- Re-test every 6–8 weeks; the profile drifts with training stimulus, taper, and detraining

### Velocity-based training (VBT) integration (Loturco et al., 2018, 2021)

Loturco's elite-sprinter dataset (n=126) found that **mean propulsive velocity at the optimum power load** is exercise-specific and remarkably stable:

| Exercise | Velocity that maximises power |
|---|---|
| Half squat | 0.93 m/s |
| Jump squat | 1.02 m/s |
| Bench press | 1.40 m/s |
| Bench throw | 1.67 m/s |

Use a linear position transducer (Speed4Lifts, GymAware, Vitruve) to load-match daily readiness: lift at the load that produces these target velocities.

---

## 7. Application to 50 m Freestyle Sprint

### What direction does the F-V profile of swimmers usually drift?

**Pool-only training** is fundamentally a *high-velocity, low-resistance* neuromuscular environment compared to dry-land sport. So:

- Dryland CMJ in lifelong pool-only swimmers tends to show a **flat profile (velocity-rich / force-poor)** by sprinter benchmarks — i.e. they have a relative force deficit on land [synthesis from Cossor et al., 2014; Crowley et al., 2017 systematic review on dryland & swimming].
- *In the water*, however, the same swimmers may show competitive V0 but a **low L0/BM** if they have never trained against significant external resistance — i.e. they cannot anchor force when the water "gets heavier" (Gonjo et al., 2021 norms).

The McEvoy paradigm shift (2024–2026) is a real-world demonstration of force-deficit correction at elite level: dropping pool volume from 30+ km/wk to 1–2 km/wk and adding heavy trap-bar deadlift + bench press → bodyweight 87 → 94 kg → WR 20.88 (ψ/learn/swimming/cameron-mcevoy). Whether his FVimb was formally measured is unknown, but the *direction* of intervention (raise F0) is consistent with what most masters/sub-elite 50 m freestylers need.

### How to act on the profile (50 m free-specific)

1. **Test once at season start** (dryland CMJ-load + in-pool 3-load L-V on the 1080 if available; if not, use measured times at 0/5/9 kg semi-tethered against a wall pulley with known weights).
2. **Categorize**: force-deficit, velocity-deficit, or balanced — and treat dryland and in-pool reads separately. They can disagree, and that disagreement is information.
3. **Block training** ~9 weeks toward the bigger deficit. Rule of thumb (Jiménez-Reyes 2017 effect sizes):
   - FVimb < 60 % or > 140 % → 9 weeks of *one-side-only* programming
   - FVimb 60–90 % or 110–140 % → 6 weeks dominant + 3 weeks mixed
   - FVimb 90–110 % → mixed, focus on Pmax growth
4. **Re-test at week 6 and end of block**. If FVimb has dropped below 110 % from above, switch toward Pmax development.
5. **Respect taper** — the in-pool V0 jumps in the final 2 weeks pre-race; the slope flattens (a desirable taper-induced shift). This is consistent with the velocity-up adaptation window of low-volume taper (Bosquet et al., 2007).

### A note on McEvoy specifically

His pivot post-Tokyo is most consistent with someone who was **velocity-saturated and force-deficient** — high V0 from 10+ years of high-velocity pool exposure, but a glass ceiling on F0 because he was not loading the system heavily on land. The ankle stiffness pivot (squat → trap-bar) and the bench-press conversion ("first time in his life") are the canonical force-side interventions. We have no published F-V data on him — this is interpretation, not evidence. [Toey-relevant context only]

---

## 8. Limitations & Honest Critique

1. **Optimal Sfv is task-specific.** The Samozino "optimal" formula was derived for a CMJ on flat ground. There is **no validated optimal Sfv for a swim start, an underwater dolphin kick, or a stroke pull**. Borrowing the dryland framework into the pool is reasonable practice but not airtight theory.

2. **The "imbalance hypothesis" itself is contested.** A 2024 systematic review with meta-analysis (Lindberg et al., *J Hum Kinet*) found that individualized FVimb-based training does outperform non-individualized programs for jump height — but effect sizes are smaller than the Jiménez-Reyes 2017 single study suggested, and some recent RCTs (e.g. Lindberg 2021) have failed to replicate the effect. So the principle is real, but the magnitude is overhyped.

3. **In-pool L-V is brand-new in the literature.** Olstad/Gonjo/Morais/Barbosa 2020-onward. Reliability is excellent for the **measurement**, but **prescriptive RCTs** (does correcting in-pool FVimb reduce 50 m time?) are essentially absent at time of writing (May 2026). Use in-pool L-V as **monitoring + diagnostic**, not yet as a closed-loop prescription.

4. **Push-off distance (h_po) is the Achilles heel of the dryland method.** Sensitive to crouch depth, ankle/hip mobility, and how you define "starting position." Variability in h_po → 5–10 % variability in F0/V0 (Cuk et al., 2014; Pérez-Castilla et al., 2019). Standardize ruthlessly between tests.

5. **Drag confounds in-pool readings.** A swimmer who improves technique (lower active drag) will show higher V0 with no actual change in muscular force capacity. Conversely a tired or technique-drifting day will show "force loss" that is really hydrodynamic. Always pair F-V tests with stroke kinematics.

6. **Don't profile if you can't act on it.** If the athlete has only 2 dryland sessions/week and a coach who programs by feel, getting a precise FVimb number is theatre. Use it when you have:
   - a 6–9 week clean training block
   - reliable testing equipment
   - a coach willing to adjust load–velocity emphasis based on the data
   - the athlete's commitment to a single-side block (force or velocity)

7. **Individual variation > group prescription.** Loturco's 2019 paper (PLOS One) on elite athletes found F-V profiles are *more individual than sport-specific* — i.e. two elite sprinters can have very different optimal profiles. Don't anchor to "sprinters should look like X."

8. **Masters-specific gap.** Almost all of the F-V literature is on 18–28 y athletes. A 31-year-old returning sprinter has age-dependent neuromuscular shifts (Type II atrophy, RFD decay) that the optimal-Sfv equation was not built around. [unsourced — open research gap]

---

## 9. References

1. Samozino P, Morin J-B, Hintzy F, Belli A. *A simple method for measuring force, velocity and power output during squat jump.* J Biomech. 2008;41(14):2940–2945. PMID 18789803.
2. Samozino P, Rejc E, Di Prampero PE, Belli A, Morin J-B. *Optimal force–velocity profile in ballistic movements—altius: citius or fortius?* Med Sci Sports Exerc. 2012;44(2):313–322. PMID 21775909.
3. Samozino P, Edouard P, Sangnier S, et al. *Force-velocity profile: imbalance determination and effect on lower limb ballistic performance.* Int J Sports Med. 2014;35(6):505–510. PMID 24227123.
4. Jiménez-Reyes P, Samozino P, Brughelli M, Morin J-B. *Effectiveness of an individualized training based on force-velocity profiling during jumping.* Front Physiol. 2017;7:677. PMC5220048.
5. Jiménez-Reyes P, Samozino P, Morin J-B. *Optimized training for jumping performance using the force-velocity imbalance: individual adaptation kinetics.* PLOS ONE. 2019;14(5):e0216681. PMID 31091259.
6. Morin J-B, Samozino P. *Interpreting power-force-velocity profiles for individualized and specific training.* Int J Sports Physiol Perform. 2016;11(2):267–272.
7. Balsalobre-Fernández C, Glaister M, Lockey RA. *The validity and reliability of an iPhone app for measuring vertical jump performance.* J Sports Sci. 2015;33(15):1574–1579 (MyJump 2 validation).
8. Dominguez-Castells R, Arellano R. *Effect of different loads on stroke and coordination parameters during freestyle semi-tethered swimming.* J Hum Kinet. 2012.
9. Olstad BH, Gonjo T, Njøs N, Abächerli K, Eriksrud O. *Reliability of load-velocity profiling in front crawl swimming.* Front Physiol. 2020;11:574306. PMC7538691.
10. Gonjo T, Eriksrud O, Papoutsis F, Olstad BH. *The relationship between selected load-velocity profile parameters and 50 m front crawl swimming performance.* Front Physiol. 2021;12:625411. PMC7933527.
11. Dos Santos KB, Bento PCB, Pereira G, Rodacki ALF. *Relationships between a load-velocity profile and sprint performance in butterfly swimming.* Int J Sports Med. 2020. PMID 32059244.
12. Raineteau Y, et al. *Are dry-land force-velocity abilities related to in-water load-velocity profiles in sprint swimming?* 2026. PMC12967223.
13. Loturco I, Pereira LA, Cal Abad CC, et al. *Bar velocities capable of optimising the muscle power in strength-power exercises.* J Sports Sci. 2017;35(8):734–741.
14. Loturco I, et al. *Performance and reference data in the jump squat at different relative loads in elite sprinters, rugby players, and soccer players.* Int J Sports Physiol Perform. 2021. PMID 34079166.
15. Loturco I, Pereira LA, Kobal R, et al. *Sprint mechanical variables in elite athletes: are force-velocity profiles sport-specific or individual?* PLOS ONE. 2019;14(3):e0215551.
16. Cuk I, Markovic M, Nedeljkovic A, Ugarkovic D, Kukolj M, Jaric S. *Force-velocity relationship of leg extensors obtained from loaded and unloaded vertical jumps.* Eur J Appl Physiol. 2014;114(8):1703–1714.
17. Bosquet L, Montpetit J, Arvisais D, Mujika I. *Effects of tapering on performance: a meta-analysis.* Med Sci Sports Exerc. 2007;39(8):1358–1365.
18. JB Morin spreadsheet for jump F-V-P profiling: jbmorin.net/2017/10/01/a-spreadsheet-for-jump-force-velocity-power-profiling/
19. ScienceForSport — Force-Velocity Profiling overview: scienceforsport.com/force-velocity-profiling/
20. Aquatics Lab UGR (Arellano group) — Tethered swimming protocols summary: blogs.ugr.es/aquaticslab/en/418-2/

---

## ความเห็นสรุป (Thai synthesis)

- **F-V profile ไม่ใช่ "แข็งแรงเท่าไหร่" — มันคือ "เธอเสีย performance ตรงไหนของเส้น force-velocity"** แล้ว prescribe การฝึกให้ตรงจุด
- **Dryland**: jump 5 loads → F0, V0, Pmax, slope. ใช้แอป MyJump 2 ก็พอ ถ้าไม่มี force plate
- **In-pool**: semi-tethered 3 loads (1/5/9 kg ผู้ชาย) บน 1080 Sprint หรือ pulley → V0, L0, slope. ICC 0.92+
- **Force-deficit** (slope ชัน, F0 ต่ำ) → ฝึกหนัก 80–95% 1RM, 3–5 reps, trap-bar deadlift, weighted pull-up, bench
- **Velocity-deficit** (slope แบน, V0 ต่ำ) → jump squats <30% BW, ballistic, overspeed-assisted
- **50 m freestyle**: นักว่ายส่วนใหญ่ที่ฝึกแต่ในสระ → velocity-rich บนบก แต่ low L0/BM ในน้ำ → ส่วนใหญ่ต้อง raise F0 ก่อน (McEvoy = case study ของแนวนี้)
- **ระวัง**: in-pool F-V เป็น tool ใหม่มาก (2020+) — diagnostic ดี แต่ยังไม่มี RCT พิสูจน์ว่าแก้ FVimb ในน้ำแล้ว 50 m เร็วขึ้น → ใช้เป็น monitoring ก่อน อย่าเอาเป็น prescription engine
- **Push-off distance + drag** เป็นจุดอ่อนของวิธี — standardize ให้สุด, อย่าตีความ pre/post test ที่ technique เปลี่ยน

---

*Compiled by Aree from peer-reviewed literature (2008–2026) for Toey's strength-training brain. Cross-references: ψ/learn/swimming/50m-freestyle/2026-05-04/2231_05_STRENGTH-DRYLAND.md and ψ/learn/swimming/cameron-mcevoy/. Save companion to upcoming docs on plyometrics dose-response and masters-specific power decay.*
