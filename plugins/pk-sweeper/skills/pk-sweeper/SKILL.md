---
name: pk-sweeper
description: Use the local pk-sweeper CLI from any repository to review GitHub issues, pull requests, or a Linear-created draft PR. Prefer safe report-generating commands and do not apply GitHub decisions unless the user explicitly requests mutation.
---

# PK Sweeper

Use this skill when the user asks to sweep, review, triage, or inspect GitHub issues or pull requests with `pk-sweeper`, `pksweeper`, or a "sweeper" reviewer agent.

## Core Behavior

- Run commands from the target repository checkout unless the user provides `--repo <owner>/<repo>`.
- Prefer `pk-sweeper` when available; fall back to `pksweeper`.
- Treat `sweep`, `quick`, `plan`, `review`, and `linear-pr-reviewer` as safe review/report commands.
- Treat `apply-decisions` as mutating. Only run it after the user explicitly asks to apply, close, comment, or merge.
- Do not pass `--merge-prs` unless the user explicitly asks to merge high-confidence PR decisions.
- Do not print tokens, environment files, private keys, or GitHub auth internals.
- If the target checkout is dirty, report it before running a sweep. Use `--allow-dirty` only when the user confirms the dirty state is intentional.

## Preflight

From the target repo:

```powershell
git status --short --branch
git remote -v
where.exe pk-sweeper
pk-sweeper --help
gh auth status
```

If `pk-sweeper` is not installed globally, use:

```powershell
npx --yes pk-sweeper --help
```

## Safe Commands

Plan candidates without running review shards:

```powershell
pk-sweeper plan
```

Run the normal non-mutating sweep:

```powershell
pk-sweeper sweep
```

Run a bounded quick review:

```powershell
pk-sweeper quick --agents 2 --concurrency 1 --batch-size 1 --max-pages 2
```

Review an explicit repository:

```powershell
pk-sweeper sweep --repo owner/repo
```

Review one draft PR for a Linear/manual-agent callback:

```powershell
pk-sweeper linear-pr-reviewer --repo owner/repo --pr-url https://github.com/owner/repo/pull/123 --output review.json
```

## Output

Default reports are written to a sibling workspace:

```text
../<target-repo>.pksweeper/
```

Typical outputs include `quick-summary.md`, `todo.md`, `plan.md`, `items/<number>.md`, and `artifacts/linear-pr-reviewer/...`.

## Wrapper Script

This plugin includes:

```powershell
plugins\pk-sweeper\scripts\Invoke-PkSweeper.ps1
```

Use it when a global command lookup is unreliable:

```powershell
& .\plugins\pk-sweeper\scripts\Invoke-PkSweeper.ps1 sweep
```

## Report Shape

When reporting back, include:

- Target repo and working directory.
- Command run.
- Whether the command was non-mutating.
- Output workspace path.
- Any blockers, especially missing `gh` auth, missing `pk-sweeper`, dirty checkout, or unavailable GitHub repo.
