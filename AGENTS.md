# AGENTS.md

This file provides guidance to AI assistants (Claude Code and other agents) when
working with code in this repository.

> **For comprehensive project context**, see `openspec/project.md` which
> contains detailed information about:
>
> - Project purpose and goals
> - Complete tech stack and dependencies
> - Architecture patterns and conventions
> - Testing strategy and constraints
> - Domain context and external dependencies

This file focuses on **practical commands and development workflows**.

<!-- OPENSPEC:START -->

## OpenSpec Instructions

These instructions are for AI assistants working in this project.

Always open `@/openspec/AGENTS.md` when the request:

- Mentions planning or proposals (words like proposal, spec, change, plan)
- Introduces new capabilities, breaking changes, architecture shifts,
  or big performance/security work
- Sounds ambiguous and you need the authoritative spec before coding

Use `@/openspec/AGENTS.md` to learn:

- How to create and apply change proposals
- Spec format and conventions
- Project structure and guidelines

Keep this managed block so 'openspec update' can refresh the instructions.

<!-- OPENSPEC:END -->

## Overview

This is a personal environment setup repository that uses Ansible to configure
macOS (Iapetus) and Windows with WSL (Khronos) systems. For detailed project
context, architecture patterns, and design decisions, see `openspec/project.md`.

**Quick Reference:**

- **Playbooks:** `ansible/playbooks/` (iapetus-macos, khronos-windows)
- **Roles:** `ansible/roles/` (platform, package managers, tools)
- **Specs:** `openspec/specs/` (00*\* = infrastructure, 01*\* = playbooks,
  02\_\* = roles)
- **Key Files:**
  - `ansible.cfg` - Ansible configuration (private role vars, Python interpreter)
  - `.ansible-lint` - Linting rules (production profile)
  - `.mise.toml` - Tool versions and setup tasks
  - `ansible/playbooks/files/` - Configuration files, Brewfiles, VS Code extensions

## Key Architecture Points

**Role-Based Structure:**

- Each role in `ansible/roles/` represents one responsibility (tool/platform)
- Variables are private to roles (`private_role_vars=True` in `ansible.cfg`)
- Platform-specific tasks use conditional files (macos.yaml, windows.yaml,
  windows.wsl.yaml)

**Idempotency is Critical:**

- All tasks must be safely re-runnable
- Use proper `changed_when` conditions
- Bootstrap scripts check for existing installations

**Multi-Platform Support:**

- `iapetus-macos.yaml` - macOS playbook
- `khronos-windows.yaml` - Windows host + WSL (two plays in one file)
- Platform detection via `ansible_facts`

## Common Commands

### Setup Project

```sh
mise trust && mise run setup
```

This installs mise tools and sets up pre-commit hooks.

### Run Main Setup Scripts

**macOS (Iapetus):**

```sh
./setup-iapetus.sh -K
```

**Windows (Khronos):**

Initial setup from PowerShell (required first):

```ps1
Set-ExecutionPolicy RemoteSigned
.\setup-windows.ps1 setup-khronos.sh -K
```

Then from WSL:

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

### Node Package Management

**This project requires pnpm** (not npm or yarn). Run `pnpm install` to install
node dependencies (markdownlint-cli2, prettier, prettier plugins). The
`package.json` explicitly requires pnpm and prohibits npm/yarn usage.

### Update Configuration Files

**Update fishfile (Fish shell plugins):**

```sh
cat ~/.config/fish/fish_plugins
# Copy output to ansible/playbooks/files/fisher-my-setup/
```

**Update Brewfile:**

Note: There is a custom `brewfile-updater` agent available in
`.claude/agents/brewfile-updater.md` that can automate this process while
preserving comments.

```sh
# For macOS
brew bundle dump --describe --file=- > ansible/playbooks/files/homebrew/Brewfile-mac

# For WSL
brew bundle dump --describe --file=- > ansible/playbooks/files/homebrew/Brewfile-wsl
```

When updating manually, preserve:

- Inline comments on brew formulae (e.g., `# for asdf-erlang, asdf-php`)
- Commented-out casks: `#cask "gimp"`, `#cask "horndis"`,
  `#cask "inkscape"`, `#cask "mono-mdk-for-visual-studio"`
- Commented-out mas entry: `#mas "LimeChat", id: 414030210`

**Export VS Code extensions:**

```sh
# macOS / WSL
code --list-extensions | awk '{ print "vscode \""$1"\"" }'
```

```ps1
# Windows PowerShell
code --list-extensions | ForEach-Object -Process { Write-Output "vscode ""$_""" }
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

**Export Visual Studio configuration (PowerShell):**

```ps1
& "C:\Program Files (x86)\Microsoft Visual Studio\Installer\setup.exe" export -p --channelId VisualStudio.17.Preview --productId Microsoft.VisualStudio.Product.Community --config ansible/playbooks/files/visual-studio/.vsconfig
```

**Export pnpm global packages:**

```sh
pnpm ls -g --depth=0 | awk 'NF==2 && $2 ~ /^[0-9]/ {print $1}' > ~/GoogleDrive/share/dotfiles/mise/.default-pnpm-packages
```

**Export uv tools:**

```sh
uv tool list | awk '$2 ~ /^v/ {print $1}' > ~/GoogleDrive/share/dotfiles/mise/.default-uv-tools
```

## Development Workflow

See `openspec/project.md` for detailed architecture patterns, bootstrap process,
and environment setup lifecycle. Key workflow steps:

1. Bootstrap scripts install prerequisites (Homebrew, Ansible)
2. Playbooks orchestrate role execution with common variables
3. Roles configure specific tools (private variables via `ansible.cfg`)

### Important: Run Linters After Changes

**IMPORTANT**: When you modify files, you MUST run the appropriate linters to
check for errors before committing:

**For Ansible files** (`ansible/playbooks/**`, `ansible/roles/**`):

```sh
ansible-lint
```

This ensures that Ansible code follows best practices and maintains consistency
across the project.

**For Markdown files** (any `.md` file):

```sh
markdownlint-cli2 "**/*.md"
```

This validates Markdown formatting and ensures documentation consistency.

**After OpenSpec archive operations**:

When you run `openspec archive <change-id>`, the archive operation updates spec
files and moves the change to the archive directory. You MUST perform the
following steps:

1. **Run markdownlint** to fix formatting issues in updated documentation:

   ```sh
   # After openspec archive, run markdownlint on updated specs and archived changes
   markdownlint-cli2 "openspec/specs/**/*.md" "openspec/changes/archive/**/*.md"
   ```

   This ensures all OpenSpec documentation maintains consistent formatting.

2. **Review and update `openspec/project.md`** to reflect changes in project
   context:
   - Check if external dependencies lists need updating (e.g., MCP servers,
     package managers, tools)
   - Verify that tech stack descriptions match current implementation
   - Update any project conventions or patterns that changed
   - Ensure domain context and constraints remain accurate

   Pay special attention to sections like "MCP Servers (Claude Code)" and other
   enumerated lists that may need to reflect added or removed components.

## Testing and Validation

See `openspec/project.md` for complete testing strategy including idempotency
testing, platform coverage, and continuous integration details.

**Quick Commands:**

```sh
# Preview changes without applying
ansible-playbook ansible/playbooks/iapetus-macos.yaml --check

# Run all pre-commit hooks
pre-commit run --all-files

# Validate OpenSpec specifications
openspec validate --all
```
