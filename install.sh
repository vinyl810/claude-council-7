#!/usr/bin/env bash
# claude-council-7 installer
# Copies agent/command files to ~/.claude/ with backup of existing files.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${HOME}/.claude"
TS="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR="${DEST}/backups/council-7-${TS}"

AGENTS=(
  council-orchestrator.md
  council-researcher.md
  council-specialist.md
  council-user-advocate.md
  council-creative-thinker.md
  council-contrarian.md
  council-rebuttal-skeptic.md
  council-rebuttal-validator.md
  council-synthesizer.md
  council-plan-orchestrator.md
  council-plan-merger.md
  council-plan-doc-writer.md
)

COMMANDS=(
  council.md
  council-plan.md
)

# Sanity: source files exist
for f in "${AGENTS[@]}"; do
  [[ -f "$SCRIPT_DIR/agents/$f" ]] || { echo "ERROR: missing source $SCRIPT_DIR/agents/$f" >&2; exit 1; }
done
for f in "${COMMANDS[@]}"; do
  [[ -f "$SCRIPT_DIR/commands/$f" ]] || { echo "ERROR: missing source $SCRIPT_DIR/commands/$f" >&2; exit 1; }
done

mkdir -p "$DEST/agents" "$DEST/commands"

# Backup any existing managed files
backed_up=0
backup_one() {
  local src="$1"
  local rel="${src#$DEST/}"
  if [[ -e "$src" ]]; then
    mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
    cp -p "$src" "$BACKUP_DIR/$rel"
    backed_up=$((backed_up + 1))
  fi
}

for f in "${AGENTS[@]}";   do backup_one "$DEST/agents/$f";   done
for f in "${COMMANDS[@]}"; do backup_one "$DEST/commands/$f"; done

if [[ $backed_up -gt 0 ]]; then
  echo "→ Backed up $backed_up existing file(s) to: $BACKUP_DIR"
fi

# Install
for f in "${AGENTS[@]}";   do cp -v "$SCRIPT_DIR/agents/$f"   "$DEST/agents/$f";   done
for f in "${COMMANDS[@]}"; do cp -v "$SCRIPT_DIR/commands/$f" "$DEST/commands/$f"; done

cat <<EOF

✓ Installed claude-council-7 to $DEST
  - 12 agents in $DEST/agents/
  - 2 commands in $DEST/commands/

Try it:
  /council "your question"
  /council-plan "your feature/requirement"

Uninstall:
  bash $SCRIPT_DIR/uninstall.sh
EOF
