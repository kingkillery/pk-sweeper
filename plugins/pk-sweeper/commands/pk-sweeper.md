---
description: run safe pk-sweeper issue and PR review workflows from any repository
allowed-tools:
  - Bash
  - Read
  - Grep
  - Glob
---

# PK Sweeper

Run `pk-sweeper` from the current repository or from an explicit `--repo owner/repo` target.

Safety rules:
- Prefer non-mutating commands: `plan`, `sweep`, `quick`, `review`, and `linear-pr-reviewer`.
- Do not run `apply-decisions` unless the user explicitly asks to apply decisions, close/comment on issues, or merge PRs.
- Do not pass `--merge-prs` unless the user explicitly asks for PR merges.
- Do not print tokens, environment files, private keys, or GitHub auth internals.
- If the checkout is dirty, report it first. Use `--allow-dirty` only when the user confirms it is intentional.

Preflight:
```bash
git status --short --branch
git remote -v
pk-sweeper --help || pksweeper --help || npx --yes pk-sweeper --help
gh auth status
```

Safe examples:
```bash
pk-sweeper plan
pk-sweeper sweep
pk-sweeper quick --agents 2 --concurrency 1 --batch-size 1 --max-pages 2
pk-sweeper sweep --repo owner/repo
pk-sweeper linear-pr-reviewer --repo owner/repo --pr-url https://github.com/owner/repo/pull/123 --output review.json
```

Report the target repo, command run, output workspace, and blockers.
