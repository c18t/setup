# Project Context

## Purpose

Personal development environment setup automation using Ansible. This project
provides reproducible, idempotent infrastructure-as-code for configuring
development machines across multiple platforms (macOS, Windows, WSL).

**Goals:**

- Automate complete development environment setup from scratch
- Maintain consistency across multiple machines and platforms
- Enable quick recovery from system failures or migrations
- Document all configuration decisions as executable code
- Support incremental updates without breaking existing setups

## Tech Stack

### Core Technologies

- **Ansible** - Configuration management and orchestration
- **Shell Scripts** - Bootstrap scripts for initial setup
- **PowerShell** - Windows-specific configuration
- **OpenSpec** - Specification-driven development framework

### Package Managers

- **Homebrew** - macOS and Linux (WSL) package management
- **Scoop** - Windows command-line package manager
- **Winget** - Windows Package Manager
- **APT** - Debian/Ubuntu package management (WSL)
- **mise** - Development tool version management
- **pnpm** - Node.js package manager (global tools)
- **uv** - Python package manager (global tools)

### Development Tools

- **Fish shell** - Default shell with fisher plugin manager
- **Neovim** - Primary text editor
- **Claude Code** - AI-assisted development CLI
- **Git** - Version control

### Infrastructure

- **WSL2** - Windows Subsystem for Linux
- **Google Drive** - Dotfiles repository storage

## Project Conventions

### Code Style

**Ansible:**

- Follow ansible-lint production profile rules
- Use fully qualified collection names (ansible.builtin.\*)
- Implement idempotent tasks with proper `changed_when` conditions
- Name tasks descriptively: `<task-file> | <action>`
- Use role-based architecture with clear separation of concerns

**Shell Scripts:**

- Use `set -e` for error propagation
- Implement verbose logging via file descriptor 3
- Check for existing installations before proceeding (idempotency)
- Provide clear success/failure messages
- Use pushd/popd for directory navigation safety

**YAML:**

- 2-space indentation
- Use `---` document start marker
- Quote strings containing special characters
- Prefer multi-line format for complex structures

### Architecture Patterns

**Role-Based Architecture:**

- Each role represents a single responsibility (tool or platform)
- Roles are independent and reusable
- Variables are scoped to roles (private_role_vars=True)
- Common variables defined in playbooks, not roles

**Platform Abstraction:**

- Separate playbooks for each platform (iapetus-macos, khronos-windows)
- Platform-specific task files within roles (macos.yaml, windows.yaml, windows.wsl.yaml)
- Conditional execution based on ansible_facts

**Dotfiles Management:**

- Central dotfiles repository in Google Drive
- Symbolic links from home directory to dotfiles
- Version-controlled configuration files
- Platform-specific configurations when needed

**Bootstrap Pattern:**

1. Bootstrap scripts install prerequisites (Homebrew, Ansible)
2. Ansible playbooks orchestrate role execution
3. Roles configure specific tools and platforms
4. Handlers restart services when needed

### Key Configurations

**Ansible Configuration (ansible.cfg):**

- `inventory = ./inventory` - Custom inventory path
- `private_role_vars = True` - Role variables are private to prevent
  conflicts
- `interpreter_python = auto_silent` - Automatic Python interpreter discovery
  without warnings

**Linting Configuration (.ansible-lint):**

- Production profile rules enabled
- YAML line-length checks skipped
- Custom opt-in rules for best practices

**Tool Versions (.mise.toml):**

- Defines project setup tasks
- Manages tool versions: pre-commit, shellcheck, yamllint, markdownlint-cli2, actionlint
- Ensures consistent development environment across platforms

### Testing Strategy

**Validation:**

- ansible-lint on all playbook and role changes
- openspec validate for specification compliance
- Manual testing on target platforms

**Idempotency Testing:**

- Run playbooks twice - second run should report no changes
- Verify changed_when conditions correctly detect state changes

**Platform Coverage:**

- macOS (Iapetus) - iapetus-macos.yaml
- Windows host (Khronos) - khronos-windows.yaml (first play)
- WSL (Khronos) - khronos-windows.yaml (second play)

**Continuous Integration:**

- `pre-commit.yaml` workflow - Runs pre-commit hooks on push
- `setup.yaml` workflow - Tests setup process on GitHub Actions
- Check mode available for dry-run testing: `ansible-playbook <playbook> --check`

### Specification Organization

**OpenSpec Directory Structure:**

Specifications in `openspec/specs/` follow a numbered prefix convention:

- **00\_[name]**: Project structure/infrastructure specs (e.g., `00_scripts`)
- **01\_[name]**: Playbook/environment specs (e.g., `01_iapetus-macos`,
  `01_khronos-windows`)
- **02\_[name]**: Role/task specs (e.g., `02_mise`, `02_homebrew`, `02_fish`)

This numbering ensures specifications are organized by architectural layer and
appear in logical order when listed alphabetically.

### Git Workflow

**Branching Strategy:**

- `main` - stable, tested configurations
- `feature/*` - feature development branches
- Direct commits to main for small fixes
- Feature branches for significant changes

**Commit Conventions:**

- English titles, Japanese descriptions
- Conventional commit format: `feat:`, `fix:`, `chore:`, `docs:`
- Include co-authored-by for AI assistance
- Reference issue numbers when applicable

**Pre-commit Hooks:**

- ansible-lint validation
- YAML linting (yamllint)
- Markdown linting (markdownlint-cli2)
- Shell script linting (shellcheck)

## Domain Context

### Environment Setup Lifecycle

1. **Bootstrap Phase:**

   - Platform-specific scripts install package managers
   - Ansible is installed via package manager
   - SSH configuration for remote execution (Windows)

2. **Configuration Phase:**

   - Ansible playbooks execute roles in defined order
   - Dotfiles are linked from central repository
   - Tools are configured with default settings

3. **Maintenance Phase:**
   - Configuration updates via git pull + playbook re-run
   - Package updates via export commands → update default files → re-run
   - New tools added via role updates

### Platform-Specific Considerations

**macOS (Iapetus):**

- Homebrew-centric package management
- macOS defaults system for preferences
- Dock and Finder customization

**Windows (Khronos):**

- Two-phase setup: Windows host + WSL guest
- Remote execution via SSH (PowerShell remoting)
- Registry modifications for system settings
- PATH and environment variable configuration

**WSL (Khronos):**

- Shared filesystem with Windows host (/mnt/g)
- Google Drive mount via fstab
- Linux tools with Windows integration
- Homebrew Linuxbrew for package management

## Important Constraints

### Technical Constraints

- **Idempotency Required:** All tasks must be safely re-runnable
- **No User Interaction:** Scripts must run unattended (except initial password prompts)
- **Cross-Platform:** Roles must work on all supported platforms or gracefully skip
- **Version Locking:** Tool versions managed via mise configuration files
- **Private Variables:** Ansible role variables are private to prevent conflicts

### Platform Limitations

- **Windows:** Requires SSH server configuration before Ansible can connect
- **WSL:** Must configure /etc/wsl.conf before mounting Google Drive
- **macOS:** Some settings require logout/restart to take effect
- **Fish Shell:** PATH configuration differs from bash/zsh

### Security Constraints

- **No Secrets in Repo:** Passwords, tokens, keys managed separately
- **SSH Key Authentication:** Preferred over password authentication
- **Privilege Elevation:** Use sudo/become only when necessary
- **File Permissions:** Respect umask and ownership requirements

## External Dependencies

### Required Services

- **Google Drive:** Dotfiles repository storage at ~/GoogleDrive/share/dotfiles
- **GitHub:** Source repository hosting
- **Package Registries:** npm, PyPI, Homebrew taps, Scoop buckets

### Official Installation Scripts

- Homebrew: `https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh`
- Claude Code: `https://raw.githubusercontent.com/anthropics/claude-code/main/install/install.sh`
- Scoop: PowerShell remoting script

### MCP Servers (Claude Code)

- context7: Library documentation
- ccusage: Usage tracking
- cipher: Memory management
- scopecraft: Task management
- simone: Activity logging
- typescript: TypeScript LSP integration
- go: Go LSP integration

### System Requirements

- **macOS:** 10.15+ (Catalina or later)
- **Windows:** 10/11 with WSL2 enabled
- **WSL:** Ubuntu 20.04+ or Debian
- **Ansible:** 2.10+
- **Python:** 3.8+
