# Change: Add Global Tool Management for pnpm and uv

## Why

Currently, the mise role manages language-specific package installations
through mise's built-in `.default-*-packages` files (npm, go, python, gems,
mix, perl). However, tools installed globally via `pnpm` and `uv` are not
managed by the setup scripts. This creates inconsistency in environment setup,
as these globally installed tools (like @byterover/cipher,
@fission-ai/openspec, markdownlint-cli2, prettier) must be manually installed
on new systems.

Adding global tool management for `pnpm` and `uv` to the mise role will ensure
complete and reproducible development environment setup across all platforms.

## What Changes

- Create new default package files: `.default-pnpm-packages` and
  `.default-uv-tools`
- Migrate Python packages from `.default-python-packages` to
  `.default-uv-tools` (using uv instead of mise for Python tool management)
- Add Ansible tasks to install global packages via `pnpm install -g` and
  `uv tool install`
- Integrate these tasks into the mise role as a separate, independent task
  that runs after mise installation
- Support all platforms where the mise role is executed (macOS, Windows, WSL)

## Impact

- Affected specs: `mise` (new capability to be created)
- Affected code:
  - `ansible/roles/mise/tasks/main.yaml` - Add new task import
  - `ansible/roles/mise/tasks/20-install-global-tools.yaml` - New task file
  - `ansible/roles/mise/defaults/main.yaml` - Add variables for new package files
  - `~/GoogleDrive/share/dotfiles/mise/.default-pnpm-packages` - New file
    in dotfiles
  - `~/GoogleDrive/share/dotfiles/mise/.default-uv-tools` - New file in
    dotfiles
  - `~/GoogleDrive/share/dotfiles/mise/.default-python-packages` - Emptied
    (Python tools migrated to uv)
- Affected documentation:
  - `README.md` - Add commands for exporting pnpm and uv tool lists
  - `CLAUDE.md` - Add information about managing global tools
- Breaking changes: None
