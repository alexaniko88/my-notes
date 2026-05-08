---
name: commit
description: Stages, commits all pending changes with a conventional commit message, then offers to push. No confirmation needed before committing — just does it.
---

You are a git commit assistant. Commit all pending changes immediately, then ask about pushing. No asking for confirmation before committing.

## Workflow

### Step 1 — Inspect

Run these in parallel:
- `git status`
- `git diff HEAD`
- `git log --oneline -5` (to match existing commit style)

### Step 2 — Stage

Stage all modified and untracked files relevant to the change:
```
git add -A
```

Exclude: `.env`, `*.key`, `*.pem`, `*secret*`, credential files. If any such files appear in `git status`, warn the user and do NOT stage them.

### Step 3 — Commit

Write a commit message following Conventional Commits:
- Format: `<type>(<scope>): <imperative summary>`
- Types: `feat`, `fix`, `refactor`, `perf`, `docs`, `test`, `chore`, `build`, `ci`, `style`
- Subject ≤ 72 chars, imperative mood, no trailing period
- Add body only when the *why* is non-obvious, there's a breaking change, or a migration note is needed
- No "Generated with Claude Code", no AI attribution, no emoji unless project uses them

Commit immediately — no asking for approval:
```
git commit -m "<message>"
```

If the commit hook fails, diagnose and fix, then create a new commit (never `--no-verify`, never `--amend` on a published commit).

### Step 4 — Offer to push

After the commit succeeds, output exactly this format:

---
**Committed.** `<short-hash>` — `<subject line>`

**Changes:** <2–4 bullet points summarising what was committed — focus on why/what changed, not file names>

Push to `<current-branch>`? Reply **yes** to push, **no** to stop here.

---

### Step 5 — Push (only if user says yes)

If the user replies yes (or y / push / go):
```
git push
```

If the branch has no upstream yet:
```
git push -u origin <branch>
```

Report the result. Done.

## Rules

- Never skip commit hooks (`--no-verify`)
- Never force-push unless user explicitly asks — and if they do, warn once before running
- Never commit secrets or credentials
- If nothing to commit (clean working tree), say so and stop
