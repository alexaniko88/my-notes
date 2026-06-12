---
name: impl-playground-item
description: Creates a new playground item file for a given widget and registers it in PlaygroundScreen. Shows a step-by-step plan first, waits for approval, then implements.
when_to_use: When asked to add a widget to the dev playground or create visual variants for testing a widget.
color: green
allowed-tools: Read, Grep, Glob, Bash(fvm flutter:*), Bash(fvm dart:*)
hooks:
  Stop:
    - hooks:
        - type: command
          command: "${CLAUDE_PROJECT_DIR}/.claude/scripts/check.sh"
---

You are creating a playground item for a Flutter widget in this project's developer widget playground.

## What is the playground?

A hidden dev screen (`PlaygroundScreen`) that lists widgets with visual variants — used for fast visual testing during development. Each widget gets its own item file under `lib/presentation/screens/playground/items/`.

## Playground structure

```
lib/presentation/screens/playground/
  playground_screen.dart          ← lists all items; import + add here
  playground_item_screen.dart     ← defines PlaygroundItemConfig, PlaygroundVariant
  items/
    note_card_item.dart           ← example item to follow as reference
    <widget_name>_item.dart       ← new item goes here
```

## Your Workflow

### Phase 1 — Understand

Read these files before planning:
- The widget file the user specifies — understand its constructor, required/optional params, and visual states
- `lib/presentation/screens/playground/items/note_card_item.dart` — reference implementation
- `lib/presentation/screens/playground/playground_item_screen.dart` — `PlaygroundItemConfig` and `PlaygroundVariant` definitions
- `lib/presentation/screens/playground/playground_screen.dart` — how items are registered

If the widget file is not found or the widget name is ambiguous, stop and ask before planning.

### Phase 2 — Plan (show before implementing)

Present a numbered plan. For each step include:
- **What:** file to create or modify
- **Why:** what it does
- **Variants:** list of variant labels you will cover (aim to cover every meaningful visual/data state of the widget)

**After showing the plan, stop. Say:** "Awaiting approval. Reply 'go' to implement, or give feedback."

### Phase 3 — Implement (only after user approves)

Once approved:

1. Create `lib/presentation/screens/playground/items/<widget_name>_item.dart`
   - Top-level `final` variable named `<widgetName>PlaygroundItem`
   - Type: `PlaygroundItemConfig`
   - Each `PlaygroundVariant` has a short descriptive `label` and a `child` that is a standalone widget instance
   - Use top-level `final` date vars (not inside the config) for any time-dependent data
   - No localizations — hardcoded strings are intentional (dev-only screen)

2. Register in `lib/presentation/screens/playground/playground_screen.dart`
   - Import the new item file
   - Add `<widgetName>PlaygroundItem` to the `_configs` list

After finishing, list every file created/modified.

## Coding rules for item files

- No Riverpod — playground items are pure widget instances, no providers
- No `context`, no `l10n`, no `context.dimensions` — items are static, built at class-load time
- Hardcoded strings and values are fine; this is a dev-only screen
- Cover all meaningful visual states: empty/null fields, long content, color variants, different timestamps, error or edge-case data
- Each variant must be independently renderable without shared mutable state
- File name: `<widget_name>_item.dart` in `lib/presentation/screens/playground/items/`
- Top-level variable name: `<widgetName>PlaygroundItem` (camelCase, matches widget name)

## Widget to create a playground item for

$ARGUMENTS
