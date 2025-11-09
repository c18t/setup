# mise Specification

## Purpose

The mise role manages development tool version management and global tool
installation. This specification defines requirements for installing global
tools via pnpm and uv package managers, ensuring reproducible development
environments across macOS, Windows, and WSL platforms.

## Requirements

### Requirement: Global Tool Installation via pnpm

The mise role SHALL install global tools via pnpm when a
`.default-pnpm-packages` file is configured.

#### Scenario: pnpm global packages installed

- **GIVEN** a `.default-pnpm-packages` file exists with package names
- **WHEN** the mise role executes the global tool installation task
- **THEN** all packages listed in `.default-pnpm-packages` SHALL be installed
  globally via `pnpm install -g`

#### Scenario: pnpm not available

- **GIVEN** pnpm is not installed or not available in PATH
- **WHEN** the mise role attempts to install pnpm global packages
- **THEN** the task SHALL skip pnpm package installation without failing

#### Scenario: Empty or missing pnpm packages file

- **GIVEN** the `.default-pnpm-packages` file is empty or does not exist
- **WHEN** the mise role executes
- **THEN** no pnpm global packages SHALL be installed

### Requirement: Global Tool Installation via uv

The mise role SHALL install global tools via uv when a `.default-uv-tools`
file is configured.

#### Scenario: uv tools installed

- **GIVEN** a `.default-uv-tools` file exists with tool names
- **WHEN** the mise role executes the global tool installation task
- **THEN** all tools listed in `.default-uv-tools` SHALL be installed via
  `uv tool install`

#### Scenario: uv not available

- **GIVEN** uv is not installed or not available in PATH
- **WHEN** the mise role attempts to install uv tools
- **THEN** the task SHALL skip uv tool installation without failing

#### Scenario: Empty or missing uv tools file

- **GIVEN** the `.default-uv-tools` file is empty or does not exist
- **WHEN** the mise role executes
- **THEN** no uv tools SHALL be installed

### Requirement: Platform Support

The global tool installation tasks SHALL execute on all platforms where the
mise role is used.

#### Scenario: Cross-platform execution

- **GIVEN** the mise role is executed on macOS, Windows, or WSL
- **WHEN** global tool installation tasks run
- **THEN** the tasks SHALL complete successfully on all platforms

### Requirement: Execution Order

The global tool installation task SHALL execute after mise tool installation
is complete.

#### Scenario: Sequential execution

- **GIVEN** the mise role is executing
- **WHEN** tasks are processed
- **THEN** mise installation (task 10) SHALL complete before global tool
  installation (task 20) begins

### Requirement: Documentation

The project documentation SHALL include commands to export and update global
tool lists.

#### Scenario: Export pnpm global packages

- **GIVEN** pnpm global packages are installed
- **WHEN** a developer wants to update the package list
- **THEN** documentation SHALL provide the command to list global packages in
  the correct format

#### Scenario: Export uv tools

- **GIVEN** uv tools are installed
- **WHEN** a developer wants to update the tool list
- **THEN** documentation SHALL provide the command to list installed tools in
  the correct format

### Requirement: Global Tool Upgrade via pnpm

The mise role SHALL upgrade existing pnpm global packages to their latest
versions.

#### Scenario: pnpm global packages upgraded

- **GIVEN** pnpm global packages are already installed
- **WHEN** the mise role executes the global tool upgrade task
- **THEN** all packages listed in `.default-pnpm-packages` SHALL be upgraded to
  their latest versions via `pnpm update -g`

#### Scenario: pnpm not available for upgrade

- **GIVEN** pnpm is not installed or not available in PATH
- **WHEN** the mise role attempts to upgrade pnpm global packages
- **THEN** the task SHALL skip pnpm package upgrade without failing

#### Scenario: Empty or missing pnpm packages file for upgrade

- **GIVEN** the `.default-pnpm-packages` file is empty or does not exist
- **WHEN** the mise role executes
- **THEN** no pnpm global package upgrades SHALL be attempted

### Requirement: Global Tool Upgrade via uv

The mise role SHALL upgrade existing uv tools to their latest versions.

#### Scenario: uv tools upgraded

- **GIVEN** uv tools are already installed
- **WHEN** the mise role executes the global tool upgrade task
- **THEN** all installed uv tools SHALL be upgraded to their latest versions via
  `uv tool upgrade --all`

#### Scenario: uv not available for upgrade

- **GIVEN** uv is not installed or not available in PATH
- **WHEN** the mise role attempts to upgrade uv tools
- **THEN** the task SHALL skip uv tool upgrade without failing

#### Scenario: No uv tools installed

- **GIVEN** no uv tools are currently installed
- **WHEN** the mise role attempts to upgrade uv tools
- **THEN** the upgrade task SHALL complete without errors

### Requirement: Upgrade Execution Order

The global tool upgrade tasks SHALL execute after package manager availability
check but before installing new packages.

#### Scenario: Sequential execution of upgrade then install

- **GIVEN** the mise role is executing
- **WHEN** global tool tasks are processed
- **THEN** upgrade tasks (update existing tools) SHALL execute after package
  manager check and before installation tasks (install new tools from
  `.default-*-packages`)
