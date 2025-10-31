# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with
code in this repository.

## Overview

This is a personal environment setup repository that uses Ansible to configure
macOS and Windows (including WSL) systems. The setup automates installation and
configuration of development tools, shell environments, package managers, and
system preferences.

## Architecture

### Platform-Specific Playbooks

- **macOS (Iapetus)**: `ansible/playbooks/iapetus-macos.yaml` - Configures
  macOS systems with Homebrew, Ghostty, and macOS-specific settings
- **Windows (Khronos)**: `ansible/playbooks/khronos-windows.yaml` - Contains
  two plays:
  1. Windows host setup (using Winget and Scoop for package management)
  2. WSL environment setup (using apt and Homebrew)

### Ansible Roles

The setup is modularized into roles under `ansible/roles/`:

- **Platform-specific**: `os_macos`, `os_windows`, `wsl`
- **Package managers**: `homebrew`, `scoop`, `winget`, `apt`
- **Tools**: `fish`, `mise`, `nvim`
- **Common**: `home` (handles dotfiles and directory setup)

### Key Configurations

- `ansible/ansible.cfg`: Custom Ansible configuration with inventory path set to
  `./inventory`, `private_role_vars=True`, and `interpreter_python=auto_silent`
- `.ansible-lint`: Linting configuration with opt-in rules enabled and YAML
  line-length checks skipped
- `.mise.toml`: Defines project setup tasks and tool versions (pre-commit,
  shellcheck, yamllint, markdownlint-cli2, actionlint)

## Common Commands

### Setup Project

```sh
mise trust
mise run setup
```

This installs mise tools and sets up pre-commit hooks.

### Run Main Setup Scripts

**macOS (Iapetus):**

```sh
./setup-iapetus.sh -K
```

**Windows (Khronos) - from WSL:**

```sh
# For Windows host
./setup-khronos.sh -e win_username=user -K -l khronos

# For WSL environment
./setup-khronos.sh -e win_username=user -K -l local
```

### Linting and Pre-commit

```sh
# Run all pre-commit hooks
pre-commit run --all-files

# Run ansible-lint
ansible-lint

# Run other linters
yamllint .
markdownlint-cli2 "**/*.md"
shellcheck script/**/*.sh
```

### Update Configuration Files

**Update fishfile (Fish shell plugins):**

```sh
cat ~/.config/fish/fish_plugins
# Copy output to ansible/playbooks/files/fisher-my-setup/
```

**Update Brewfile:**

For automated update via Claude Code subagent, use the `/update-brewfile-mac`
slash command. The subagent will:

1. Run `brew bundle dump --describe --file=-` to get current packages
2. Read `ansible/playbooks/files/homebrew/Brewfile-mac` to preserve inline
   comments (e.g., `# for asdf-erlang, asdf-php`)
3. Write the complete output to the Brewfile, preserving:
   - Inline comments on brew formulae
   - Commented-out casks: `#cask "gimp"`, `#cask "horndis"`,
     `#cask "inkscape"`, `#cask "mono-mdk-for-visual-studio"`
   - Commented-out mas entry: `#mas "LimeChat", id: 414030210`
4. Verify the result by comparing with `brew bundle dump` output (ignoring
   comments)

Manual process:

```sh
# For macOS
brew bundle dump --describe
# Copy to ansible/playbooks/files/homebrew/Brewfile-mac

# For WSL
brew bundle dump --describe
# Copy to ansible/playbooks/files/homebrew/Brewfile-wsl
```

**Export VS Code extensions:**

```sh
code --list-extensions | awk '{ print "vscode \""$1"\"" }'
```

**Export Scoop packages (PowerShell):**

```ps1
scoop export `
  | ForEach-Object `
    -Begin { Write-Output "---" "scoop_packages:" } `
    -Process { $local:g = ""; `
      if ($_ -match "\*global\*") { $g = ", global: true"; } `
      Write-Output ("  - { name: "+($_ -split " ")[0]+$g+" }") `
    }
```

## Development Workflow

1. The setup scripts install Ansible first, then execute the appropriate
   playbook
2. Playbooks import roles in sequence, each handling a specific aspect of system
   configuration
3. All roles use common variables defined in `ansible/playbooks/vars/common.yaml`
4. Role variables are private (defined in `ansible.cfg`) to prevent unintended
   variable sharing
5. The `home` role has platform-specific task files (`macos.yaml`,
   `windows.yaml`, `windows.wsl.yaml`)
6. Each role follows standard Ansible structure with `defaults/`, `files/`,
   `handlers/`, `meta/`, `tasks/`, `templates/`, `tests/`, and `vars/`
   directories

### Important: Run ansible-lint After Changes

**IMPORTANT**: When you modify any of the following files, you MUST run
`ansible-lint` to check for errors before committing:

- `ansible/playbooks/**`
- `ansible/roles/**`
- `script/**`
- `setup-*.sh`

Run the linter with:

```sh
ansible-lint
```

This ensures that Ansible code follows best practices and maintains consistency
across the project.

## Testing

The repository includes GitHub Actions workflows:

- `pre-commit.yaml`: Runs pre-commit hooks on push
- `setup.yaml`: Tests the setup process

Run Ansible in check mode to preview changes without applying them:

```sh
ansible-playbook ansible/playbooks/iapetus-macos.yaml --check
```
