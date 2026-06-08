# pk-sweeper

`pk-sweeper` is a conservative GitHub issue and pull request maintenance helper.
It reviews open items, writes markdown recommendation reports, and can later
sync review comments or apply high-confidence decisions only when explicitly
requested.

The normal local workflow is safe by default:

```bash
cd path/to/target-repo
pksweeper sweep
```

`sweep` auto-detects the GitHub repository from the current checkout's `origin`
remote, checks both issues and pull requests with balanced selection, and writes
reports without closing, commenting, or merging.

## Install

Requires Node.js 24 or newer, the GitHub CLI (`gh`), and the Codex CLI.

```bash
npm install -g pk-sweeper
```

Or run without installing globally:

```bash
npx pk-sweeper sweep
```

## Commands

```bash
pksweeper sweep
pksweeper plan
pksweeper quick
pksweeper linear-pr-reviewer --pr-url <url>
pksweeper apply-decisions
```

`sweep` is recommended for coding sessions. It runs a preflight before review
work starts and prints:

- resolved GitHub repository
- current working directory
- target checkout directory
- output workspace
- Codex CLI path
- target checkout clean/dirty status

If a required check fails, it stops before doing review work.

## Target Repository Resolution

PK Sweeper resolves the target repository in this order:

1. `--repo <owner>/<repo>`
2. `PKSWEEPER_TARGET_REPO`
3. `GH_REPO`
4. the current checkout's GitHub `origin` remote
5. `sweeper.config.json` `targetRepo`

For local use, prefer running from the target repo checkout and leave
`targetRepo` as `null`. Placeholder values such as `owner/repo` are ignored and
reported.

Example config:

```json
{
  "targetRepo": null,
  "docsUrl": null,
  "pluginEcosystem": null,
  "extraStopWords": [],
  "protectedLabels": ["security", "beta-blocker", "release-blocker", "maintainer"]
}
```

## Output

By default, reports are written to a sibling workspace:

```text
../<target-repo>.pksweeper/
```

Typical files:

- `quick-plan.json`
- `items/<number>.md`
- `quick-summary.md`
- `todo.md`
- `plan.md`
- `artifacts/reviews/...`
- `artifacts/linear-pr-reviewer/...`

## Safety

- Review and sweep runs are proposal-only.
- `linear-pr-reviewer` reviews a single PR URL and emits JSON for Linear/agent-runner hooks.
- `apply-decisions` is the command that can mutate GitHub.
- Maintainer-authored items are not auto-closed.
- Protected labels block automated close actions.
- Reviews fail if Codex modifies the target checkout.
- Dirty target checkouts stop preflight unless `--allow-dirty` is passed.
- Placeholder target repos are ignored instead of queried.

Use `--allow-dirty` only when local target checkout changes are intentional:

```bash
pksweeper sweep --allow-dirty
```

## Examples

Preview candidates:

```bash
pksweeper plan
```

Run a small safe sweep:

```bash
pksweeper sweep --agents 2 --concurrency 1 --batch-size 1 --max-pages 2
```

Run against an explicit repository:

```bash
pksweeper sweep --repo octocat/Hello-World
```

Review one PR for a Linear agent-runner callback:

```bash
pksweeper linear-pr-reviewer --repo octocat/Hello-World --pr-url https://github.com/octocat/Hello-World/pull/42 --output review.json
```

Use an explicit Codex model provider for non-default runners:

```bash
pksweeper linear-pr-reviewer --repo octocat/Hello-World --pr-url https://github.com/octocat/Hello-World/pull/42 --codex-model qwen3.7-plus --codex-provider qwen --codex-provider-name "Qwen Model Studio" --codex-provider-base-url https://token-plan.ap-southeast-1.maas.aliyuncs.com/compatible-mode/v1 --codex-provider-env-key QWEN_API_KEY
```

Apply already-reviewed decisions later, after inspection:

```bash
pksweeper apply-decisions --limit 5
```

Do not pass `--merge-prs` unless you intentionally want high-confidence PR merge
proposals to be merged.

## Codex and Claude Code Plugin

This repo ships a local plugin package so `pk-sweeper` can be installed into
Codex or Claude Code from a fresh checkout.

Codex marketplace manifest:

```text
.agents/plugins/marketplace.json
```

Codex plugin package:

```text
plugins/pk-sweeper/.codex-plugin/plugin.json
plugins/pk-sweeper/skills/pk-sweeper/SKILL.md
```

Claude Code marketplace manifest:

```text
.claude-plugin/marketplace.json
```

Claude Code plugin package:

```text
plugins/pk-sweeper/.claude-plugin/plugin.json
plugins/pk-sweeper/commands/pk-sweeper.md
plugins/pk-sweeper/skills/pk-sweeper/SKILL.md
```

The plugin uses the installed `pk-sweeper` CLI when available and falls back to
`npx --yes pk-sweeper`. It keeps the same safety posture as the CLI: review and
planning commands are non-mutating, while `apply-decisions` and `--merge-prs`
require explicit maintainer intent.

## Development

```bash
npm install
npm run build
npm run check
npm pack
```

The published package includes only:

- `dist`
- `.agents`
- `.claude-plugin`
- `plugins`
- `prompts`
- `schema`
- `README.md`
- `LICENSE`

Generated review archives, local workspaces, and target-repo artifacts are not
included in the npm package.
