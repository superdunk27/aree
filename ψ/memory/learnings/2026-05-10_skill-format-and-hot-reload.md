---
date: 2026-05-10
type: technical / mechanic
sources:
  - retrospective: ψ/memory/retrospectives/2026-05/10/00.25_rdlt-discovery-and-sync-skill-fix.md
  - prior: ψ/memory/learnings/2026-05-09_manifest-drift-and-trigger-skill-pattern.md (the trigger-skill pattern this lesson supplements)
keywords: claude code skills, skill format, SKILL.md, hot reload, .claude/skills, local skill, sync skill
---

# Claude Code skills: format requires `<name>/SKILL.md`, hot-reload works

Two small mechanical facts about how Claude Code loads project-level skills, learned by failing the first one yesterday and verifying the second one today.

## Fact 1 — Format is a directory, not a flat file

A local skill must live at:

```
.claude/skills/<name>/SKILL.md
```

NOT:

```
.claude/skills/<name>.md     ← flat .md is silently ignored
```

The global Oracle skills (`~/.claude/skills/recap/`, `harden/`, `about-oracle/`, …) all use the directory form. The flat-file form looks like it should work — it has the right YAML frontmatter, the right description, the right name — but Claude Code's skill loader doesn't index it. There's no error message; the skill simply doesn't appear in the available-skills list.

This was failure mode #1 for `/sync` yesterday: created as `.claude/skills/sync.md`, never loaded, didn't surface as a slash-command. Toey caught it by noticing the skill wasn't in the available-skills list at session start.

Fix is `git mv .claude/skills/<name>.md .claude/skills/<name>/SKILL.md` (preserves rename history per *Nothing is Deleted*).

### Cheap verification

```powershell
ls .claude/skills/                      # all should be directories, no flat .md
ls .claude/skills/<name>/SKILL.md       # confirms the file exists
```

Or compare filesystem vs the available-skills list in the session prompt — if a `.claude/skills/foo/SKILL.md` exists but `foo` is missing from available-skills, something's wrong.

## Fact 2 — Hot-reload works mid-session

After `git mv` to the correct format, the new skill appeared in the available-skills list **within the same Claude Code session** — no restart needed. Verified today: created the directory at ~23:40, the next system-reminder turn included `sync:` in the available-skills block, and `/sync` triggered correctly.

This means: when iterating on local skills, you don't need to exit and re-enter the session to test. Edit → save → next prompt sees the change.

### Edge case to watch

The hot-reload reads filesystem. If you edit a skill file but Claude Code's session doesn't refresh available-skills before the next user message, the description shown in `<system-reminder>` could be one revision behind. Not observed today (the format change was structural enough that it forced a refresh), but worth keeping in mind for description-only edits.

## Why this matters

A trigger-skill (yesterday's pattern: encode a forgettable rule as an invocable slash-command) only works if the skill actually loads. Format error = skill doesn't exist as far as Claude Code is concerned, even though the file is on disk and the git history says it's done.

This pairs with the manifest-drift lesson: "I committed `sync.md`" was treated as "the skill exists." Filesystem said yes; runtime said no. Verify at the runtime layer (available-skills list), not just the filesystem layer.

## Heuristic

> **Build a skill, then check the next prompt's available-skills list contains it.** If not, the format is wrong (almost always: flat `.md` instead of directory + `SKILL.md`). Cost is two seconds; catches a class of bugs that otherwise costs a session.

## Cross-references

- `.claude/skills/sync/SKILL.md` — the skill this lesson came from
- `ψ/memory/learnings/2026-05-09_manifest-drift-and-trigger-skill-pattern.md` — Part 2 of this discusses the trigger-skill pattern; this is the "make it actually work" complement
- `ψ/active/machines.md` 2026-05-10 history entry — the third manifest-drift catch (hostname), enabled by this skill loading correctly
