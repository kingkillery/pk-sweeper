# pk-sweeper

pk-sweeper is a conservative automated maintenance bot that can run against any
GitHub repository after a short configuration.

It keeps one markdown report per open issue or PR, publishes one durable Codex
automated review comment when useful, and only closes items when the evidence is
strong.

## Configuration

### Target repository

pk-sweeper resolves the target repository in this priority order:

1. **`--repo owner/repo` CLI flag** — pass it to any command:
   ```sh
   node dist/pksweeper.js review --repo myorg/myrepo
   ```
2. **`PKSWEEPER_TARGET_REPO` environment variable**
3. **`GH_REPO` environment variable** (shared with the `gh` CLI)
4. **`sweeper.config.json` → `targetRepo` field** (see below)
5. **Auto-detected from the git remote** — when you run pk-sweeper from inside a
   local clone of the target repo, the `origin` remote URL is parsed automatically.

This means you can run pk-sweeper against any repo from within a local clone
**without touching `sweeper.config.json`** at all.

### sweeper.config.json

`sweeper.config.json` is optional when the target repo can be resolved by one of
the methods above. When it exists, it can carry the remaining options:

```json
{
  "targetRepo": "owner/repo",
  "docsUrl": null,
  "pluginEcosystem": null,
  "extraStopWords": [],
  "protectedLabels": ["security", "beta-blocker", "release-blocker", "maintainer"]
}
```

| Field | Required | Description |
| --- | --- | --- |
| `targetRepo` | no | The GitHub repository to sweep, e.g. `"myorg/myrepo"`. Can be omitted when the repo is provided via flag, env var, or git remote. |
| `docsUrl` | no | Base URL for the target repo's public docs site (enables pretty doc links in comments). Set `null` to disable. |
| `pluginEcosystem` | no | `{ "name": "...", "url": "..." }` — if your project has a plugin/extension ecosystem, Codex may propose closing plugin-fit issues here rather than in the core repo. Set `null` to disable the `clawhub` close reason. |
| `extraStopWords` | no | Additional words to skip when searching for related items by title (e.g. the repo name or common project terms). |
| `protectedLabels` | no | Labels that block automated close proposals. Defaults to `["security", "beta-blocker", "release-blocker", "maintainer"]`. |

That's the full configuration. After filling in `targetRepo`, the workflow and
all CLI commands work without further changes.

## Guardrails

The sweeper may propose a close only when the item is clearly one of these:

- implemented on current `main`
- not reproducible on current `main`
- better suited for the configured plugin ecosystem than core (when `pluginEcosystem` is set)
- duplicate or superseded by a canonical issue/PR
- concrete but not actionable in this source repo
- incoherent enough that no action can be taken
- stale issue older than 60 days with too little data to verify

Maintainer-authored items are never auto-closed. Everything else stays open.

## Dashboard

Last dashboard update: Apr 26, 2026, 04:01 UTC

### Current Run

<!-- pksweeper-status:start -->
**Workflow status**

Updated: Apr 26, 2026, 04:01 UTC

State: Apply finished

Apply/comment-sync run finished with 20 fresh closes out of requested limit 20. See apply-report.json for per-item results.
Run: [https://github.com/kingkillery/pk-sweeper/actions/runs/24947732166](https://github.com/kingkillery/pk-sweeper/actions/runs/24947732166)
<!-- pksweeper-status:end -->

### Queue

| Metric | Count |
| --- | ---: |
| Open issues in [openclaw/openclaw](https://github.com/openclaw/openclaw) | 4811 |
| Open PRs in [openclaw/openclaw](https://github.com/openclaw/openclaw) | 4222 |
| Open items total | 9033 |
| Reviewed files | 8856 |
| Unreviewed open items | 177 |
| Archived closed files | 10441 |

### Review Outcomes

| Metric | Count |
| --- | ---: |
| Fresh reviewed issues in the last 7 days | 4738 |
| Proposed issue closes | 497 (10.5% of reviewed issues) |
| Fresh reviewed PRs in the last 7 days | 4095 |
| Proposed PR closes | 157 (3.8% of reviewed PRs) |
| Fresh verified reviews in the last 7 days | 8833 |
| Proposed closes awaiting apply | 654 (7.4% of fresh reviews) |
| Closed by Codex apply | 8092 |
| Failed or stale reviews | 23 |

### Cadence

| Metric | Coverage |
| --- | ---: |
| Hourly cadence coverage | 14/1015 current (1001 due, 1.4%) |
| Hourly hot item cadence (<7d) | 14/1015 current (1001 due, 1.4%) |
| Daily cadence coverage | 5621/5705 current (84 due, 98.5%) |
| Daily PR cadence | 3574/3644 current (70 due, 98.1%) |
| Daily new issue cadence (<30d) | 2047/2061 current (14 due, 99.3%) |
| Weekly older issue cadence | 2134/2136 current (2 due, 99.9%) |
| Due now by cadence | 1264 |

### Latest Run Activity

Latest review: Apr 26, 2026, 03:53 UTC. Latest close: Apr 26, 2026, 04:00 UTC. Latest comment sync: Apr 26, 2026, 04:00 UTC.

| Window | Reviews | Close decisions | Keep-open decisions | Failed/stale reviews | Closed | Comments synced | Apply skips |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Last 15 minutes | 143 | 34 | 109 | 0 | 81 | 82 | 0 |
| Last hour | 850 | 156 | 694 | 4 | 256 | 276 | 3 |
| Last 24 hours | 11021 | 2496 | 8525 | 36 | 5591 | 498 | 192 |

<details>
<summary>Recently Reviewed (latest 10)</summary>

<br>

| Item | Title | Outcome | Status | Reviewed |
| --- | --- | --- | --- | --- |
| [#67817](https://github.com/openclaw/openclaw/issues/67817) | [Bug]: Discord setup: service file doesn't include DISCORD_BOT_TOKEN environment variable | [keep_open / kept_open](https://github.com/kingkillery/pk-sweeper/blob/main/items/67817.md) | complete | Apr 26, 2026, 03:53 UTC |
| [#67759](https://github.com/openclaw/openclaw/issues/67759) | WebChat image recognition fails when using coding.dashscope base URL for Qwen models | [keep_open / kept_open](https://github.com/kingkillery/pk-sweeper/blob/main/items/67759.md) | complete | Apr 26, 2026, 03:53 UTC |
| [#67826](https://github.com/openclaw/openclaw/pull/67826) | Telegram: harden setup allowFrom and target resolution | [keep_open / kept_open](https://github.com/kingkillery/pk-sweeper/blob/main/items/67826.md) | complete | Apr 26, 2026, 03:52 UTC |
| [#67689](https://github.com/openclaw/openclaw/issues/67689) | Feature request: Session management UI (hide/archive/filter sessions) | [close / proposed_close](https://github.com/kingkillery/pk-sweeper/blob/main/items/67689.md) | complete | Apr 26, 2026, 03:51 UTC |
| [#67970](https://github.com/openclaw/openclaw/issues/67970) | Feature: built-in memory should support automatic context extraction and daily-log writing | [keep_open / kept_open](https://github.com/kingkillery/pk-sweeper/blob/main/items/67970.md) | complete | Apr 26, 2026, 03:51 UTC |
| [#67836](https://github.com/openclaw/openclaw/pull/67836) | feat(memory-core): Memory v2 foundation — sidecar, ingest, rerank (all default-off) | [keep_open / kept_open](https://github.com/kingkillery/pk-sweeper/blob/main/items/67836.md) | complete | Apr 26, 2026, 03:51 UTC |
| [#67889](https://github.com/openclaw/openclaw/issues/67889) | Image understanding tool has hardcoded 60s timeout, ignoring configured timeoutSeconds | [keep_open / kept_open](https://github.com/kingkillery/pk-sweeper/blob/main/items/67889.md) | complete | Apr 26, 2026, 03:51 UTC |
| [#67952](https://github.com/openclaw/openclaw/pull/67952) | fix(memory-lancedb): get memory records through ltm list command | [keep_open / kept_open](https://github.com/kingkillery/pk-sweeper/blob/main/items/67952.md) | complete | Apr 26, 2026, 03:51 UTC |
| [#67946](https://github.com/openclaw/openclaw/pull/67946) | Clear stale subagent lineage on top-level sessions | [keep_open / kept_open](https://github.com/kingkillery/pk-sweeper/blob/main/items/67946.md) | complete | Apr 26, 2026, 03:51 UTC |
| [#67943](https://github.com/openclaw/openclaw/issues/67943) | Normal sessions can inherit stale subagent lineage and incorrectly hit sessions_spawn depth limits | [keep_open / kept_open](https://github.com/kingkillery/pk-sweeper/blob/main/items/67943.md) | complete | Apr 26, 2026, 03:51 UTC |

</details>

## How It Works

The sweeper has two independent lanes.

### Review Lane

Review is proposal-only. It never closes items.

- A planner scans open issues and PRs, then assigns exact item numbers to shards.
- Each shard checks out the configured `targetRepo` at `main`.
- Codex reviews with `gpt-5.5`, high reasoning, fast service tier, and a
  10-minute per-item timeout.
- Each item becomes `items/<number>.md` with the decision, evidence, suggested
  comment, runtime metadata, and GitHub snapshot hash.
- High-confidence allowed close decisions become `proposed_close`.

Cadence:

- hourly for items with activity since the last snapshot
- hourly for anything created in the last 7 days
- daily for older PRs and issues younger than 30 days
- weekly for older inactive issues
- immediate-ish hot intake every 5 minutes for newest/active items

### Apply Lane

Apply reads existing reports and mutates GitHub only when the stored review is
still valid.

- Updates the single marker-backed Codex automated review comment in place.
- Closes only unchanged high-confidence proposals.
- Reuses the review comment when closing; no duplicate close comment.
- Moves closed or already-closed reports to `closed/<number>.md`.
- Moves reopened archived reports back to `items/<number>.md` as stale.
- Commits checkpoints and dashboard heartbeats during long runs.

Apply defaults to issue-only closes, no age floor, 2-second close delay, and
50 fresh closes per checkpoint. If it reaches the requested limit, it queues
another apply run with the same settings.

### Safety Model

- Maintainer-authored items are excluded from automated closes.
- Protected labels block close proposals.
- Codex runs without GitHub write tokens.
- CI makes the target repo checkout read-only for reviews.
- Reviews fail if Codex leaves tracked or untracked changes behind.
- Snapshot changes block apply unless the only change is the bot’s own review
  comment.

### Audit

`npm run audit` compares live GitHub state with generated records without moving
files. It reports missing open records, archived open records, stale records,
duplicates, protected-label proposed closes, and stale review-status records.
Missing open records are classified as eligible, maintainer-authored, protected,
or recently created so strict audit mode can flag actionable drift without
treating expected queue lag or excluded items as failures.

## Local Run

Requires Node 24. Set `targetRepo` in `sweeper.config.json` first.

### NPM / NPX quick run

Install from this repo:

```bash
npm install -g github:kingkillery/pk-sweeper
```

Or run without a global install from inside the target repo checkout:

```bash
npx github:kingkillery/pk-sweeper quick
```

After the package is published to npm, the shorter forms work:

```bash
npm install -g pk-sweeper
npx pk-sweeper quick
```

`quick` is a single local run. It plans once, refreshes target Git metadata once,
reviews open issues and PRs now, starts async review shards, merges proposal
artifacts into a sibling workspace folder named `<repo>.pksweeper/items`, then
writes maintainer-facing `quick-summary.md`, `todo.md`, and `plan.md`. It does
not schedule itself or run 24/7.

Defaults:

- `--agents 50`
- `--batch-size 1`
- `--codex-model gpt-5.4-mini`
- `--codex-reasoning-effort medium`
- `--codex-sandbox read-only`
- `--max-pages 25`
- `--workspace ../<repo>.pksweeper`

If `codex` is not visible to non-interactive `npx` child processes, set
`PKSWEEPER_CODEX_BIN` or pass `--codex-bin` with the absolute path to the Codex
CLI.

By default quick mode ignores prior-review cadence so repeated manual runs still
review open items. Use `--respect-cadence` when you want long-running sweeper
cadence behavior.

Quick mode also includes maintainer-authored and protected-label items in the
review plan by default. Close safety still applies during review, so protected or
maintainer-authored items are not converted into automated close actions. Use
`--respect-exclusions` when you want the scheduled sweeper's stricter selection
behavior.

Terminal output distinguishes shard process failures from failed Codex reviews:
`failed_shards` means the child process failed, while `failed_reviews` means the
item report has `review_status: failed`.

Example with more sub-agents:

```bash
npx pk-sweeper quick --repo owner/repo --agents 80 --concurrency 80 --batch-size 1
```

Prerequisites are the `gh` CLI authenticated for the target repository and a
logged-in `codex` CLI. Free or alternate model providers can be used only to the
extent the local `codex` CLI is already configured to use them; pk-sweeper does
not keep a background worker alive for token reasons.

```bash
source ~/.profile
npm install
npm run build
npm run plan -- --batch-size 5 --shard-count 50 --max-pages 250 --codex-model gpt-5.5 --codex-reasoning-effort high --codex-service-tier fast
npm run review -- --target-dir ../my-repo --batch-size 5 --max-pages 250 --artifact-dir artifacts/reviews --codex-model gpt-5.5 --codex-reasoning-effort high --codex-service-tier fast --codex-timeout-ms 600000
npm run apply-artifacts -- --artifact-dir artifacts/reviews
npm run audit -- --max-pages 250 --sample-limit 25
npm run reconcile -- --dry-run
```

Apply unchanged proposals later:

```bash
source ~/.profile
npm run apply-decisions -- --limit 20
```

Manual review runs are proposal-only even if `--apply-closures` or workflow input `apply_closures=true` is set. Use `apply_existing=true` to apply unchanged proposals later.

## Checks

```bash
npm run check
npm run oxformat
```

`oxformat` is an alias for `oxfmt`; there is no separate `oxformat` npm package.

## GitHub Actions Setup

Required secrets:

- `OPENAI_API_KEY`: OpenAI API key used to log Codex in before review shards run.
- `CODEX_API_KEY`: optional compatibility alias for the same key during the login check.
- `OPENCLAW_GH_TOKEN`: optional fallback GitHub token for read-heavy target repo scans and artifact publish reconciliation when the GitHub App token is unavailable.
- `PKSWEEPER_APP_ID`: GitHub App ID for the bot app (optional; used for attributing comments/closes to the bot).
- `PKSWEEPER_APP_PRIVATE_KEY`: private key for the bot app; plan/review jobs use a short-lived GitHub App installation token for read-heavy target API calls, and apply/comment-sync jobs use the app token for comments and closes.

Token flow:

- Review shards log Codex in with `OPENAI_API_KEY`, then run without OpenAI or
  Codex token environment variables.
- The sweeper uses the GitHub App token for read-heavy target context,
  falling back to `OPENCLAW_GH_TOKEN` only if app secrets are absent.
- Apply mode uses the app token for review comments and closes, so GitHub
  attributes mutations to the bot.
- The built-in `GITHUB_TOKEN` commits generated reports back to this repo.

Required app permissions:

- read access for target scan context
- write access to target repo issues and pull requests
- optional Actions write on this sweeper repo for app-token-based run
  cancellation or dispatch
