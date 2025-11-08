# khronos-windows Playbook Specification

## Purpose

The khronos-windows playbook orchestrates complete Windows and WSL system setup through two separate plays that configure the Windows host and WSL environment independently. This specification defines requirements for multi-play execution, variable handling, remote Windows connection, and role integration to ensure reproducible Windows development environments.

## Requirements

### Requirement: Multi-Play Structure

The playbook SHALL contain two distinct plays for Windows host and WSL environment setup.

#### Scenario: Windows host play executes first

- **GIVEN** the playbook is invoked
- **WHEN** play execution begins
- **THEN** the Windows host play (targeting 'khronos') SHALL execute first
- **AND** the WSL play (targeting 'local') SHALL execute second

#### Scenario: Independent play execution

- **GIVEN** both plays are in the playbook
- **WHEN** each play executes
- **THEN** variables and configurations from one play SHALL NOT affect the other
- **AND** each play SHALL have its own pre_tasks, tasks, and handlers

### Requirement: Windows Host Variable Initialization

The Windows host play SHALL initialize variables for remote Windows connection and platform-specific paths.

#### Scenario: Windows credentials prompted

- **GIVEN** the Windows host play execution begins
- **WHEN** vars_prompt is processed
- **THEN** the user SHALL be prompted for Windows username (not private)
- **AND** the user SHALL be prompted for Windows password (private)
- **AND** credentials SHALL be stored in `win_username` and `win_password` variables

#### Scenario: Ansible connection configured

- **GIVEN** the Windows host play is executing
- **WHEN** connection variables are evaluated
- **THEN** the following SHALL be configured:
  - `ansible_user` and `ansible_password` from prompts
  - `ansible_become_method` as 'runas'
  - `ansible_become_user` from Windows username
  - `ansible_connection` as 'ssh'
  - `ansible_shell_type` as 'powershell'
  - `ansible_python_interpreter` as '/home/linuxbrew/.linuxbrew/bin/python3'

#### Scenario: Windows-specific paths configured

- **GIVEN** the Windows host play is executing
- **WHEN** path variables are evaluated
- **THEN** the following SHALL be defined:
  - `my_home` as 'C:\Users\{{ user }}'
  - `my_xdg_cache_home` as 'C:\Users\{{ user }}\AppData\Roaming'
  - `my_xdg_config_home` as 'C:\Users\{{ user }}\AppData\Local'
  - `my_xdg_data_home` as 'C:\Users\{{ user }}\AppData\Local'
  - `my_google_drive` as 'G:\マイドライブ'

#### Scenario: Common variables loaded for Windows

- **GIVEN** the Windows host play is executing
- **WHEN** pre_tasks are processed
- **THEN** the `common.yaml` variables file SHALL be loaded with the 'always' tag
- **AND** the variables SHALL be available to Windows-specific tasks

### Requirement: Windows Host Role Execution Order

The Windows host play SHALL execute roles in a specific sequence.

#### Scenario: Windows role sequence

- **GIVEN** the Windows host play is executing
- **WHEN** the tasks phase begins
- **THEN** roles SHALL execute in the following order:
  1. os_windows (Windows system configuration)
  2. winget (Windows package manager)
  3. scoop (Windows package manager)
  4. home (Windows directory structure and dotfiles)
  5. claude (AI assistant configuration for Windows)

### Requirement: Winget Package Management

The Windows host play SHALL configure winget with a comprehensive package list.

#### Scenario: Winget packages installed

- **GIVEN** the winget role is being imported
- **WHEN** package list is evaluated
- **THEN** at least 50 packages SHALL be defined in `winget_packages`
- **AND** packages SHALL include development tools, utilities, and applications
- **AND** each package SHALL specify at minimum a 'name' attribute
- **AND** packages MAY specify optional attributes like 'list_id', 'become', or 'force'

### Requirement: Scoop Package Management

The Windows host play SHALL configure scoop with buckets and packages.

#### Scenario: Scoop buckets configured

- **GIVEN** the scoop role is being imported
- **WHEN** bucket configuration is evaluated
- **THEN** the `scoop_buckets` SHALL include:
  - main
  - extras

#### Scenario: Scoop packages installed

- **GIVEN** the scoop role is being imported
- **WHEN** package list is evaluated
- **THEN** `scoop_packages` SHALL include development tools and utilities
- **AND** packages SHALL include version control, editors, and language runtimes

### Requirement: Windows Home Role Configuration

The Windows host play SHALL configure the home role for Windows-specific tasks.

#### Scenario: Windows-specific home tasks loaded

- **GIVEN** the home role is being imported in the Windows play
- **WHEN** the `tasks_from` parameter is evaluated
- **THEN** the role SHALL execute tasks from `windows.yaml`

#### Scenario: Windows directories created

- **GIVEN** the home role is executing in the Windows play
- **WHEN** directory creation tasks run
- **THEN** the following directories SHALL be created:
  - Applications
  - Archives
  - Projects

#### Scenario: Windows git configuration deployed

- **GIVEN** the home role is executing in the Windows play
- **WHEN** git configuration tasks run
- **THEN** the following files SHALL be deployed:
  - `home_my_git_config` from `dotfiles/git/.gitconfig-prv`
  - `home_my_git_config_local` from `dotfiles/git/.gitconfig-prv.win.local`
  - `home_my_git_ignore` from `dotfiles/git/ignore`

### Requirement: Windows Claude Configuration

The Windows host play SHALL configure claude for Windows with platform-specific tasks.

#### Scenario: Windows claude tasks loaded

- **GIVEN** the claude role is being imported in the Windows play
- **WHEN** the `tasks_from` parameter is evaluated
- **THEN** the role SHALL execute tasks from `windows.yaml`

### Requirement: WSL Variable Initialization

The WSL play SHALL initialize variables for local WSL environment.

#### Scenario: WSL credentials prompted

- **GIVEN** the WSL play execution begins
- **WHEN** vars_prompt is processed
- **THEN** the user SHALL be prompted for WSL user password (private)
- **AND** the password SHALL be stored in the `my_password` variable

#### Scenario: WSL-specific variables configured

- **GIVEN** the WSL play is executing
- **WHEN** variables are evaluated
- **THEN** the following SHALL be configured:
  - `ansible_python_interpreter` as '/home/linuxbrew/.linuxbrew/bin/python3'
  - `my_editor` and `my_visual` as 'nvim'
  - `my_temporary_home` as '/tmp'
  - `my_google_drive` as '/mnt/g'

#### Scenario: Common variables loaded for WSL

- **GIVEN** the WSL play is executing
- **WHEN** pre_tasks are processed
- **THEN** the `common.yaml` variables file SHALL be loaded with the 'always' tag
- **AND** the variables SHALL be available to WSL-specific tasks

### Requirement: WSL Role Execution Order

The WSL play SHALL execute roles in a specific sequence.

#### Scenario: WSL role sequence

- **GIVEN** the WSL play is executing
- **WHEN** the tasks phase begins
- **THEN** roles SHALL execute in the following order:
  1. wsl (WSL-specific configuration)
  2. apt (Ubuntu package management)
  3. homebrew (Linux Homebrew)
  4. home (WSL directory structure and dotfiles)
  5. fish (shell configuration)
  6. mise (tool version management)
  7. nvim (editor configuration)
  8. claude (AI assistant configuration)

### Requirement: APT Package Management

The WSL play SHALL configure apt with repositories, keys, and packages.

#### Scenario: APT keys configured

- **GIVEN** the apt role is being imported
- **WHEN** key configuration is evaluated
- **THEN** `apt_keys` SHALL include:
  - Google Chrome signing key
  - Docker signing key
- **AND** each key SHALL specify a 'url' and 'filename'

#### Scenario: APT repositories configured

- **GIVEN** the apt role is being imported
- **WHEN** repository configuration is evaluated
- **THEN** `apt_repositories` SHALL include:
  - Google Chrome repository
  - Docker repository
- **AND** each repository SHALL specify a 'repo' string and 'filename'

#### Scenario: APT packages installed

- **GIVEN** the apt role is being imported
- **WHEN** package list is evaluated
- **THEN** `apt_packages` SHALL include:
  - google-chrome-stable
  - Build dependencies for Erlang development
  - Docker components (docker-ce, docker-ce-cli, containerd.io, buildx, compose)

### Requirement: WSL Homebrew Configuration

The WSL play SHALL configure homebrew with a WSL-specific Brewfile.

#### Scenario: WSL Brewfile path configured

- **GIVEN** the homebrew role is being imported in the WSL play
- **WHEN** role variables are set
- **THEN** the `homebrew_brewfile` variable SHALL be set to `playbook_dir/files/homebrew/Brewfile-wsl`

### Requirement: WSL Home Role Configuration

The WSL play SHALL configure the home role for WSL-specific tasks.

#### Scenario: WSL-specific home tasks loaded

- **GIVEN** the home role is being imported in the WSL play
- **WHEN** the `tasks_from` parameter is evaluated
- **THEN** the role SHALL execute tasks from `windows.wsl.yaml`

#### Scenario: WSL host home configured

- **GIVEN** the home role is executing in the WSL play
- **WHEN** home directory variables are evaluated
- **THEN** `home_host_home` SHALL be set to '/mnt/c/Users/{{ home | basename }}'

#### Scenario: WSL directories created

- **GIVEN** the home role is executing in the WSL play
- **WHEN** directory creation tasks run
- **THEN** the 'Projects' directory SHALL be created

#### Scenario: WSL git configuration deployed

- **GIVEN** the home role is executing in the WSL play
- **WHEN** git configuration tasks run
- **THEN** the following files SHALL be deployed:
  - `home_my_git_config` from `dotfiles/git/.gitconfig-prv`
  - `home_my_git_config_local` from `dotfiles/git/.gitconfig-prv.wsl.local`
  - `home_my_git_ignore` from `dotfiles/git/ignore`

#### Scenario: WSL Ghostty configuration deployed

- **GIVEN** the home role is executing in the WSL play
- **WHEN** terminal configuration tasks run
- **THEN** `home_my_ghostty_config` SHALL be deployed from `dotfiles/ghostty/config`

### Requirement: WSL Fish Shell Configuration

The WSL play SHALL configure the fish role with WSL-specific configuration.

#### Scenario: WSL fish configuration loaded

- **GIVEN** the fish role is being imported in the WSL play
- **WHEN** the configuration file is selected
- **THEN** the `fish_shell_config` SHALL be set to `config-wsl.fish`

### Requirement: WSL Mise Tool Configuration

The WSL play SHALL configure the mise role with WSL-specific tool versions.

#### Scenario: WSL mise configuration loaded

- **GIVEN** the mise role is being imported in the WSL play
- **WHEN** configuration variables are set
- **THEN** the `mise_config` SHALL be set to `dotfiles/mise/config-wsl.toml`

#### Scenario: WSL default package files configured

- **GIVEN** the mise role is being imported in the WSL play
- **WHEN** package list variables are set
- **THEN** the same package files as macOS SHALL be configured from `dotfiles/mise/`

### Requirement: WSL Handler Configuration

The WSL play SHALL import WSL-specific handlers.

#### Scenario: WSL handlers available

- **GIVEN** the WSL play is executing
- **WHEN** handlers are configured
- **THEN** the handlers from `handlers/handlers_wsl.yaml` SHALL be imported
- **AND** the handlers SHALL be available to all WSL-specific roles

### Requirement: Host Targeting

The playbook SHALL target different hosts for each play.

#### Scenario: Windows host targeting

- **GIVEN** the Windows host play is invoked
- **WHEN** host targeting is evaluated
- **THEN** the play SHALL target hosts in the 'khronos' group
- **AND** tasks SHALL execute on the remote Windows host via SSH

#### Scenario: WSL local targeting

- **GIVEN** the WSL play is invoked
- **WHEN** host targeting is evaluated
- **THEN** the play SHALL target hosts in the 'local' group
- **AND** tasks SHALL execute on the local WSL environment

### Requirement: Play Independence

Each play SHALL maintain separate execution contexts.

#### Scenario: Variable isolation

- **GIVEN** both plays are executing
- **WHEN** variables are accessed
- **THEN** Windows play variables SHALL NOT be accessible in the WSL play
- **AND** WSL play variables SHALL NOT be accessible in the Windows play
- **AND** only `common.yaml` variables SHALL be shared

### Requirement: Idempotency

The playbook SHALL be idempotent when executed multiple times.

#### Scenario: Repeated execution of Windows play

- **GIVEN** the Windows play has been executed successfully
- **WHEN** the playbook is executed again without changes
- **THEN** all Windows tasks SHALL report no changes
- **AND** the Windows system state SHALL remain consistent

#### Scenario: Repeated execution of WSL play

- **GIVEN** the WSL play has been executed successfully
- **WHEN** the playbook is executed again without changes
- **THEN** all WSL tasks SHALL report no changes
- **AND** the WSL system state SHALL remain consistent

### Requirement: Error Handling

The playbook SHALL handle failures appropriately in each play.

#### Scenario: Windows play failure

- **GIVEN** a critical role fails in the Windows play
- **WHEN** the error is encountered
- **THEN** the Windows play SHALL stop execution
- **AND** an error message SHALL be displayed
- **AND** the WSL play SHALL still execute (plays are independent)

#### Scenario: WSL play failure

- **GIVEN** a critical role fails in the WSL play
- **WHEN** the error is encountered
- **THEN** the WSL play SHALL stop execution
- **AND** an error message SHALL be displayed
- **AND** the Windows play SHALL have completed (if it ran first)
