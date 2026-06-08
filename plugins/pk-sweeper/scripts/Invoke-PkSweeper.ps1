param(
  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]] $PkSweeperArgs
)

$ErrorActionPreference = 'Stop'

$command = Get-Command pk-sweeper -ErrorAction SilentlyContinue
if (-not $command) {
  $command = Get-Command pksweeper -ErrorAction SilentlyContinue
}

if ($command) {
  & $command.Source @PkSweeperArgs
  exit $LASTEXITCODE
}

& npx --yes pk-sweeper @PkSweeperArgs
exit $LASTEXITCODE
