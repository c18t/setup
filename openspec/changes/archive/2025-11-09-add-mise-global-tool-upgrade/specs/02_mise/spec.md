# mise Role - Global Tool Upgrade

## ADDED Requirements

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
