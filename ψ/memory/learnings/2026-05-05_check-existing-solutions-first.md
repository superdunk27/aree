# Lesson Learned — Always Check Existing Solutions Before DIY Architecture

**Date**: 2026-05-05
**Domain**: project planning / engineering decisions
**Source**: jump mat project (Path 3 → Path A++ pivot)

## The Lesson

**Before recommending a DIY architecture, run a 30-minute existing-solutions check.** The biggest cost-savers come from finding open-source projects that already validated the approach you're about to spend weeks on.

## What Happened

In the jump mat project, I recommended Path 3 (build a force plate from scratch with 4× load cells + HX711 + ESP32 + custom PWA) at 22:00. Estimated 5-week build with significant risk.

At 22:25, Toey asked "ช่วยไปดูคนอื่นหน่อย เผื่อเป็นประโยชน์" — go check what others have built. I should have done this BEFORE recommending Path 3, not after.

The research found Chronojump — an open-source jump testing ecosystem with:
- Open-source ESP32-S3 firmware (`arduino/4Platforms/4Platforms.ino`)
- Open-source desktop app validated r=0.999 vs gold-standard force plate
- GPL-2.0 license (compatible with Toey's eventual commercial intent)

By 23:00 we had pivoted to Path A++ (switch mat + Chronopic emulation), with 1-2 week build time and validation inherited free.

**The exact same finding was discoverable at 21:30**. I just didn't look.

## Why This Matters

| | Without check | With check (front-loaded) |
|---|---|---|
| Architecture pivots | 2 (foam+foil → Path 3 → Path A++) | 1 (foam+foil → Path A++) |
| Cognitive load on Toey | High (3 different "right answers") | Low (one clear answer) |
| Time wasted on Path 3 design discussion | ~30 minutes | 0 |
| Accidentally building inferior thing | Possible if Toey had ordered parts before research | Prevented |

The cost of the check is 30 minutes. The cost of skipping is potentially weeks of building the wrong thing.

## When to Apply

Apply this rule when:
- User mentions a domain Aree doesn't actively work in (jump testing, embedded electronics, sports hardware)
- The plan involves building hardware or hardware-software integration
- The plan involves a "novel" sensor combination — most novel combos already exist as open-source projects
- The user has commercial intent — license/IP issues compound the cost of late discoveries

How to apply:
1. **Before** giving an architecture recommendation, search GitHub + 1-2 forums for the use case
2. Specifically look for: open-source firmware, validated software, BOMs with cost
3. If something exists at >70% of the planned scope: use/adapt it instead of building from scratch
4. Frame to user: "I found X — here's what we can borrow, here's what we'd still build, here's the license implication"

## Caveats

This rule has its own failure mode: "research forever, never build". The 30-minute timebox is essential. If after 30 minutes nothing relevant is found, proceed with greenfield design. Don't hide behind research as a way to defer commitment.

## Related

- `feedback_research_vs_coach_mode.md` — research mode rules
- `project_jump_mat.md` — current project state where this lesson originated
