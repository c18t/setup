# iapetus-macos Playbook Specification

## Purpose

The iapetus-macos playbook orchestrates complete macOS system setup by
sequentially executing roles that configure the operating system, install
development tools, and establish user environments. This specification defines
requirements for the playbook's execution flow, variable handling, and role
integration to ensure reproducible macOS development environments.

## Requirements

### Requirement: Variable Initialization

The playbook SHALL initialize common variables before executing any roles.

#### Scenario: Common variables loaded

- **GIVEN** the playbook is executed
- **WHEN** the pre_tasks phase begins
- **THEN** the `common.yaml` variables file SHALL be loaded with the 'always' tag
- **AND** the variables SHALL be available to all subsequent tasks

#### Scenario: Platform-specific variables set

- **GIVEN** the playbook is executing on macOS
- **WHEN** playbook variables are evaluated
- **THEN** the following variables SHALL be defined:
  - `my_editor` and `my_visual` as the preferred editor
  - `my_temporary_home` as the temporary directory location
  - `my_google_drive` as the Google Drive mount point

#### Scenario: User password prompted

- **GIVEN** the playbook execution begins
- **WHEN** vars_prompt is processed
- **THEN** the user SHALL be prompted for their password with private input
- **AND** the password SHALL be stored in the `my_password` variable

### Requirement: Role Execution Order

The playbook SHALL execute roles in a specific sequence to ensure proper
dependency resolution.

#### Scenario: Sequential role execution

- **GIVEN** the playbook is executing
- **WHEN** the tasks phase begins
- **THEN** roles SHALL execute in the following order:
  1. os_macos (system configuration)
  2. homebrew (package management)
  3. home (directory structure and dotfiles)
  4. fish (shell configuration)
  5. mise (tool version management)
  6. nvim (editor configuration)
  7. claude (AI assistant configuration)

#### Scenario: Role dependencies satisfied

- **GIVEN** a role requires resources from a previous role
- **WHEN** the role executes
- **THEN** all prerequisite roles SHALL have completed successfully
- **AND** required resources SHALL be available

### Requirement: Homebrew Configuration

The playbook SHALL configure the homebrew role with a macOS-specific Brewfile.

#### Scenario: Brewfile path configured

- **GIVEN** the homebrew role is being imported
- **WHEN** role variables are set
- **THEN** the `homebrew_brewfile` variable SHALL default to `playbook_dir/files/homebrew/Brewfile-mac`
- **AND** the variable MAY be overridden by setting `my_homebrew_brewfile`

### Requirement: Home Role Platform Integration

The playbook SHALL configure the home role for macOS-specific directory
structures and dotfiles.

#### Scenario: macOS-specific tasks loaded

- **GIVEN** the home role is being imported
- **WHEN** the `tasks_from` parameter is evaluated
- **THEN** the role SHALL execute tasks from `macos.yaml`

#### Scenario: Standard directories created

- **GIVEN** the home role is executing
- **WHEN** directory creation tasks run
- **THEN** the following directories SHALL be created:
  - Archives
  - Projects

#### Scenario: Git configuration deployed

- **GIVEN** the home role is executing
- **WHEN** git configuration tasks run
- **THEN** the following files SHALL be deployed:
  - `home_my_git_config` from `dotfiles/git/.gitconfig-prv`
  - `home_my_git_config_local` from `dotfiles/git/.gitconfig-prv.mac.local`
  - `home_my_git_ignore` from `dotfiles/git/ignore`

#### Scenario: Ghostty configuration deployed

- **GIVEN** the home role is executing
- **WHEN** terminal configuration tasks run
- **THEN** `home_my_ghostty_config` SHALL be deployed from `dotfiles/ghostty/config`

### Requirement: Fish Shell Configuration

The playbook SHALL configure the fish role with macOS-specific configuration.

#### Scenario: macOS fish configuration loaded

- **GIVEN** the fish role is being imported
- **WHEN** the configuration file is selected
- **THEN** the `fish_shell_config` SHALL be set to `config-mac.fish`

### Requirement: Mise Tool Configuration

The playbook SHALL configure the mise role with macOS-specific tool versions
and package lists.

#### Scenario: macOS mise configuration loaded

- **GIVEN** the mise role is being imported
- **WHEN** configuration variables are set
- **THEN** the `mise_config` SHALL be set to `dotfiles/mise/config-macos.toml`

#### Scenario: Default package files configured

- **GIVEN** the mise role is being imported
- **WHEN** package list variables are set
- **THEN** the following files SHALL be configured:
  - `mise_default_go_packages` from `dotfiles/mise/.default-go-packages`
  - `mise_default_python_packages` from `dotfiles/mise/.default-python-packages`
  - `mise_default_npm_packages` from `dotfiles/mise/.default-npm-packages`
  - `mise_default_gems` from `dotfiles/mise/.default-gems`
  - `mise_default_mix_commands` from `dotfiles/mise/.default-mix-commands`
  - `mise_default_perl_modules` from `dotfiles/mise/.default-perl-modules`
  - `mise_default_pnpm_packages` from `dotfiles/mise/.default-pnpm-packages`
  - `mise_default_uv_tools` from `dotfiles/mise/.default-uv-tools`

### Requirement: Claude Configuration

The playbook SHALL configure the claude role with user-specific settings and resources.

#### Scenario: Claude resources deployed

- **GIVEN** the claude role is being imported
- **WHEN** configuration variables are set
- **THEN** the following resources SHALL be deployed:
  - `claude_settings` from `dotfiles/claude/settings.json`
  - `claude_md` from `dotfiles/claude/CLAUDE.md`
  - `claude_commands` from `dotfiles/claude/commands`
  - `claude_agents` from `dotfiles/claude/agents`
  - `claude_skills` from `dotfiles/claude/skills`

### Requirement: Handler Configuration

The playbook SHALL import macOS-specific handlers for use by any role.

#### Scenario: macOS handlers available

- **GIVEN** the playbook is executing
- **WHEN** handlers are configured
- **THEN** the handlers from `handlers/handlers_macos.yaml` SHALL be imported
- **AND** the handlers SHALL be available to all roles

### Requirement: Host Targeting

The playbook SHALL execute on the local host only.

#### Scenario: Local execution

- **GIVEN** the playbook is invoked
- **WHEN** host targeting is evaluated
- **THEN** the playbook SHALL target hosts in the 'local' group
- **AND** tasks SHALL execute on the local machine

### Requirement: Idempotency

The playbook SHALL be idempotent when executed multiple times.

#### Scenario: Repeated execution

- **GIVEN** the playbook has been executed successfully
- **WHEN** the playbook is executed again without changes
- **THEN** all tasks SHALL report no changes
- **AND** the system state SHALL remain consistent

### Requirement: Error Handling

The playbook SHALL fail fast when critical errors occur.

#### Scenario: Critical role failure

- **GIVEN** a critical role fails during execution
- **WHEN** the error is encountered
- **THEN** the playbook SHALL stop execution
- **AND** an error message SHALL be displayed
- **AND** subsequent roles SHALL not execute
