# fish Specification

## Purpose

The fish role manages the installation and configuration of the Fish shell, including setting it as the default login shell, installing the Fisher plugin manager, and setting up platform-specific plugins and environment variables. This specification defines requirements for Fish shell setup across macOS, Windows, and WSL environments.

## Requirements

### Requirement: Shell Registration

The fish role SHALL register Fish shell in the system's list of valid shells.

#### Scenario: Add Fish to /etc/shells

- **GIVEN** Fish shell is installed but not registered
- **WHEN** the shell registration task runs
- **THEN** the Fish shell path SHALL be added to /etc/shells

#### Scenario: Fish already registered

- **GIVEN** Fish shell is already in /etc/shells
- **WHEN** the shell registration task runs
- **THEN** the task SHALL be idempotent and not duplicate the entry

### Requirement: Default Shell Configuration

The fish role SHALL set Fish as the user's default login shell.

#### Scenario: Change login shell to Fish

- **GIVEN** the user's login shell is not Fish
- **WHEN** the login shell change task executes
- **THEN** Fish SHALL be set as the user's default shell

#### Scenario: Verify shell change

- **GIVEN** the login shell change was requested
- **WHEN** the task completes
- **THEN** the user's shell SHALL be updated in the system

### Requirement: Fisher Plugin Manager Installation

The fish role SHALL install and configure the Fisher plugin manager.

#### Scenario: Fisher not installed

- **GIVEN** Fisher is not available in Fish
- **WHEN** the Fisher installation check runs
- **THEN** Fisher SHALL be installed via the official installation script

#### Scenario: Fisher already installed

- **GIVEN** Fisher is available in Fish
- **WHEN** the Fisher installation check runs
- **THEN** the installation SHALL be skipped

#### Scenario: Fisher self-update

- **GIVEN** Fisher is installed
- **WHEN** the Fisher configuration task runs
- **THEN** Fisher itself SHALL be updated via `fisher update jorgebucaran/fisher`

### Requirement: Platform-Specific Plugin Configuration

The fish role SHALL install platform-specific Fisher plugins based on the operating system.

#### Scenario: Base plugins for all platforms

- **GIVEN** Fisher is installed
- **WHEN** the plugin installation runs
- **THEN** base plugins from fisher-my-setup SHALL be installed

#### Scenario: macOS-specific plugins

- **GIVEN** the role is running on macOS
- **WHEN** the plugin installation runs
- **THEN** plugins from fisher-my-setup-mac SHALL be installed in addition to base plugins

#### Scenario: WSL-specific plugins

- **GIVEN** the role is running on WSL (cmd.exe is available)
- **WHEN** the plugin installation runs
- **THEN** plugins from fisher-my-setup-wsl SHALL be installed in addition to base plugins

#### Scenario: Plugin list assembly

- **GIVEN** platform-specific plugin directories are configured
- **WHEN** the fish_plugins file is assembled
- **THEN** all applicable plugin directories SHALL be listed in the correct order

### Requirement: Resource and Configuration Setup

The fish role SHALL set up Fish shell configuration files and resources.

#### Scenario: Deploy Fish resources

- **GIVEN** Fish configuration templates exist
- **WHEN** the resource setup task runs
- **THEN** all configuration files SHALL be deployed to the appropriate locations

#### Scenario: Set environment variables

- **GIVEN** Fish shell is configured
- **WHEN** the environment variable task runs
- **THEN** Fish-specific environment variables SHALL be set

### Requirement: GraphViz Integration

The fish role SHALL configure GraphViz integration for Fish shell.

#### Scenario: Setup GraphViz

- **GIVEN** GraphViz configuration is needed
- **WHEN** the GraphViz setup task runs
- **THEN** GraphViz integration SHALL be configured for Fish shell

### Requirement: Execution Order

The fish role SHALL execute configuration tasks in the correct order.

#### Scenario: Sequential setup

- **GIVEN** the fish role is executing
- **WHEN** tasks are processed
- **THEN** Fish SHALL be added to shells before changing login shell
- **AND** login shell change SHALL complete before resource setup
- **AND** resource setup SHALL complete before environment variables
- **AND** environment variables SHALL be set before Fisher setup
- **AND** Fisher setup SHALL complete before GraphViz configuration

### Requirement: Temporary Directory Handling

The fish role SHALL correctly resolve temporary directories including symbolic links.

#### Scenario: Resolve temporary home

- **GIVEN** a temporary home directory is configured
- **WHEN** Fisher plugin files are copied
- **THEN** symbolic links SHALL be resolved to their actual targets
- **AND** files SHALL be copied to the resolved location

### Requirement: Shell Environment

The fish role SHALL ensure proper SHELL environment variable during Fisher operations.

#### Scenario: Fisher operations with SHELL environment

- **GIVEN** Fisher operations are running
- **WHEN** Fisher update commands execute
- **THEN** the SHELL environment variable SHALL be set to the Fish shell path
