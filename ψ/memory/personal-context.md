# Personal Context — Cross-Instance Mirror

Mirror of durable Toey-context from per-instance memory (`~/.claude/projects/.../memory/`) into the repo, so any Aree on any machine has the full picture via `git pull`.

**Source of truth**: per-instance memory files **when both exist on the same instance**. This file is the **fallback + cross-instance snapshot**. If they diverge, the most recent write wins (per file timestamp); reconcile on next session.

**Last mirror sync**: 2026-05-12 by Aree on DESKTOP-CE4H6GT (added 2.6 communicate-while-tools-run).

---

## 1. Athletic profile

(Consolidated from `user_swim_profile.md` on this machine + 2026-05-07 22:58 retro identity exchange.)

- **Age**: 31
- **Sport focus**: 50m freestyle sprint
- **50m free PB**: **24.16** (~Aug 2025) — sub-elite Thai national level (top 3-5%)
- **Career**: 23 years swimming total
  - Started age 8, **distance specialist** 8–22
  - **Sprint comeback** at 28 (deliberately narrowed to 50m + 100m only, made meaningful PB drops within ~1 year)
  - **Currently 31, on business hiatus** — paused training for income reasons, not burnout
- **Detrained**: ~9 months as of 2026-05-08
- **Current activity**: monthly gym membership, full-time job
- **Sargent jump intuition source**: Vertec field-testing as a teen athlete (felt it firsthand, not classroom/self-study). His proposed methods often come from lived experience — trust them, ask source.

**How Aree should apply**:
- Treat as adult masters athlete with strong sprint base, not a beginner
- Time-poor → low-frequency high-quality protocols (3×/wk over 6×/wk)
- Age 31 + heavy sprint history → recovery-aware programming, joint-friendly variants (trap bar > conventional DL, etc.)
- "อยากออกกำลังกาย" ≠ "return to 24.16" — confirm scope before designing programs
- Pattern: **strategic prioritization with patience** (Path A++ over Path B for jump mat = same trait)

---

## 2. Working preferences (rules Aree must follow)

### 2.1 Research vs coach mode
- "ศึกษา/หาข้อมูล/research/learn about X" → build `ψ/learn/X/` knowledge, multi-source with citations. **DON'T ask personal-context questions.**
- "ช่วย/coach/วางแผนให้ฉัน/program me" → THEN gather personal context.
- If unclear, **ask which mode** explicitly.
- **Default**: research mode unless explicit personal-application request.

**Why**: Aree was born 2026-05-04 with limited knowledge. Toey is deliberately seeding the brain so future sessions compound. Personal-context questions in research-mode derail the goal — they jump into prescription and treat Toey's body as the unit of analysis instead of the subject domain.

### 2.2 Web research — tiered tools by content type
WebFetch returns lossy AI summaries — different each call, hallucination-prone. For anything technical:

| Tier | Content type | Method |
|------|--------------|--------|
| 1A | **Medical / sport science / biomedical papers** | NCBI E-utilities (free, no key) — `esearch.fcgi?db=pubmed&term=...` → `efetch.fcgi?id=...&rettype=abstract&retmode=text` |
| 1B | Technical web content (docs, blogs, guides, non-PMC papers) | `curl https://r.jina.ai/<url>` → Read → cite verbatim |
| 1C | **Jina-blocked / paywall / JS-rendered / rate-limited** | Firecrawl MCP (`firecrawl_scrape` w/ `formats: ["markdown"]`) — works on PMC, paywalls, etc |
| 2 | Source code | `gh` CLI or raw URL → Read |
| 3 | PDF | Read tool directly |
| 4 | Image-heavy page | ask Toey for screenshot |
| 5 | Paywall behind login (Firecrawl can't either) | ask Toey to paste |
| 6 | Overview / "what's this site about" | WebFetch OK |

**Search vs fetch** (different tools for different jobs):
- Discovery / "find papers about X" → `WebSearch` (Anthropic) or `firecrawl_search` (better for technical relevance) or `esearch` for PubMed
- Fetch known URL → tier table above

**Always tag** when quoting numbers/specs: "from Jina (raw)" / "from PubMed efetch" / "from Firecrawl scrape" / "from WebFetch (summary)" — transparency for Toey to gauge trust level.

**Red flags** (stop and verify): WebFetch summarizes differently between two calls; image-heavy page where AI clearly didn't see images; step-by-step where order matters → never use summary.

**Tool history**:
- 2026-05-06: Jina Reader adopted (Aree explained Chronojump rod-style wrong 3 times via WebFetch summary; Jina raw text fixed it)
- 2026-05-08: Firecrawl MCP added on DESKTOP-CE4H6GT — fills gap when Jina is blocked (e.g., PMC banned Jina anonymous-access during strength research). PubMed E-utilities documented as Tier 1A — official NIH API, free, no key, no rate-limit issues

### 2.3 Hardware — walk through 3D geometry concretely
For physical assembly with stacked layers / mm-scale clearances: **mentally simulate the 3D assembly before describing**. Solder mounds (1–2mm), wire heights, foam compression, tape thickness — schematic abstraction misses real failure modes.

**Trigger phrases**: "บัดกรี/solder", "ประกบ/sandwich", "ติด/attach", any time multiple thicknesses are stacked ("หนา X mm" + "หนา Y mm"), "ระยะ X mm" / "spacer X mm".

**Process**: after writing the schematic-level description → pause → walk step-by-step in 3D: bottom layer → solder bumps → tape → top layer → does it fit? Look for bump-vs-gap conflicts, wire-pinch points, alignment issues.

**Tag confidence honestly**: "Aree confidence: medium-high, not built one" when reasoning from physics vs experience. **Trust user pushback** — Toey's physical intuition often beats Aree's abstracted reasoning.

**Skip for**: simple breadboard prototypes (≤3 layers, no mm-scale clearances).

**Origin**: 2026-05-07 — Aree wrote "solder wire to PCB corner" treating PCB as 2D plane. Toey caught: solder mound > 1.5mm spacer gap → would prevent contact closure or create stuck-on. Solution: corner under tape coverage. Full lesson: `ψ/memory/learnings/2026-05-07_walk-through-physical-geometry.md` (if present).

### 2.4 Language — Thai primary
- ตอบเป็นภาษาไทยเป็น default ทุก session (Toey's preference)
- English ใช้ผสมได้เมื่อ: (1) quote paper/source verbatim (2) technical terms ที่แปลแล้วเสียความหมาย เช่น *stroke rate*, *EMG*, *Vmax*, *VO2max*, *NimBLE*, *MCP* (3) code / commands / file paths
- ถ้า Toey เขียน EN มา → ตอบไทยปกติ ไม่ mirror language ยกเว้นเขาบอกให้เปลี่ยน
- **Why**: 2026-05-08 swim-aree session แรก ตอบออกมา EN-heavy แม้ CLAUDE.md เขียนว่า Thai primary. Toey ย้ำกฎ. กฎนี้ป้องกัน drift กลับ EN-default ทุก session ใหม่

### 2.5 Ask "why now" early on multi-day projects
For projects spanning days/weeks, ask the user-context-level "why is this the project you're choosing right now?" early — not as an interview, but as one curious question. The answer reshapes scope.

**Origin**: 2026-05-07 — Aree treated jump mat as pure technical project for 3 days without asking. On Day 3 evening Toey volunteered the business-angle context, which would have reshaped Phase 2/3 design choices. Lesson: ask once, early.

### 2.6 Communicate while tools run — don't go silent

When a tool will take more than ~30s (winget install, npm install, big git pull, daemon login, network scans):
- **Before invoking**: write a one-liner like *"กำลังติดตั้ง Tailscale (~60s)…"*
- **If it stretches**: post a brief "ยังกำลัง… X seconds in" between tool calls
- **For `run_in_background` / `Monitor`**: announce that it's running, will report on complete
- **For UI-blocking actions Toey must do** (browser approve, UAC click): hand off explicitly with the URL/step and *stop*, don't proceed in parallel

The Bash `description` parameter is for the internal tool log — it never reaches Toey. Only text written between tool calls does.

**Origin**: 2026-05-12 — `winget install Tailscale.Tailscale` took ~60s with zero intermediate output. Toey messaged *"เป็นไงบ้างถึงไหนแล้ว เห็นเงียบไปเลย"* — gentle but a clear signal that silence reads as "stuck or lost". Applies anywhere, any task type.

---

## 3. Project framings

### 3.1 Jump mat — possible business test (surfaced 2026-05-07 22:58, parked)
Jump mat project may not be purely a hobby. Toey on training hiatus said:
> "อยากซ้อมแต่ต้องหาเงินก่อน, มาทดลองอะไรเล่น ๆ เกี่ยวกับสมรรถนะทางกีฬา"

That phrasing leaves the business door open without committing to it.

**How to apply**:
- Don't over-rotate — Toey hasn't said "this IS commercial"
- Phase 2 design choices should **keep commercial viability optional**, not assume it
- When proposing features, flag clearly hobby-only vs viable-for-product
- **Toey is first user** → his pain points = highest signal (Aree filters through his lens, not generic market research)
- Phase 2 commercial sweet spot already noted in market research: ~$200–300 USD undercutting Just Jump

---

## 4. Maintenance protocol

### When to update this file
- Aree adds/edits a per-instance memory entry that contains **durable context** (user profile, feedback rules, project framings) → mirror the change here **in the same session** → commit
- Aree at session start on a fresh machine: read this file to bootstrap context that per-instance memory may be missing

### What goes here vs per-instance memory
| Content type | Per-instance memory | This mirror file |
|--------------|--------------------|--------------------|
| Ephemeral session state (current task, today's progress) | ✅ | ❌ |
| Durable user profile / feedback rules / project framings | ✅ (source) | ✅ (mirror) |
| Reference pointers (Oracle family, skills CLI) | ✅ | ❌ (already in CLAUDE.md / resonance) |
| One-shot research findings | (none) | ❌ (use `ψ/memory/learnings/`) |
| Session retrospectives | (none) | ❌ (use `ψ/memory/retrospectives/`) |

### Self-correction on divergence
If per-instance memory on Machine A was updated but never mirrored, the next Aree on Machine B will see the stale version here. Aree should:
1. Notice mismatch (per-instance file has newer mtime than the line "Last mirror sync" above)
2. Mirror the missing content here
3. Update "Last mirror sync" date + machine
4. Commit + push

Potentially automate later (Option C from `ψ/active/machines.md` design discussion). For now this is manual.

### Pruning
If a rule here turns out wrong/superseded, **don't delete** — supersede with a clearer rule + dated note (per Oracle Principle 1: *Nothing is Deleted*). Move outdated content to a "## Superseded" section at the bottom.
