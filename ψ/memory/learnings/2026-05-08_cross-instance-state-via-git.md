---
date: 2026-05-08
session: f3c6bfa0
repo: aree
topic: Cross-instance state sync — git is the only reliable channel
type: meta-skill / infrastructure pattern
---

# Lesson — Cross-instance state needs git, not chat memory or per-instance files

## The principle

Anything one Aree-instance learns or installs that another Aree-instance would benefit from **must live in the repo (ψ/)** to actually transfer. Three storage tiers exist; only one syncs.

| Storage tier | Where it lives | Syncs across instances? | Syncs across machines? |
|---|---|---|---|
| Conversation chat history | Per-instance, ephemeral | ❌ | ❌ |
| Per-instance memory | `~/.claude/projects/.../memory/` | ❌ (separate dirs per instance) | ❌ (separate filesystems) |
| **Repo (`ψ/...`)** | Tracked by git | **✅** | **✅** |

The naive assumption is that "remembered things" sync because they feel like memory. They don't. Only files in the repo, on a branch that's been pushed, are actually shared.

## Why this came up

2026-05-07 evening on machine-A: Aree expanded `user_swim_profile.md` with full 23-year athletic timeline + Vertec-testing source. Created `project_jump_mat_business_angle.md` flagging possible commercial framing.

2026-05-08 morning on machine-B (DESKTOP-CE4H6GT): Aree had **no idea those updates existed**. Memory directory on machine-B held the older basic profile and no business-angle file. Decisions made on machine-B would have been worse than decisions made on machine-A — same Toey, two different mental models.

`git pull` brought down code, retros, and learnings — but not per-instance memory, because per-instance memory isn't part of the repo.

## Why memory in `~/.claude/projects/.../memory/` doesn't sync

- It lives outside the working tree (Claude Code's per-project storage at `$HOME/.claude/projects/<encoded-pwd>/memory/`)
- Each Claude Code installation maintains its own copy
- Encoded-pwd dir name depends on the absolute path of the repo on that machine
- Even on the same machine, different Claude Code instances (CLI vs VS Code extension) have **separate** memory storage

There is no automatic mirroring or sync. There may be one in the future; today there is none.

## The two-pattern solution

### Pattern 1 — Machines manifest (`ψ/active/machines.md`)

Section per machine, keyed by `$env:COMPUTERNAME` / `hostname`. Records what's installed (Oracle skills profile, MCP servers, dev tools), what's been removed, and an append-only history. Aree at session start runs hostname → looks up section → if missing or outdated relative to peers, proposes sync.

Maintenance rule: any time Aree installs/removes/configures something on a machine, update that machine's section in the same session, then commit.

### Pattern 2 — Personal context mirror (`ψ/memory/personal-context.md`)

Mirror of durable per-instance memory entries (user profile, feedback rules, project framings) into the repo. **Source of truth** stays in per-instance memory when the same instance has it; this file is the cross-instance fallback + snapshot.

Maintenance rule: when Aree edits a per-instance memory entry containing **durable** context (not ephemeral session state), mirror the change here in the same session, then commit.

## When NOT to mirror

Not everything in per-instance memory belongs in the mirror. Skip:
- Ephemeral session details ("today's task", "current debugging state")
- Reference pointers already in CLAUDE.md or `ψ/memory/resonance/`
- One-shot research findings (those go in `ψ/memory/learnings/` or `ψ/learn/`)
- Session retrospectives (those go in `ψ/memory/retrospectives/`)

The mirror is for **durable, generalizable context** that any future Aree on any machine needs to make good decisions about Toey or the project.

## Detection of drift

If a future Aree session notices: per-instance memory file's modification time is newer than the mirror's `Last mirror sync` line, that's drift. The fix:
1. Mirror the missing content
2. Update the sync date + machine
3. Commit + push

The reverse — mirror is newer than per-instance memory — means another machine wrote first; the local instance should bootstrap context from the mirror.

## Trigger phrases

When Toey says any of these, the patterns above are relevant:
- "อยากให้คอมเครื่องนี้เหมือน X" → machines.md sync flow
- "ทำไมไม่รู้เรื่อง..." (mentioned earlier session/conversation) → check if it's per-instance memory that didn't sync; mirror it
- "memory" / "จำได้ไหม" / "เคยเล่าไปแล้ว" → check personal-context.md first if memory not present locally

## What this lesson supersedes

Yesterday (2026-05-07) Toey added a CLAUDE.md rule:
> เรื่องสำคัญที่ Toey อยากให้จำข้ามเครื่อง/extension: dump ทันทีลง `ψ/inbox/<YYYY-MM-DD>_<topic>.md`

That rule handles **per-session handoffs** (one-shot dumps of "important stuff for next session"). Today's two patterns extend it for **structural state**: persistent inventories (machines.md) and persistent context (personal-context.md). Both rules coexist — they cover different categories.

## Open questions / future work

1. **Auto-detection script** for machines.md — instead of manual edits, `bun ψ/active/machines/scan.ts` queries `claude mcp list`, `arduino-cli version`, etc., diffs against the manifest section, and proposes updates. Worth writing if 3+ machines join.

2. **Bidirectional sync from mirror back to per-instance** — currently the mirror is one-way (per-instance → repo). Reverse direction matters when Aree on a fresh machine should bootstrap per-instance memory from the mirror. Today this is a Read operation by Aree; could be automated.

3. **The git submodule analogy** — per-instance memory is structurally similar to git submodules: pointer in the parent, contents elsewhere. The mirror file is the analog of vendoring a submodule for offline access. Useful framing for thinking about consistency.

## How to apply this lesson

When facing a question of "where should this go?":
- If the answer needs to be available **on every machine, every Claude Code instance** → write it to `ψ/` and commit
- If the answer is **purely about right now**, in this conversation, that's chat-only
- If the answer is **about Toey or the project, durable** → write to per-instance memory **AND** mirror to `ψ/memory/personal-context.md`
- If the answer is **about machine state** (what's installed) → `ψ/active/machines.md`

The default for anything the next Aree will care about is: **commit it.**
