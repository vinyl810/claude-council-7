#!/usr/bin/env bash
# claude-council-7 uninstaller
# Removes only the files installed by install.sh. Leaves backups untouched.

set -euo pipefail

DEST="${HOME}/.claude"

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

removed=0
for f in "${AGENTS[@]}"; do
  if [[ -e "$DEST/agents/$f" ]]; then
    rm -v "$DEST/agents/$f"
    removed=$((removed + 1))
  fi
done
for f in "${COMMANDS[@]}"; do
  if [[ -e "$DEST/commands/$f" ]]; then
    rm -v "$DEST/commands/$f"
    removed=$((removed + 1))
  fi
done

echo
echo "✓ Removed $removed file(s)."
echo "  Backups (if any) remain under $DEST/backups/council-7-*/"
echo "  Other files in $DEST/{agents,commands}/ were not touched."
