# Implementation Tasks

## 1. Implementation

- [x] 1.1 Add task to upgrade pnpm global packages using `pnpm update -g`
      for all currently installed packages
- [x] 1.2 Add task to upgrade uv tools using `uv tool upgrade --all`
- [x] 1.3 Ensure upgrade tasks execute after package manager check but before
      installing new packages from `.default-*-packages` files (similar to
      Homebrew workflow)
- [x] 1.4 Implement proper `changed_when` conditions to detect actual upgrades
- [x] 1.5 Add conditional checks to skip upgrade tasks when pnpm/uv not available

## 2. Testing

- [ ] 2.1 Test pnpm package upgrade on macOS
- [ ] 2.2 Test uv tool upgrade on macOS
- [ ] 2.3 Test idempotency - second run should report no changes if already up-to-date
- [ ] 2.4 Test graceful skipping when pnpm/uv not installed
- [ ] 2.5 Test with empty package/tool files

## 3. Documentation

- [ ] 3.1 Update README or role documentation with upgrade behavior
- [ ] 3.2 Document maintenance workflow for keeping global tools updated
