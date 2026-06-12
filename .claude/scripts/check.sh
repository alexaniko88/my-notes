#!/bin/bash
# Stop hook for /impl-logic and /impl-ui: refuses to let the skill finish
# while the working tree has Dart changes that fail formatting or analysis.
#
# Exit codes (Claude Code hook contract):
#   0 — clean, allow stop
#   2 — block stop; stderr is fed back to Claude so it fixes the issues

set -u
cd "${CLAUDE_PROJECT_DIR:-$(pwd)}" || exit 0

# Use the FVM-pinned SDK; bare `dart`/`flutter` may resolve to a stale global
# checkout (and shell aliases don't exist in hook shells). Prefer the project
# symlink, then the fvm command, then PATH as a last resort.
if [ -x ".fvm/flutter_sdk/bin/dart" ]; then
  DART=".fvm/flutter_sdk/bin/dart"
  FLUTTER=".fvm/flutter_sdk/bin/flutter"
elif command -v fvm >/dev/null 2>&1; then
  DART="fvm dart"
  FLUTTER="fvm flutter"
else
  DART="dart"
  FLUTTER="flutter"
fi

input=$(cat)

# A previous Stop hook already blocked once this turn — don't loop forever.
if printf '%s' "$input" | grep -q '"stop_hook_active"[[:space:]]*:[[:space:]]*true'; then
  exit 0
fi

# Only run when Dart files were actually touched (skips the planning turn,
# where the skill stops to show a plan without having changed any code).
changed_dart=$( { git diff --name-only HEAD -- '*.dart'; git ls-files --others --exclude-standard -- '*.dart'; } | sort -u )
if [ -z "$changed_dart" ]; then
  exit 0
fi

# Trailing commas + import organization + formatting (mirrors the skill rules).
$DART fix --apply >/dev/null 2>&1
$DART format . >/dev/null 2>&1

analyze_output=$($FLUTTER analyze 2>&1)
analyze_exit=$?
if [ $analyze_exit -ne 0 ]; then
  {
    echo "flutter analyze failed — fix these issues before finishing:"
    echo "$analyze_output"
    echo
    echo "Changed Dart files:"
    echo "$changed_dart"
  } >&2
  exit 2
fi

exit 0
