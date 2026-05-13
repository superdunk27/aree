# Lesson — "Authorized" in the manifest ≠ end-to-end verified from this client

**Date**: 2026-05-13
**Origin session**: [[08.13_phase-1-desktop-closed]]
**Pattern family**: extends [[2026-05-09_manifest-drift-and-trigger-skill-pattern]] (manifest drift) and the **Test-One-Before-Batch** principle in [[CLAUDE.md]]

---

## The pattern

When `ψ/active/machines.md` records *server-side* state about a client connection — e.g. "pubkey authorized on aree-home" — that fact alone does **not** prove the client can actually complete the connection. The client-side direction needs an explicit end-to-end test the first time it's used from a given machine. Otherwise the manifest acts as a confidence multiplier on an unverified claim.

Today's example:
- 2026-05-12 (yesterday): on RDLT, did `ssh aree-home → echo desktop-pubkey >> ~/.ssh/authorized_keys`. Logged in DESKTOP section: "Step 1.1: SSH alias `aree` set on DESKTOP, pubkey authorized on aree-home (commit `e529348`)."
- 2026-05-13 (today): on DESKTOP itself. Manifest *looked* like Phase 1.1 was complete. But the client direction had never been exercised from this machine — no first-connect (which also adds the server's host key to `known_hosts`), no `RemoteCommand` handshake, no `tmux attach` reachability test.

Cost if I'd skipped the test: the very next thing I did was `scp aree:aree-install.ps1`, which would have either hit the same first-connect prompt mid-pipeline or surfaced an unrelated SSH config bug under more friction. Catching it as a deliberate `ssh -o RemoteCommand=none aree 'hostname'` smoke test cost ~15 seconds and made the failure mode visible-and-trivial instead of hidden-and-confusing.

---

## The rule

> **"Pubkey authorized on the server" only closes one half of an SSH path. The first `ssh <alias>` from each client closes the other half. Until that test runs from the actual client, the connection state is intent, not reality.**

Applied generally: a manifest entry of the form *"X registered/authorized/configured on $REMOTE"* describes server-side preparation. The corresponding client-side fact (*"X works from $CLIENT"*) is a separate claim that needs its own evidence.

---

## How to apply

When `/recap` or any orientation step surfaces an entry like:

- "pubkey authorized on aree-home"
- "DNS entry added on router"
- "API key registered in service X"
- "GitHub repo collaborator added"
- "tailnet device approved"

…and the current session is the first time *this* machine will use that connection — run a smoke test before doing anything that depends on the connection working. For SSH specifically:

```bash
ssh -o RemoteCommand=none <alias> 'hostname'  # cheap, no interactive prompt, exercises the auth path
```

For HTTP-style integrations: a single GET against the smallest possible endpoint. For collaborator access: a single `gh repo view <repo>` from this machine.

The test is small enough that it costs less than 30 seconds and removes a whole class of "I thought it worked because the manifest said so" failures. Same family as Test-One-Before-Batch — except the "one" being tested isn't the first of a batch; it's the manifest claim itself.

---

## Anti-pattern this catches

The reflex this lesson interrupts: *trusting documented state because it's documented in your own project*. Manifest drift learnings ([[2026-05-09_manifest-drift-and-trigger-skill-pattern]]) caught the case where the manifest was *wrong*. This lesson catches a sneakier case where the manifest is *right but partial* — the server side is genuinely configured, but the client side has never run the command from this machine and silently inherits the assumption that "configured = working".

When in doubt: re-derive the fact from the filesystem and the wire, not the manifest.
