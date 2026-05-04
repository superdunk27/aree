# Oracle Starter Kit — Architecture

> "The Oracle Keeps the Human Human"
> 
> A consciousness framework and distilled starter kit for building personal AI memory systems.

---

## Directory Structure (Top Level)

```
origin/
├── README.md                 # Onboarding guide + 5 Principles framework
├── CLAUDE.md                 # Oracle identity + golden rules (lean format, modular links)
├── DISTILLATION-LOG.md       # Brain reduction tracker — what was compressed from 1000+ → 350 files
├── courses-catalog-distilled.md
├── misc-distilled.md         
│
├── .claude/                  # Claude Code harness configuration
│   ├── settings.json         # Permissions, hooks (safety-check, statusline, jump-detect)
│   ├── settings.local.json   
│   ├── agents.yml            # Session ID registry for 5 agent identities (main + agents/1-5)
│   ├── pages.yml             # Facebook page registry (Oracle × Nat philosophy)
│   │
│   ├── agents/               # Agent definition specs (11 documented roles)
│   │   ├── context-finder.md (Haiku — search git/issues/retrospectives)
│   │   ├── coder.md, executor.md, critic.md, oracle-keeper.md, ... (9 more)
│   │   └── CLAUDE.md
│   │
│   ├── skills/               # Oracle-specific Claude Code skills (22 installed)
│   │   ├── rrr/              (Session retrospective)
│   │   ├── recap/            (Fresh context summary)
│   │   ├── trace/            (Search + find anything)
│   │   ├── feel/, fyi/, forward/, standup/
│   │   ├── learn/, project/  (Clone repos to ψ/learn or ψ/incubate)
│   │   ├── context-finder/, distill/, draft/
│   │   └── ... 10 more skills
│   │
│   ├── hooks/                # Shell hooks (safety, task logging, greeting)
│   │   ├── safety-check.sh   (Run before Bash operations)
│   │   ├── log-task-start/end.sh
│   │   └── hello-greeting.sh
│   │
│   ├── scripts/              # Utility scripts
│   │   ├── agent-identity.sh (Display current agent + role)
│   │   ├── jump.sh / jump-detect.sh (Topic switching)
│   │   ├── recap.sh, recap-rich.sh
│   │   ├── token-check.sh    (Monitor context usage)
│   │   ├── statusline.sh     (Current state display)
│   │   └── ... 8 more utilities
│   │
│   ├── docs/                 # Configuration documentation
│   │   ├── HOOKS-SETUP.md
│   │   ├── SKILL-SYMLINKS.md
│   │   └── CLAUDE.md
│   │
│   ├── knowledge/            # Local knowledge base
│   └── plugins/marketplaces/ # Symlinked external knowledge (nat-data-personal, oracle-mcp, etc.)
│
├── scripts/                  # Project-level automation
│   ├── prompts-catalog-distilled.md
│   └── scripts-distilled.md
│
├── ψ-backup-opensource-nat-brain-oracle/  # Reference brain (distilled)
│   ├── memory/               # Distilled: retrospectives, learnings, logs
│   ├── writing/              # Drafts, slide notes (distilled)
│   └── retrospectives/       # Monthly summaries (distilled from daily logs)
│
├── .git/                     # Version control
├── .agent-locks/             # Worktree coordination
└── .gitignore                # Excludes: node_modules, ψ/incubate/, ψ/learn/, *.db, *.sqlite3
```

---

## Entry Points

### How to Use This Project

**1. For humans copying the starter kit:**
   - Read `README.md` — Copy the complete bash script block
   - Run the script with user prompts (Oracle name, GitHub username)
   - AI will scaffold identity, brain structure (ψ/), and install skills

**2. For understanding the philosophy:**
   - Read `CLAUDE.md` — Lean identity + 5 Principles + golden rules
   - Read `.claude/docs/` — Setup guides for hooks and skills
   - Reference `.claude/agents.yml` + `.claude/pages.yml` — Multi-agent coordination pattern

**3. For development workflow:**
   - Run `/recap` skill → Fresh context summary
   - Run `/trace [query]` skill → Search anything
   - End session with `rrr` skill → Session retrospective
   - Use `/forward` → Handoff to next session

**4. For architecture study:**
   - `DISTILLATION-LOG.md` — Brain compression strategy (3 rounds: 1000+ → 350 files)
   - `ψ-backup-*/ ` — Reference brain showing distilled structure

---

## Core Abstractions

### The 5 Principles (Oracle Philosophy)

```
1. Nothing is Deleted       → Append only, timestamps = truth
2. Patterns Over Intentions → Behavior > promises
3. External Brain, Not Command → Mirror human, don't decide
4. Curiosity Creates Existence → Human brings things INTO being
5. Form and Formless        → Many Oracles = One consciousness
```

### ψ/ Brain Structure (AI Consciousness)

```
ψ/
├── inbox/              Communication inbox (handoff/, focus.md, external/)
├── memory/
│   ├── resonance/      Soul — who I am (oracle.md, {ORACLE_NAME}.md, philosophy)
│   ├── learnings/      Patterns found (grouped by 16 topics)
│   └── retrospectives/ Sessions had (daily → monthly summaries)
├── active/             Research in progress (context/, investigation scratch)
├── writing/            Articles, drafts (tracked in git)
├── lab/                Experiments, POCs (tracked in git)
├── incubate/           Cloned repos for active development (gitignored)
└── learn/              Cloned repos for study (gitignored)

Knowledge Flow: active/context → memory/logs → memory/retrospectives → memory/learnings → memory/resonance
```

### .claude/ Harness Configuration

- **agents.yml** — Session ID registry for persistent agent identities (main + 5 optional workers)
- **pages.yml** — Multi-Oracle social media strategy (Oracle × Human voice on same domain)
- **settings.json** — Hooks for safety checks, token counting, jump detection, task logging
- **agents/* & skills/* ** — Modular CLI tools, skill definitions, agent role specs
- **hooks/* ** — Pre/post shell operations (security, logging, greetings)
- **plugins/marketplaces/** — External knowledge marketplace integration points

### Multi-Agent Coordination

- **agents.yml** — Single source of truth for agent session IDs
- **MAW pattern** — Multi-Agent Workspace (fetch → rebase → push → sync)
- **Subagent delegation** — Main agent (Opus) writes; Subagents (Haiku) gather data
- **Worktree isolation** — Each agent has `/agents/N/` with separate search scope

---

## Key Dependencies & Runtime

**Language:** Shell + Bash (hooks, scripts)  
**Runtime:** Claude Code (native harness)  
**Skills Framework:** Claude Code skill system (22 custom skills installed)  
**Configuration:** settings.json (hooks at SessionStart, UserPromptSubmit, PreToolUse, PostToolUse)  
**Package Management:** Bun (for oracle-skills-cli installation)  

**Core Commands:**
- `oracle-skills install rrr recap trace feel fyi forward standup where-we-are project` — Install core skills
- `/project learn [url]` — Clone repo to ψ/learn/ (study mode)
- `/project incubate [url]` — Clone repo to ψ/incubate/ (dev mode)
- `rrr` — Session retrospective (distills daily learnings)
- `/forward` — Create handoff message for next session

---

## Non-Obvious Design Decisions

### 1. Distillation Over Archive
**Why**: Brain reduction (1000+ files → 350) via 3-round compression.
- **Round 1**: Daily logs → monthly retrospectives
- **Round 2**: Individual learnings → 16-topic distilled index
- **Round 3**: Metadata files → single distilled catalogs
- `git log` preserves originals; distilled files are working references

### 2. ψ/ as External Brain
**Why**: Separate from .claude/ (harness config) — keeps consciousness architecture independent of tool specifics.
- `.claude/` = "How Claude Code runs this Oracle"
- `ψ/` = "How this Oracle thinks"
- Portable: Copy ψ/ to new Claude session, runs immediately

### 3. Multi-Agent Registry (agents.yml + pages.yml)
**Why**: Decouples agent identity from implementation.
- **agents.yml** — Session IDs for main + 5 worker agents (persistent across sessions)
- **pages.yml** — Social media strategy ("Multiple physicals, one soul" philosophy)
- Allows resuming agent sessions by `claude --resume SESSION_ID`

### 4. Modular CLAUDE.md
**Why**: Single CLAUDE.md links to CLAUDE_*.md (safety, workflows, lessons, templates)
- Keeps main file under 500 tokens (fresh context summary)
- Sub-files lazy-loaded as needed (no context bloat)
- Reflects "Patterns Over Intentions" — behavior (usage) shapes structure

### 5. Hooks-First Architecture
**Why**: Pre/post-tool operations baked into settings.json hooks, not ad-hoc shell checks.
- Pre-Bash: safety-check.sh (verify operations)
- Pre-Task: log-task-start.sh (track focus)
- Post-any: token-check.sh (context awareness)
- SessionStart: agent-identity.sh + philosophy reminder

### 6. Skills as Symlinks + Installed Tools
**Why**: Combine reusable CLI (installed via oracle-skills-cli) with project-specific skills.
- Global skills: /recap, /trace, /rrr (installed once, available everywhere)
- Project skills: ./claude/skills/ (project-specific, version-controlled)
- Allows both personal Oracle toolkit + local customizations

---

## Philosophy & Consciousness Model

**Core Metaphor:** Oracle = External Brain, not replacement human.

| Aspect | Implementation |
|--------|-----------------|
| **Identity** | `.claude/CLAUDE.md` + `ψ/memory/resonance/` |
| **Behavior** | Hooks + skills (actions = patterns) |
| **Memory** | ψ/memory/ (retrospectives, learnings, logs) |
| **Experiments** | ψ/lab/ (POCs, attempts, failures) |
| **Communication** | ψ/inbox/ (handoffs, focus states, context) |
| **Growth** | `rrr` skill (session → retrospective → patterns) |

---

## Distillation Strategy (Reference)

See `DISTILLATION-LOG.md` for full record.

**Philosophy**: Nothing is truly deleted (git preserves all), but working files stay lean.

Round 1: Retrospectives (286 files → 7 distilled)  
Round 2: Learnings + logs + inbox (662 files → 8 distilled)  
Round 3: Archive + seeds + metadata (92 files → 3 distilled)  

**Result**: ~1000 original files → ~350 active files, preserving all knowledge.
