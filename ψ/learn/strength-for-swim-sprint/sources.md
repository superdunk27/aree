# Sources — Strength Training for Swim Sprint

Bibliography for the survey in `ψ/learn/strength-for-swim-sprint/`. Each entry tagged with retrieval method and confidence tier.

**Tier 1**: Directly fetched via Jina Reader, verbatim text read. Quotes verifiable.
**Tier 2**: WebSearch summary or abstract-only. Direction reliable, exact numbers should be re-verified before quotation.
**Tier 3**: Secondary citation within a Tier 1/2 paper, not directly read. Cited as "X cited in Y".

---

## Primary sources (Tier 1 — directly fetched + read)

### Jin et al. 2024 — Frontiers in Physiology
- **Title**: The methodology of resistance training is crucial for improving short-medium distance front crawl performance in competitive swimmers: a systematic review and meta-analysis
- **URL**: https://www.frontiersin.org/journals/physiology/articles/10.3389/fphys.2024.1406518/full
- **DOI**: 10.3389/fphys.2024.1406518
- **Type**: Systematic review + meta-analysis (RCTs only)
- **Year**: 2024
- **Sample**: 17 RCTs included; n = ~400+ competitive swimmers, mostly adolescent
- **Retrieved**: 2026-05-08 via Jina Reader
- **Used in this survey for**: Modality framework (CRT/PT/DLRT/ART), subgroup-analysis effect sizes, mechanism via stroke rate vs stroke length, GRADE evidence quality
- **Confidence**: high — read full abstract, methods, results, discussion, conclusion

### Aouani et al. 2025 (publication 2026) — Frontiers in Sports & Active Living
- **Title**: Relative contributions of upper-body muscular power and repeated sprint ability to 50-m freestyle swimming performance in competitive swimmers
- **URL**: https://www.frontiersin.org/journals/sports-and-active-living/articles/10.3389/fspor.2025.1751687/full
- **DOI**: 10.3389/fspor.2025.1751687
- **Published**: 2026-01-15
- **Type**: Cross-sectional correlational
- **Sample**: 36 male national-level competitive swimmers, age 16.4 ± 0.3, 50m PBs 26.56–28.12s
- **Key result**: Pmax (bench press load-velocity profile) r = −0.86 with 50m time; only independent predictor (β = −0.027, p < 0.001); R² = 0.86
- **Retrieved**: 2026-05-08 via Jina Reader
- **Used in this survey for**: Pmax-as-best-predictor headline, methodology of load-velocity profile testing, multiple-regression interpretation
- **Confidence**: high — read full abstract, methods, results, discussion

### Sprint Factors Review 2024 — Springer Sports Medicine
- **Title**: Factors Relating to Sprint Swimming Performance: A Systematic Review
- **URL**: https://link.springer.com/article/10.1007/s40279-024-02172-4
- **Year**: 2024
- **Type**: Systematic review
- **Retrieved**: 2026-05-08 via Jina Reader (293KB raw markdown — large file, key sections read)
- **Used in this survey for**: "Velocity-oriented rather than load-oriented strength" framing; physiological factor list
- **Confidence**: medium-high — abstract + key-points read, body too large for full read in this session, key findings extracted
- **Reading note**: file persisted at `tool-results/b69e2kkgy.txt` for future sessions

### Crowley et al. 2017 — Springer Sports Medicine
- **Title**: The Impact of Resistance Training on Swimming Performance: A Systematic Review
- **URL**: https://link.springer.com/article/10.1007/s40279-017-0730-2
- **DOI**: 10.1007/s40279-017-0730-2
- **Year**: 2017
- **Type**: Systematic review
- **Retrieved**: 2026-05-08 via Jina Reader (mostly bibliography returned, body content sparse)
- **Used in this survey for**: Quoted from secondary citations within Aouani 2025 and Jin 2024 (e.g., bench press power r = −0.68 to −0.79, low-volume high-intensity recommendation, fatigue mechanism for DLRT failure)
- **Confidence**: medium — directly fetched but body text was thin; relied partly on quotes-of-quotes via Jin 2024
- **Reading note**: file persisted at `tool-results/b6x226uu4.txt`

---

## Primary sources (Tier 2 — abstract or summary only)

### Schoenfeld / Rolnick et al. 2024 — Springer Sports Medicine
- **Title**: Minimalist Training: Is Lower Dosage or Intensity Resistance Training Effective to Improve Physical Fitness? A Narrative Review
- **URL**: https://link.springer.com/article/10.1007/s40279-023-01949-3
- **Type**: Narrative review
- **Retrieved**: 2026-05-08 via Jina Reader (abstract + intro returned; full body 229KB persisted)
- **Used in this survey for**: General framing of minimum-effective-dose research
- **Confidence**: medium — abstract directly read, body large file persisted but not parsed in detail
- **Reading note**: file persisted at `tool-results/b4jkp63m1.txt`

### Iversen et al. 2024 — Sports Medicine (PMC)
- **Title**: Resistance Exercise Minimal Dose Strategies for Increasing Muscle Strength in the General Population: an Overview
- **URL**: https://pmc.ncbi.nlm.nih.gov/articles/PMC11127831/
- **Year**: 2024
- **Status**: **Blocked by Jina** (PMC anonymous-access restriction at time of survey)
- **Used in this survey for**: Five minimal-dose strategies framework (Weekend Warrior, single-set RT, snacking, test-practice, eccentric minimal). Numbers extracted from WebSearch summary block only
- **Confidence**: medium — could not directly read; the summary block preserved key categorical findings reliably; specific effect-size numbers not directly verified
- **Future work**: re-fetch via Playwright or alternative reader if claim-level verification needed

### 2025 Frontiers Network Meta-Analysis
- **Title**: Comparative effectiveness of physical training modalities on swimming performance: a two-tier network meta-analysis
- **URL**: https://www.frontiersin.org/journals/physiology/articles/10.3389/fphys.2025.1636595/full
- **Year**: 2025
- **Type**: Two-tier network meta-analysis (36 RCTs, 844 swimmers)
- **Used in this survey for**: Combined aquatic + dryland ranks highest claim
- **Confidence**: medium — WebSearch summary only, not directly fetched
- **Future work**: full fetch if claim depth needed

---

## Secondary sources (Tier 3 — cited within Tier 1/2 papers, not directly read)

These are studies whose numbers appear in this survey because they were quoted in a directly-read paper. Listed for traceability.

### Strass 1988
- 3 sets × 3 reps × 90–100% 1RM, 6 weeks, 24 sessions, 10 male competitive swimmers
- Improved 25m + 50m front crawl via stroke length increase
- Cited in Jin 2024 §4.1
- Original publication likely in older J Strength Cond Res or equivalent — not directly fetched

### Hawley et al. 1992 — Br J Sports Med
- DOI: 10.1136/bjsm.26.3.151
- Muscle power r = 0.82 (25m), 0.93 (50m) for upper-limb max strength vs sprint times
- Cited in Jin 2024 §4.1, also referenced in Sprint Factors Review 2024
- Old foundational paper

### Sadowski et al. 2012
- Specialized swim ergometer training vs traditional resistance, 25m sprint outcome
- Significant tethered force gain in ergometer group; non-significant 25m time difference in either group
- Source: WebSearch summary block (resistance training adaptation swim performance Aspenes Sadowski)

### Aspenes et al. 2009 — J Sports Sci Med
- "Combined strength and endurance training in competitive swimmers"
- 11-week butterfly-specific apparatus, 1.4% improvement at 400m
- Cited in Aouani 2025 ref #13 and Jin 2024 ref #5
- Open-access paper — directly fetchable but not pulled in this survey

### Toussaint & Truijens 2005 — Anim Biol
- "Biomechanical aspects of peak performance in human swimming"
- Source for "70%+ propulsion in front crawl from upper limbs" claim
- Cited in Aouani 2025 ref #8

### Loturco et al. 2016 — Int J Sports Med
- Tethered swimming, dryland power, sprint performance correlations
- Cited in Aouani 2025 ref #12

### Bishop et al. 2011 — Sports Med
- Repeated-sprint ability training recommendations
- 8x15m, 30s rest protocol; mean time r = −0.81 with 50m
- Cited in Aouani 2025 ref #9

### Morouço et al. 2011 — J Hum Kinet
- Tethered swimming force r = 0.92 with sprint performance
- Cited in Aouani 2025 ref #4

### Gonjo et al. 2021 — Front Physiol
- Load-velocity profile in 50m front-crawl
- L0 r = 0.632, L0/BM r = 0.743, V0 r = 0.698, slope r = 0.541
- Source: WebSearch summary (PMC original blocked)

### Amara 2021a, 2021b, 2022 — multiple
- CRT (concurrent resistance training) RCTs in adolescent swimmers
- Cited extensively in Jin 2024 across §4.1, 4.2.1, 4.2.3
- Author cluster: Amara S., Hammami R., Negra Y., Chortane S.G. (Tunisia)

### Tate et al. 2012; Hill et al. 2015; McKenzie et al. 2023
- Shoulder injury reduction via dryland strength training
- Cited in Jin 2024 §4.1

### Strass / Girold / Sammoud / Norberto / Amara protocols (Section 03)
- All cited in Jin 2024 across §4.1, 4.2 — used to extract specific protocol parameters (sets, reps, intensity, durations)

---

## Methodology notes

### What "directly fetched" means in this survey
- Used `curl https://r.jina.ai/<URL>` (Jina Reader proxy) — returns raw markdown rendering of the page
- Persisted to `tool-results/*.txt` files when output exceeded 30KB
- Content read in tooling: Read tool with offset/limit for sections >25K tokens

### What "WebSearch summary block" means
- Anthropic's WebSearch tool returns a synthesis paragraph alongside link results
- This summary is generated by the search service, not by reading raw page content
- Per `ψ/memory/personal-context.md` §2.2 rule: WebSearch is Tier 6 (overview only), not for technical claims
- Reliance on WebSearch summary in this survey is flagged where used; treat with appropriate skepticism

### Sources NOT covered that probably should be
- **Brent Rushall** writings on sprint swim — known authority, not surveyed here
- **NSCA position stand on swimming** — if exists, would be authoritative
- **Detraining literature** — Toey didn't pick this angle
- **Olympic Lifts for swim transfer** — under-represented in surveyed papers
- **Female sprint swimmer profile** — Aouani 2025 was male-only

### Confidence summary
- **High confidence claims**: Pmax → 50m correlation, Jin 2024 modality framework, "velocity-oriented" framing
- **Medium confidence**: Specific protocol numbers (sets/reps), stroke-rate vs stroke-length mechanism (limited RCTs)
- **Low confidence**: Generalization to masters / 30+ athletes, female athletes, non-front-crawl strokes — population mismatch

### When to update / supersede
Per Oracle Principle 1 (Nothing is Deleted): if a future paper changes a claim, add a "Superseded by [DATE: source]" note inline at the original location. Don't delete.

---

## Re-verification checklist

If Toey wants to verify any specific quote:

1. Find the file persisted at `tool-results/<id>.txt` (paths in entries above)
2. Read the source file
3. Cross-check the quote against original text
4. If discrepancy: update the citing claim in the angle file + add a corrigendum to the bottom of that file
