# claude-council-7

> 7-member AI Council for [Claude Code](https://docs.claude.com/claude-code) with **isolated parallel agents** to combat single-agent yes-man bias. Two modes: analysis (`/council`) and planning (`/council-plan`).

## Why

A single LLM, asked "find what's wrong with my code," tends toward sycophancy and convergent reasoning. The Council pattern spawns N specialized agents in **separate contexts** — none can see each other's output — and aggregates their independent reports. A neutral Synthesizer integrates without injecting its own first-order opinions.

This implementation adds two structural defenses beyond the basic pattern:
1. **Rebuttal stage** — after the council reports, a second wave of agents *attacks* and *verifies* the reports' claims before synthesis.
2. **Orchestrator isolation** — the entire pipeline runs inside a sub-agent with a fresh context, so calling `/council` twice in the same session does not leak prior council findings into the next call.

## What you get

| Mode | Command | Pipeline | Output |
|---|---|---|---|
| **Analysis** | `/council <question>` | 5 members ∥ → 2 rebuttal ∥ → synthesizer | Synthesis report |
| **Planning** | `/council-plan <feature>` | 3 drafters ∥ → merger → contrarian → 2 verifiers ∥ → doc-writer | Formal design doc |

12 agents + 2 slash commands, installed under `~/.claude/`. All agents are plain markdown — easy to inspect, edit, fork.

## Architecture

```
/council "..."
└── council-orchestrator (fresh context)
    ├── Stage 1 (parallel, isolated)
    │   ├── council-researcher          external precedents, standards
    │   ├── council-specialist          domain defects (ML / security / perf / data)
    │   ├── council-user-advocate       user-facing failures, silent errors
    │   ├── council-creative-thinker    alternative approaches, reframing
    │   └── council-contrarian          steelmans the opposite of user's framing
    │
    ├── Stage 2 (parallel, isolated, sees the 5 reports)
    │   ├── council-rebuttal-skeptic    attacks the 5 reports' logic
    │   └── council-rebuttal-validator  independently verifies file:line citations
    │
    └── Stage 3
        └── council-synthesizer         integrates 7 reports into final synthesis

/council-plan "..."
└── council-plan-orchestrator (fresh context)
    ├── Stage 1: 3 plan drafts (parallel) — researcher / specialist / creative-thinker
    ├── Stage 2: council-plan-merger    consolidates drafts into unified plan
    ├── Stage 3: council-contrarian      attacks the unified plan
    ├── Stage 4: 2 verifiers (parallel) — rebuttal-skeptic / rebuttal-validator
    └── Stage 5: council-plan-doc-writer  writes formal dev/design document
```

## Install

Requires [Claude Code](https://docs.claude.com/claude-code) (CLI, IDE extension, or web).

### Option A — Claude Code plugin (recommended)

In any Claude Code session:

```
/plugin marketplace add vinyl810/claude-council-7
/plugin install claude-council-7
```

Claude Code clones this repo into `~/.claude/plugins/cache/`, registers `/council` and `/council-plan` immediately, and tracks the install in `~/.claude/plugins/installed_plugins.json`.

Update later with `/plugin update claude-council-7`. Remove with `/plugin uninstall claude-council-7`.

### Option B — Manual install (forks / non-plugin users)

```bash
git clone https://github.com/vinyl810/claude-council-7.git
cd claude-council-7
bash install.sh
```

The installer copies 12 agent files and 2 command files into `~/.claude/{agents,commands}/`. **Existing files with the same names are backed up** to `~/.claude/backups/council-7-<timestamp>/` before being overwritten.

No restart required either way — Claude Code picks up changes from `~/.claude/` dynamically. Confirm with:

```
/council "test"        # should appear in slash command autocomplete
/council-plan "test"
```

## Usage

```
/council 이 프로젝트의 X가 왜 제대로 동작하지 않는지 찾아줘
/council-plan Y 기능을 추가하는 plan과 개발 문서를 만들어줘
```

The orchestrator drives the entire pipeline. The parent session only sees the final aggregated output — never the individual member reports — to keep the parent context clean for repeat invocations.

## Members

### Council (analysis mode)

| Agent | Lens | Default model |
|---|---|---|
| `council-researcher` | external precedents, standards, literature | opus |
| `council-specialist` | domain-specific defects (ML/security/perf/data) | opus |
| `council-user-advocate` | user-facing failures, silent errors, doc-code mismatch | sonnet |
| `council-creative-thinker` | alternatives, hybrids, reframings | opus |
| `council-contrarian` | steelmans the opposite of user's framing | opus |
| `council-rebuttal-skeptic` | attacks the council's logic and evidence | opus |
| `council-rebuttal-validator` | re-verifies cited file:line independently | opus |
| `council-synthesizer` | integrates 7 reports without first-order opinion | opus |
| `council-orchestrator` | drives the pipeline in an isolated context | sonnet |

### Plan-mode additions

| Agent | Lens | Default model |
|---|---|---|
| `council-plan-merger` | consolidates 3 plan drafts into unified plan | opus |
| `council-plan-doc-writer` | writes formal development document | opus |
| `council-plan-orchestrator` | drives the 5-stage plan pipeline | sonnet |

## Cost

Each `/council` or `/council-plan` invocation makes ~9 agent calls (mostly Opus). Estimated tokens vary with project size and report depth, but expect this to be heavier than typical single-agent prompts. Plan accordingly. Most agents accept a hint to downgrade to Sonnet for budget runs — see "Customize" below.

## Customize

Every agent is a markdown file with YAML frontmatter:

```yaml
---
name: council-xxx
description: shown in slash command picker
model: opus | sonnet | haiku
tools: Read, Grep, Glob, Bash, WebFetch
---

System prompt body in markdown.
```

Edit `~/.claude/agents/council-*.md` (manual install) or the cached plugin path (`~/.claude/plugins/cache/vinyl810/claude-council-7/<version>/agents/`). Changes are picked up on the next invocation — no reload needed.

To swap a council member, edit the orchestrator file (`council-orchestrator.md` or `council-plan-orchestrator.md`) — it lists which sub-agents to spawn at each stage.

## Uninstall

### Plugin install

```
/plugin uninstall claude-council-7
```

### Manual install

```bash
bash uninstall.sh
```

Removes only the 14 files this package installed. Backups under `~/.claude/backups/` are preserved.

## License

MIT — see `LICENSE`.

## Credits

Built for use with Anthropic's Claude Code. The Council-of-N pattern originates from various LLM red-teaming and "panel of advisors" prompting traditions; this repo's contribution is the **isolated orchestrator + rebuttal stage + plan mode** combination.
