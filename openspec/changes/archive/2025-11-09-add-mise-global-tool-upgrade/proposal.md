# Change: Add upgrade capability for mise global tools

## Why

Current mise role implementation only installs global tools via pnpm and uv but
doesn't upgrade existing installations. This requires manual intervention to
keep global tools up-to-date, which defeats the purpose of automated
environment management.

## What Changes

- Add tasks to upgrade existing pnpm global packages using `pnpm update -g`
- Add tasks to upgrade existing uv tools using `uv tool upgrade --all`
- Execute upgrade tasks after package manager availability check but before
  installing new packages (similar to Homebrew workflow)
- Maintain idempotency by checking for installed packages before attempting
  upgrades
- Preserve existing installation behavior for new packages

## Impact

- Affected specs: `02_mise`
- Affected code: `ansible/roles/mise/tasks/20-install-global-tools.yaml`
- Backward compatible: No breaking changes, only adds new upgrade tasks
