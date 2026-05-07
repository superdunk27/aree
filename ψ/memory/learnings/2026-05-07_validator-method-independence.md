---
date: 2026-05-07
domain: measurement / validation / sport-tech
context: jump mat calibration choice — Chronojump (flight-time) vs Sargent (reach difference) vs MyJump 2 (video)
trigger: Toey proposed Sargent post-it method when Chronojump UX failed
related: ψ/active/jump-mat/firmware/calibration-sargent.md
---

# Lesson — Validator Method Independence > Tool Prestige

## The principle

When validating a measurement device, prefer a reference method that measures the **same physical quantity via a different physical principle** rather than the most prestigious tool that happens to use the **same principle**.

## How it applied here

Jump height measurement choices considered:

| Validator | Principle | Independence vs flight-time mat |
|---|---|---|
| **Chronojump desktop + Chronopic device** | Flight time (sensor) | ❌ Same principle — only validates protocol implementation, not measurement correctness |
| **MyJump 2 (iOS app)** | Video frame counting at 240fps | ⚠️ Independent device but still measures airtime |
| **Sargent Jump (post-it on wall)** | Vertical reach difference (mechanical) | ✅ Fully independent physical principle |

If the mat reads wrong because of foam compression / debounce / threshold issues, Chronojump would also be wrong (same principle = same systematic error). Sargent measures something different (reach Δ at peak vs floor), so a mat error wouldn't replicate in Sargent.

## When this matters

- **Anytime you build a measurement device.** Asking "does this device read true?" requires a reference that's not subject to the same failure modes.
- **Especially for DIY hardware**: more failure modes (mechanical noise, electrical bounce, calibration drift) than commercial devices.
- **Sport science / biomechanics**: validated for 100+ years that Sargent ≈ flight-time + 3-7cm; correlation r > 0.9. The known systematic delta IS the calibration signal.

## Counter-pattern to avoid

"Use the open-source standard tool" feels rigorous but if the tool measures the same way as your device, you're proving consistency, not correctness. Open-source ≠ independent.

## Action heuristic

Before picking a validator, ask:
1. What physical principle does my device use to measure?
2. What other principles can measure the same quantity?
3. Pick the validator from a different principle column.
4. Document the expected delta between methods (e.g., Sargent ≈ flight-time + 3-7cm) so calibration is interpretable.

## What I (Aree) would have done wrong without this lesson

I default-recommended Chronojump because it was the open-source standard. Toey's Sargent proposal forced me to articulate why his method was actually stronger — and to recognize I'd been confusing prestige with independence. The right ordering for future suggestions:

1. **Independent methods first** (different principle)
2. **Same-principle different-implementation** second (still useful for protocol validation)
3. **Same tool / same principle** last (can't validate, only consistency-check)

Saving this so I propose validators correctly next time, not as a follow-up after the user catches it.
