# HRV, Autonomic Recovery & Training Load Monitoring — The Science and the Tools

**Topic:** Heart Rate Variability (HRV), autonomic nervous system monitoring, training load quantification
**Date:** 2026-05-05
**Status:** Knowledge base — research-mode (build brain, not prescribe)
**Companion doc:** `01_sleep-architecture-recovery-science.md` (parallel write — sleep/recovery is the other half of the autonomic recovery story)
**Audience:** Aree (Oracle), so she can advise Toey sensibly when HRV comes up
**Length target:** 2,500–4,000 words

---

## 1. Executive Summary — Seven Things Aree Must Know

1. **rMSSD is the gold standard for daily HRV monitoring** — not LF/HF, not "HRV score." It captures parasympathetic (vagal) tone, requires only 1–5 min, and survives ultra-short measurements down to 60 s in athletes (Esco & Flatt 2014). It is, however, the *most* artifact-sensitive metric — a single ectopic beat can inflate it ~400% (Giles & Draper 2018; Wang et al. 2022).
2. **The "trend, not the single day" rule is the #1 most-broken HRV principle.** Daily rMSSD coefficient of variation is 25–29%, which completely swamps any meaningful drift. Use a 7-day rolling mean ± 0.5 SD as the personal baseline (Plews, Laursen, Kilding & Buchheit 2013; Altini, multiple).
3. **HRV-guided training beats fixed periodisation by ~0.5–2.1 % on aerobic outcomes** in well-controlled trials — modest, real, but not magic (Kiviniemi 2007; Vesterinen 2016; meta-analyses 2020–2021).
4. **Higher is not always better.** Functionally overreached athletes can show *increased* parasympathetic markers (the "Plews paradox" / parasympathetic saturation). The healthy state is *stable within personal range*, not maximal (Plews et al. 2013, 2014; Bellenger et al. 2017).
5. **Confounders dominate signal.** Alcohol crushes rMSSD for ≥10 h post-ingestion (Bau 2011; Pietilä 2018). Illness, stress, late meals, menstrual cycle phase, breathing pattern, and body position all move the needle more than training load itself.
6. **Device hierarchy:** Polar H10 chest strap ≈ ECG (gold standard for consumer use). HRV4Training and EliteHRV via smartphone PPG with finger sensor → near-chest-strap accuracy. Oura Ring (Gen 3/4) → strongest validation among ring/band wearables. Whoop → moderate accuracy, opaque algorithms. Garmin's overnight HRV → poor for resting HRV in independent comparisons.
7. **HRV alone is insufficient. Subjective wellness questionnaires beat objective measures** for reflecting training response in the Saw, Main & Gastin (2016) systematic review. Best practice combines HRV + a 4–6 question wellness scale + training load (session-RPE).

---

## 2. The Autonomic Nervous System Primer

The ANS regulates involuntary physiology via two opposing branches:

- **Sympathetic (SNS):** "fight or flight." Releases catecholamines (adrenaline/noradrenaline). Raises HR, contractility, BP, mobilises glucose. Dominant during exercise, stress, threat.
- **Parasympathetic (PNS):** "rest and digest." Acts via the **vagus nerve** (CN X) on the sinoatrial node via acetylcholine. Slows HR, promotes digestion, supports recovery and tissue repair.

At rest, your sinoatrial node is under continuous parasympathetic *brake*. The intrinsic firing rate of the SA node is ~100 bpm; resting HR of 50–70 reflects how much vagal restraint is being applied. Vagal tone modulates HR beat-to-beat with respiration — inspiration → HR up, expiration → HR down (respiratory sinus arrhythmia, RSA). **HRV = the magnitude of those beat-to-beat fluctuations**, and high parasympathetic outflow = high HRV.

Why this matters for athletes: training stress, illness, sleep deprivation, and psychological stress all push the autonomic balance toward sympathetic dominance, reducing vagal modulation and therefore HRV. *Provided* you measure under standardised conditions, HRV is a non-invasive proxy for "how recovered is my ANS right now?"

---

## 3. HRV Metrics — Time, Frequency, Non-Linear

HRV is computed from R-R intervals (the time between successive R peaks of the QRS complex on an ECG, or from the equivalent inter-beat-intervals derived from PPG).

### Time-domain
- **rMSSD** — Root Mean Square of Successive Differences between adjacent R-R intervals. Reflects beat-to-beat variability → **parasympathetic / vagal**. Stable across short recordings. Often log-transformed (lnRMSSD) for normality.
- **SDNN** — Standard Deviation of NN intervals. Captures *total* variability over the measurement window, blending sympathetic + parasympathetic. Highly window-length dependent (24-h SDNN ≠ 5-min SDNN).
- **pNN50** — Percentage of consecutive R-R intervals differing by >50 ms. Vagal proxy, but coarser than rMSSD.

### Frequency-domain (spectral analysis)
- **HF (High Frequency, 0.15–0.40 Hz)** — Tracks respiration, **parasympathetic**.
- **LF (Low Frequency, 0.04–0.15 Hz)** — Mixed sympathetic + parasympathetic + baroreflex. *Not* a clean sympathetic marker (this is a common myth).
- **LF/HF ratio** — Often marketed as "sympathovagal balance." The Task Force (1996) original framing has been heavily criticised; not recommended for individual decisions (Billman 2013).

### Non-linear (Poincaré plot)
- **SD1** — Short-axis of the Poincaré ellipse; mathematically equivalent to rMSSD/√2. Vagal.
- **SD2** — Long-axis; reflects long-term variability.
- **SampEn / DFA-α1** — Entropy / detrended fluctuation analysis. Used in research; emerging interest (Rogers et al. 2021 on DFA-α1 as a non-invasive proxy for the first ventilatory threshold).

### Why rMSSD wins for daily monitoring
1. Reflects **vagal tone**, the variable that actually moves with training stress.
2. Stable from 1 min recordings in athletes (Esco & Flatt 2014).
3. Math is simple → no spectral assumptions, no resampling artefacts.
4. **However:** Giles & Draper (2018) and Wang et al. (2022) showed rMSSD is dramatically more sensitive to ectopic beats and missed detections than LF/HF — a single artifact in a 5-min recording can inflate rMSSD ~270–413%, while LF/HF moves <10%. **Implication: rMSSD requires clean signal acquisition** (chest strap or validated PPG), and software must filter ectopic beats before computing.

---

## 4. Measurement Protocols — Standardisation Is Everything

The standard recommendations (Task Force 1996; refined by Plews et al. 2013; Altini's HRV4Training protocol):

| Variable | Standard | Notes |
|---|---|---|
| **Time of day** | First thing AM, immediately after waking | Before coffee, scrolling, or stand-up. Stress already moves HRV by 5–7 minutes after waking. |
| **Position** | Supine OR seated — *pick one and stick with it* | Orthostatic (supine→standing) is more sensitive for some research questions but less practical daily. |
| **Duration** | 1–5 min after a 1-min stabilisation | 60 s minimum for lnRMSSD in athletes (Esco & Flatt 2014). Longer is *not* better for daily monitoring. |
| **Breathing** | **Spontaneous (free-paced)** | Altini reversed his earlier paced-breathing recommendation. Paced breathing artificially inflates HRV; free breathing reflects actual state. Within-individual longitudinal trends are equivalent. |
| **Pre-conditions** | Empty bladder; no caffeine, food, or hard exercise in the prior period | Standardise as much as is practical. The signal of interest is small relative to confounders. |
| **Frequency** | Daily | A 7-day rolling baseline requires daily data. 3–4×/week is acceptable but loses resolution. |

**Morning vs nocturnal (overnight) HRV.** Overnight HRV (Whoop, Oura, Apple Watch nightly) integrates a multi-hour window including REM (sympathetic) and SWS (parasympathetic) cycles. It avoids the "did I just stand up" problem but **introduces sleep-architecture confounding**: a night with poor REM proportion can look "high HRV" simply due to compositional shift. Altini's case-study work argues morning spot checks under controlled conditions remain the cleanest signal for autonomic state.

---

## 5. Devices & Accuracy — What Altini Has Actually Validated

Altini has done more peer-reviewed validation than any other figure in the consumer space. The hierarchy from his (and independent) data:

1. **Polar H10 chest strap** — accepted gold-standard reference for non-clinical HRV. Used as criterion in essentially every wearable validation study.
2. **HRV4Training (smartphone camera/PPG, finger sensor)** — multiple peer-reviewed validations vs ECG and Polar H10; near-criterion accuracy when measurement protocol is followed (Altini & Plews 2021 in *Sensors*, among others).
3. **Oura Ring Gen 3 / Gen 4** — strongest accuracy among rings/bands in independent head-to-head studies (Cao et al. 2022; multiple 2024–2025 comparisons). Altini is an advisor to Oura; disclose accordingly.
4. **Whoop 4.0** — moderate accuracy for resting HRV. Algorithms are proprietary/opaque. Probably better than rings during exercise HR; weaker for resting HRV in independent tests.
5. **Garmin Fenix / Forerunner overnight HRV** — poor in head-to-head studies vs H10 (Garmin "beaten by Oura & Whoop" in 2025 comparison work). The wrist optical sensor is the bottleneck.
6. **Polar Grit X Pro (wrist)** — surprisingly poor in 2025 comparisons despite Polar's chest-strap pedigree. Wrist PPG is the limiter, not the brand.
7. **Apple Watch** — HRV (rMSSD) point measurements via Breathe app are reasonable; nightly HRV is intermittent, not continuous.

**Practical guidance for Aree:** if Toey wants a single device for HRV, the Polar H10 + HRV4Training app on his phone is the most accurate and the cheapest validated stack. If he prefers passive overnight tracking, Oura is the strongest ring; Whoop is fine but you cannot inspect the math.

---

## 6. The "Trend Not Single-Day" Rule — Why Most People Get HRV Wrong

This is the single most important methodological principle and the one most violated.

**The math problem.** Healthy daily rMSSD has a coefficient of variation of ~25–29% within an individual (Plews 2014; Altini multiple). Annual training-related drift is on the order of ~0.3 ms/year. **Daily noise is ~100× larger than the training signal.** Any decision driven by *one* number is statistically uninformed.

**The Plews/Buchheit baseline.** Compute the 7-day rolling mean of lnRMSSD. Then compute a "smallest worthwhile change" (SWC) corridor as **mean ± 0.5 × SD** of that 7-day window (Plews, Laursen, Kilding & Buchheit 2013). When today's value sits inside the corridor → continue planned training. When it drops *below* the corridor for ≥2 consecutive days → reduce intensity or rest. When the corridor itself trends *down* week over week → systemic fatigue accumulating.

**The Altini "normal range" framing.** HRV4Training uses the same logic but markets it as "aim for stability, not higher" — explicitly correcting the popular "higher = better recovered" misreading. Within-individual normal range is what matters; comparing your rMSSD to a friend's is meaningless because resting rMSSD varies enormously across genetically and morphologically different individuals at equivalent fitness.

**Coefficient of variation as a meta-metric.** Some research (Plews 2014; Flatt) suggests the *CV of rMSSD over a rolling window* may itself be informative — elite endurance athletes show lower CV when well-adapted; rising CV may flag developing maladaptation. Less established than the rolling mean, but a research thread to watch.

---

## 7. HRV-Guided Training — What the RCTs Actually Show

This is the literature most prone to over-claiming. The honest summary:

**Kiviniemi et al. 2007** — 26 moderately-fit males, 4 weeks. HRV-guided group did high-intensity sessions only when morning HF-HRV was at-or-above baseline; control did fixed plan. HRV-guided group improved peak treadmill velocity more than fixed (~3% vs ~1%). First proof-of-concept; small N, short duration.

**Kiviniemi et al. 2010** — replication in females with similar pattern.

**Vesterinen et al. 2016** — 40 recreational runners, 8 weeks. HRV-guided experimental (EXP) vs traditional fixed plan (TRAD). 3000-m time improvement: EXP 2.1 ± 2.0% (significant), TRAD 1.1 ± 2.7% (not significant). Modest advantage.

**Javaloyes et al. 2019** — cyclists, similar design, similar modest advantage.

**Nuuttila et al. 2017, Schmitt et al. 2018** — additional small-sample trials.

**Düking et al. 2021 meta-analysis** (6 trials): HRV-guided training **significantly improved VO₂max, peak aerobic speed/power, and threshold performance** vs predefined training. Effect sizes are modest (small-to-moderate). No clear advantage for specifically maximal performance metrics.

**Vesterinen et al. 2025 RCT in experienced cyclists** (Nature Sci Rep) — extended the comparison to wellness-score-guided, and HR-guided arms; HRV-guided remained competitive but not clearly superior to a smart wellness questionnaire.

**The mechanism is plausibly:** HRV-guided plans accidentally implement *polarised distribution* — they push hard on green-light days and back off on red-light days, which approximates the 80/20 polarized model that Seiler, Laursen, and others have shown is superior to threshold-heavy training. Some of the "HRV benefit" may be polarisation in disguise.

**Aree's calibration:** HRV-guided training is *real but modest* (~0.5–2.1% performance edge in 8–12 wk studies). It is not a cure for poor training plans, and it requires daily compliance + clean measurement. For an athlete already training well with good auto-regulation by feel, the additional yield is small.

---

## 8. Confounders — Larger Than the Training Signal

Listed roughly in order of effect size:

- **Alcohol.** Even moderate doses (≥2 standard drinks) suppress rMSSD/HF-HRV for ≥10 h post-ingestion. Bau et al. (2011): 60 g ethanol → all time-domain HRV indices reduced for 10 h. Pietilä et al. 2018 (Finnish employees, n>4,000): even small doses delay parasympathetic recovery and prolong sympathetic dominance during the first hours of sleep. **Practically: drink Friday night, Saturday morning's HRV is not informative.**
- **Acute illness / infection.** rMSSD drops 24–72 h *before* subjective symptoms in many cases. Not specific (could be gut bug, rising COVID, viral URI).
- **Late or large meals.** Digestion is sympathetic-suppressive (acute parasympathetic up via vagal afferents during digestion, but disrupted morning measurement if measured supine after a midnight binge).
- **Psychological stress.** Work deadlines, arguments, sleep onset latency anxiety. Altini's data show stress → measurable reductions in baseline.
- **Sleep deprivation / poor sleep architecture.** Linked to next-day HRV reduction; bidirectional with stress.
- **Menstrual cycle phase.** Naturally menstruating women: rMSSD generally *higher* in follicular phase, *lower* in luteal. Effect size small (~3% mean difference; Ronca et al. 2023). High within-individual variability — one cycle's pattern may not predict the next. Hormonal contraceptives flatten the cycle effect. Best practice: track cycle phase as a covariate; do not treat luteal-phase HRV drops as fatigue.
- **Breathing pattern at measurement.** Slow deep breathing artificially boosts HF-HRV and rMSSD. This is why Altini insists on free-paced breathing for baseline measurement — paced breathing is for biofeedback, not for diagnosis.
- **Body position.** Supine > seated > standing for absolute rMSSD. Pick one, never compare across positions.
- **Hydration / temperature.** Dehydration reduces stroke volume, raises HR, drops HRV.
- **Caffeine.** Mixed literature; effect smaller than alcohol but real if measured within 1–2 h of ingestion.

---

## 9. HRV in Taper, Overtraining, and Illness

**The Plews paradox / parasympathetic saturation.** Conventionally we expect "more recovered → higher HRV." Plews and colleagues (2014) showed that in functionally overreached endurance athletes, rMSSD can *increase* paradoxically — heightened vagal tone driving the SA node so hard that respiratory modulation is suppressed, reducing measured beat-to-beat variability fluctuation. In the Bellenger et al. (2017) replication and the Le Meur et al. (2013) lab-controlled overreaching study, **post-exercise parasympathetic reactivation was elevated** in F-OR athletes — counterintuitive but reproducible. **Implication:** an unexpectedly high rMSSD trend, paired with rising training load and falling performance, is *not* a green light — it may flag F-OR. This is why HRV must be paired with subjective wellness and performance markers.

**Taper.** During taper, several patterns appear in the literature:
- Many athletes show *rising* rMSSD baseline as load drops → "normal recovery" pattern.
- Some elite athletes (Plews et al.) show *falling* rMSSD during taper, hypothesised to reflect plasma volume reduction (lower stroke volume → higher HR → lower HRV) — and this *is associated with peak performance*. Counterintuitive but documented.
- Take-home: HRV behaviour during taper is athlete-specific; absolute direction is less informative than the historical pattern of that specific athlete heading into successful past competitions.

**Illness onset.** Pre-symptomatic HRV drops 24–72 h before fever or URI symptoms are common but non-specific. Useful as a "be careful today" flag, not as a diagnostic.

**Non-functional overreaching → overtraining syndrome.** HRV alone cannot diagnose OTS. The current research consensus: OTS requires the combination of unexplained performance decrement + persistent fatigue + mood disturbance + endocrine markers, persisting >2–4 weeks despite rest. HRV is contributory evidence, not standalone.

---

## 10. HRV and Age — The Trajectory

Vagal-mediated HRV (rMSSD, HF) declines with age, but the rate is not linear.

- **Mid-20s to 60s:** rMSSD declines ~1–3% per year on average (Umetani et al. 1998 *JACC* 9-decade study; multiple replications).
- **Approximate population medians (Lifelines Cohort, 10-s ECG):** rMSSD ~67 ms in early teens → ~16 ms in 75+ category.
- **Exercise blunts the decline.** Aerobically-trained adults retain higher HRV at every age decile vs sedentary peers. The decline rate appears modulated by VO₂max, sleep quality, and stress load — not purely chronological age.
- **Beyond ~60s, decline plateaus** in some longitudinal series (Stein et al. work and follow-ups).

For Toey at 31, the relevant takeaway is: *his HRV trajectory should be roughly stable or slightly declining year over year if training is stable*; substantial drops in 7-day baseline beyond cyclical noise are signal, not aging.

---

## 11. Subjective Wellness vs HRV — Saw, Main & Gastin (2016)

**The headline finding.** Saw, Main & Gastin's systematic review of athlete monitoring (*BJSM* 2016, ~280 studies covered) concluded: **"subjective self-reported measures trumped commonly used objective measures"** — including HRV — for reflecting acute and chronic training-related changes in athlete wellbeing. POMS, RESTQ-S, DALDA, and short custom 4–6 item Likert scales (sleep quality, fatigue, muscle soreness, stress, mood) outperformed single-modality objective measures.

**Why subjective wins.** A wellness questionnaire integrates cognitive, emotional, somatic, and contextual information that no single physiological measure can. HRV can flag autonomic shift; only the athlete can report "I feel emotionally flat and my legs are heavy."

**Why HRV still matters.** It is *non-falsifiable* (can't lie to your sensor), captures pre-symptomatic changes (illness onset), and provides continuous quantitative data. The 2024–2025 consensus view (Sensors 2024 narrative review): **combine HRV + brief daily wellness scale + training load (session-RPE)** for the highest-resolution monitoring picture.

**Aree's framing for Toey:** if he wants the lightest-touch monitoring system, a 30-second daily wellness scale beats HRV for actionable signal. If he wants both, HRV adds objective continuity, but only after the wellness habit is stuck. Don't lead with HRV.

---

## 12. Training Load Monitoring — TSS, session-RPE, TRIMP, ACWR

HRV is one half of monitoring (the *response* side). The other half is *what you actually did* (the load side).

### Banister's TRIMP (1991)
- **Training Impulse.** Duration × HR-reserve fraction × intensity weighting (exponential or piecewise). Captures cardiovascular load via HR.
- Original Banister model uses exponential weighting biased toward high intensity.
- Edwards' TRIMP: sums minutes in HR zones × zone weights (1–5).
- Lucia's TRIMP: minutes in 3 lactate-defined zones × 1, 2, 3.
- **Strength:** physiologically grounded, validates against blood lactate.
- **Limitation:** requires HR; misses neuromuscular load (lifting, sprinting, eccentric work).

### Foster's session-RPE (2001)
- **Internal load = session duration (min) × session RPE (Borg CR-10).**
- Athlete rates 0–10 about 30 min after the session.
- 950+ studies cite the original; 36+ direct validation studies. Correlates with TRIMP across endurance, team sports, combat sports.
- **Strength:** modality-agnostic — works for lifting, sprinting, swimming, conditioning circuits.
- **Limitation:** depends on athlete's calibration of effort; group means are robust but individual ratings drift.

### TSS (Training Stress Score) — Coggan
- Cycling/running specific. TSS = (duration_seconds × NP × IF) / (FTP × 3600) × 100.
- 100 TSS = 1 hour at threshold. Built into TrainingPeaks, WKO, etc.
- Foundation for **CTL (Chronic Training Load, 42-day exponentially-weighted average)** and **ATL (Acute Training Load, 7-day EW average)**, with **TSB (Training Stress Balance) = CTL − ATL** as freshness proxy.
- **Strength:** quantitative, continuous, easy to chart.
- **Limitation:** requires power meter (cycling) or pace + threshold pace (running). FTP drift confounds long-horizon comparisons.

### ACWR (Acute:Chronic Workload Ratio) — Gabbett
- Acute load (typically 7-day rolling sum) / Chronic load (28-day rolling sum). "Sweet spot" claimed at 0.8–1.3; "danger zone" >1.5 supposedly elevates injury risk.
- Originated from Gabbett's rugby/cricket work; widely adopted in team sport sports-science circa 2016–2019.
- **The critique (Impellizzeri, Lolli, Curran-Everett, Bornn, Carey, et al., 2019–2021):**
  - Mathematical artifacts: ratios of correlated variables produce spurious associations.
  - "Sweet spot" figure was based on flawed methodology; Impellizzeri et al. petitioned *BJSM* for retraction/correction.
  - Time windows (7 and 28 days) are arbitrary; sensitivity to choice is large.
  - Independent replications either fail to find the U-shaped injury relationship or find effect sizes far smaller than originally claimed.
  - Bornn et al. (2019) "are running on empty" critique: ratio approach masks rather than reveals load patterns.
- **Current consensus:** ACWR is *not* a validated injury-prediction tool. It can be a useful descriptive lens (sudden load spikes are intuitively risky) but should not drive load decisions in isolation. Sports-science orthodoxy circa 2024–2025 has largely retreated from strong ACWR claims.

### Practical synthesis for Aree
| Load metric | Best for | Limitation |
|---|---|---|
| **session-RPE × duration** | Universal, free, modality-agnostic | Subjective drift |
| **TRIMP** | HR-driven endurance work | Misses non-HR loads |
| **TSS / CTL / ATL / TSB** | Cyclists, runners with power/pace | Modality-specific, FTP drift |
| **ACWR** | *Descriptive* lens for sudden spikes | Not a validated predictor; do not over-interpret |

For Toey (swimmer + gym + full-time job), the cleanest stack is: **session-RPE × duration as universal load metric, layered with a 4–6 item wellness scale, optionally with HRV when behaviour permits daily measurement.**

---

## 13. When Aree Should Recommend HRV Tracking — Decision Framework

Aree's job is not to push HRV. The question is: *will daily HRV measurement net-improve Toey's training and life, or net-add anxiety?*

**Recommend HRV when:**
1. He has a clear performance goal with a periodised plan (e.g. ramp + taper for a meet) and wants objective taper-readiness data.
2. He has the **measurement habit infrastructure** (consistent wake time, consistent measurement environment) for ≥4 weeks of baseline data.
3. He is willing to use **chest strap or HRV4Training** (clean signal) — not a wrist-based estimate.
4. He understands the **trend-not-single-day** rule and won't spiral on a single low day.
5. Subjective wellness habit is already in place (he's not skipping the easier tool to chase the harder one).

**Recommend against HRV when:**
1. His sleep schedule is irregular (shift work, late nights, kids — measurement noise will dominate).
2. He is in a phase where he's anxious about his body and adding a metric will worsen rumination.
3. He doesn't have access to a validated device and would rely on overnight wrist-PPG estimates.
4. His subjective wellness habit isn't established yet — start there.
5. Training is unstructured / play-based — there's nothing to optimise against.

**Default starting prescription if he wants something:** 60-second daily 4-question wellness check (sleep quality, fatigue, soreness, mood, 1–5 scale). Two weeks. If sticky, layer in HRV with Polar H10 + HRV4Training on a 4-week trial. After 4 weeks, evaluate: are decisions actually being changed by the data, or is it metric-collection theatre?

---

## 14. The Honest Limits — What HRV Cannot Do

- It **cannot diagnose overtraining syndrome** alone (requires performance + mood + endocrine + duration criteria).
- It **cannot predict injury** in any rigorous sense; the ACWR critique applies more broadly.
- It **does not directly measure "recovery"** — only autonomic balance, which is *one* facet of recovery (others: muscle damage markers, glycogen, hormonal milieu, mood).
- It **does not tell you what to do** — only flags state. The coaching decision still has to be made by a human (or a thoughtful Oracle).
- For **single sessions** (acute readiness for *today's* workout), the day-to-day HRV correlation with performance is modest. Aim sessions with HRV trends, not single days.
- It is **vulnerable to gaming** — slow breathing during measurement, hypocapnia, and other tricks can inflate HRV without changing autonomic state. Treat HRV with the same epistemic care as a self-reported scale.

---

## 15. References — Inline Citations

**Foundational reviews / frameworks:**
- Buchheit M. (2014). *Monitoring training status with HR measures: do all roads lead to Rome?* Frontiers in Physiology 5:73. https://www.frontiersin.org/journals/physiology/articles/10.3389/fphys.2014.00073/full — the canonical applied review of resting HR, HRV, and HRR for training monitoring.
- Task Force of the European Society of Cardiology and NASPE (1996). *Heart rate variability: standards of measurement, physiological interpretation and clinical use.* Circulation 93:1043-65.
- Plews DJ, Laursen PB, Kilding AE, Buchheit M. (2013). *Training adaptation and heart rate variability in elite endurance athletes: opening the door to effective monitoring.* Sports Medicine 43:773-81. https://pubmed.ncbi.nlm.nih.gov/23852425/

**HRV-guided training trials:**
- Kiviniemi AM et al. (2007). *Endurance training guided individually by daily heart rate variability measurements.* Eur J Appl Physiol. https://pubmed.ncbi.nlm.nih.gov/17849143/
- Vesterinen V et al. (2016). *Individual endurance training prescription with heart rate variability.* Med Sci Sports Exerc. https://pubmed.ncbi.nlm.nih.gov/26909534/
- Javaloyes A et al. (2019). HRV-guided cycling training trial.
- Düking P et al. (2021). HRV-Based Training for Improving VO2max in Endurance Athletes — Systematic Review with Meta-Analysis. https://pmc.ncbi.nlm.nih.gov/articles/PMC7663087/
- *Effectiveness of Training Prescription Guided by Heart Rate Variability Versus Predefined Training* — meta-analysis. https://www.mdpi.com/2076-3417/10/23/8532
- *HRV-Guided Training for Professional Endurance Athletes: A Cluster-RCT Protocol* (2020). https://pmc.ncbi.nlm.nih.gov/articles/PMC7432021/
- *Individual training prescribed by heart rate variability, heart rate and well-being scores in experienced cyclists* (2025) Sci Rep. https://www.nature.com/articles/s41598-025-13540-z

**Overreaching, taper, parasympathetic saturation:**
- Le Meur Y et al. (2013). *Evidence of parasympathetic hyperactivity in functionally overreached athletes.* Med Sci Sports Exerc. https://pubmed.ncbi.nlm.nih.gov/24136138/
- Bellenger CR et al. (2017). HRV and overreaching review.
- Schäfer D et al. (2020). *The Impact of Functional Overreaching on Post-exercise Parasympathetic Reactivation in Runners.* Frontiers in Physiology. https://www.frontiersin.org/journals/physiology/articles/10.3389/fphys.2020.614765/full
- Altini M. *Heart Rate Variability and Tapering* — Substack essay. https://marcoaltini.substack.com/p/heart-rate-variability-hrv-and-tapering
- Altini M. *Parasympathetic saturation*. https://marcoaltini.substack.com/p/parasympathetic-saturation

**Ultra-short measurement, signal processing:**
- Esco MR, Flatt AA. (2014). *Ultra-short-term heart rate variability indexes at rest and post-exercise in athletes.* J Sports Sci Med. https://www.semanticscholar.org/paper/Ultra-short-term-heart-rate-variability-indexes-at-Esco-Flatt/6e03b6adedae1e9a20023f07ab41a231b90e1c00
- Flatt AA, Esco MR. (2015). *Evaluating Individual Training Adaptation With Smartphone-Derived Heart Rate Variability in a Collegiate Female Soccer Team.* https://pubmed.ncbi.nlm.nih.gov/26200192/
- Flatt AA — HRVtraining.com archive of applied collegiate work. https://hrvtraining.com/
- *RMSSD Is More Sensitive to Artifacts Than Frequency-Domain Parameters* (2022). https://pmc.ncbi.nlm.nih.gov/articles/PMC9157524/

**Devices & validation:**
- Altini M. *Recommended sensors for HRV measurement.* https://marcoaltini.substack.com/p/recommended-sensors-for-heart-rate
- Altini M. *Wearables for HRV Measurement: Analysis of Data Quality.* Medium. https://medium.com/@altini_marco/wearables-for-heart-rate-variability-hrv-measurement-analysis-of-data-quality-and-issues-with-a50ae8127a8b
- Altini M. *Research: On The Accuracy of Wearables for HRV.* https://marcoaltini.substack.com/p/research-on-the-accuracy-of-wearables
- *Garmin beaten by Oura & Whoop in HRV accuracy showdown* — independent test summary (2025). https://the5krunner.com/2025/10/06/garmin-beaten-by-oura-whoop-in-hrv-accuracy-showdown/

**Confounders:**
- Bau PFD et al. (2011). *Alcohol consumption, cardiac autonomic regulation and HRV.* — 17-h post-ingestion suppression.
- Pietilä J et al. (2018). *Acute Effect of Alcohol Intake on Cardiovascular Autonomic Regulation During the First Hours of Sleep* (Finnish employees, n>4,000). JMIR Mental Health. https://pmc.ncbi.nlm.nih.gov/articles/PMC5878366/
- Quintana DS et al. *Heart rate variability in alcohol use: a review.* https://www.sciencedirect.com/science/article/abs/pii/S0091305718303447
- Spielmann GJ et al. *Effect of Different Phases of Menstrual Cycle on Heart Rate Variability.* https://pmc.ncbi.nlm.nih.gov/articles/PMC4625231/
- Ronca F et al. (2024). EndureIQ big-data study on HRV across menstrual cycle. https://www.endureiq.com/blog/changes-in-hrv-with-training-intensity-and-the-menstrual-cycle-insights-from-our-big-data-study
- Altini M. *HRV, the Menstrual Cycle, Pregnancy, and Menopause.* https://marcoaltini.substack.com/p/heart-rate-variability-hrv-the-menstrual
- *Wearable-Derived HRV Across the Menstrual Cycle* — living systematic review (2025) Sports Medicine. https://link.springer.com/article/10.1007/s40279-025-02388-y

**Aging:**
- Umetani K, Singer DH, McCraty R, Atkinson M. (1998). *Twenty-Four Hour Time Domain HRV and HR: Relations to Age and Gender Over Nine Decades.* JACC. https://www.jacc.org/doi/10.1016/S0735-1097(97)00554-8
- *Reference values of HRV from 10-s resting ECGs: the Lifelines Cohort Study.* https://pmc.ncbi.nlm.nih.gov/articles/PMC7734556/

**Subjective wellness:**
- Saw AE, Main LC, Gastin PB. (2016). *Monitoring the athlete training response: subjective self-reported measures trump commonly used objective measures: a systematic review.* BJSM. https://pmc.ncbi.nlm.nih.gov/articles/PMC4789708/
- Sensors 2024 narrative review: *Monitoring Training Adaptation and Recovery Status in Athletes Using HRV via Mobile Devices.* https://pmc.ncbi.nlm.nih.gov/articles/PMC12787763/

**Training load:**
- Foster C et al. (2001). *A new approach to monitoring exercise training* (session-RPE). J Strength Cond Res.
- Haddad M et al. (2017). *Session-RPE Method for Training Load Monitoring: Validity, Ecological Usefulness, and Influencing Factors.* Frontiers in Neuroscience. https://www.frontiersin.org/journals/neuroscience/articles/10.3389/fnins.2017.00612/full
- Banister EW. (1991). Modeling elite athletic performance. *Physiological testing of elite athletes.*

**ACWR critique:**
- Impellizzeri FM, Tenan MS, Kempton T, Novak A, Coutts AJ. (2020). *Acute:Chronic Workload Ratio: Conceptual Issues and Fundamental Pitfalls.* Int J Sports Physiol Perform. https://pubmed.ncbi.nlm.nih.gov/32502973/
- *The acute-chronic workload ratio-injury figure and its 'sweet spot' are flawed.* https://www.researchgate.net/publication/333589357
- *Editorial: Acute:Chronic Workload Ratio: Is There Scientific Evidence?* Frontiers in Physiology (2021). https://www.frontiersin.org/journals/physiology/articles/10.3389/fphys.2021.669687/full
- Andrade R et al. (2020). *Is the ACWR Associated with Risk of Time-Loss Injury in Professional Team Sports? A Systematic Review.* https://pubmed.ncbi.nlm.nih.gov/32572824/

**Altini canonical pieces (for Aree to bookmark):**
- *The Ultimate Guide to Heart Rate Variability (HRV): Part One.* https://marcoaltini.substack.com/p/the-ultimate-guide-to-heart-rate
- *The Ultimate Guide to Heart Rate Variability (HRV): Part Two.* https://marcoaltini.substack.com/p/the-ultimate-guide-to-heart-rate-e26
- *How Should You Measure Your Morning HRV?* https://marcoaltini.substack.com/p/how-should-you-measure-your-morning
- *A Brief History of Heart Rate Variability-Guided Training.* https://marcoaltini.substack.com/p/a-brief-history-of-heart-rate-variability
- *HRV4Training Pro Overview.* https://marcoaltini.substack.com/p/hrv4training-pro-overview-page

---

*End of doc. Companion: 01_sleep-architecture-recovery-science.md (sleep half of the recovery story).*
