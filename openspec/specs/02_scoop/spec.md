# scoop Specification

## Purpose

The scoop role manages the Scoop package manager for Windows, including
installation, bucket configuration, package installation, and post-installation
configuration. This specification defines requirements for setting up Scoop and
managing Windows applications through command-line package management.

## Requirements

### Requirement: Scoop Installation

The scoop role SHALL install Scoop package manager if it is not already
available on Windows.

#### Scenario: Scoop not installed

- **GIVEN** Scoop is not available on the Windows system
- **WHEN** the Scoop installation check runs
- **THEN** Scoop SHALL be installed via the official installation script

#### Scenario: Scoop already installed

- **GIVEN** Scoop is already available on the Windows system
- **WHEN** the Scoop installation check runs
- **THEN** the installation step SHALL be skipped

### Requirement: Bucket Management

The scoop role SHALL add configured Scoop buckets to enable access to
additional packages.

#### Scenario: Add Scoop buckets

- **GIVEN** a list of Scoop buckets is configured
- **WHEN** the bucket addition task runs
- **THEN** all configured buckets SHALL be added to Scoop

#### Scenario: Bucket already added

- **GIVEN** a bucket is already added to Scoop
- **WHEN** the bucket addition task runs
- **THEN** the task SHALL be idempotent and not fail

### Requirement: Package Installation

The scoop role SHALL install packages from configured lists with support for
global installation.

#### Scenario: Install user-scoped packages

- **GIVEN** a package is configured without global flag
- **WHEN** the package installation task runs
- **THEN** the package SHALL be installed in user scope via `scoop install`

#### Scenario: Install global packages

- **GIVEN** a package is configured with global: true
- **WHEN** the package installation task runs
- **THEN** the package SHALL be installed globally via `scoop install --global`
- **AND** elevated privileges SHALL be used (become: true)

#### Scenario: Installation detection

- **GIVEN** a package installation command is executed
- **WHEN** the command completes
- **THEN** the task SHALL be marked as changed only if output contains "was
  installed successfully!"

#### Scenario: Installation error handling

- **GIVEN** a package installation fails
- **WHEN** the installation task runs
- **THEN** the error SHALL be ignored (ignore_errors: true)
- **AND** subsequent package installations SHALL continue

### Requirement: Package Configuration

The scoop role SHALL configure installed Scoop packages with post-installation
settings.

#### Scenario: Configure packages

- **GIVEN** Scoop packages are installed
- **WHEN** the package configuration task runs
- **THEN** post-installation configurations SHALL be applied to relevant packages

### Requirement: Task Execution Order

The scoop role SHALL execute tasks in the correct order to ensure dependencies
are met.

#### Scenario: Sequential execution

- **GIVEN** the scoop role is executing
- **WHEN** tasks are processed
- **THEN** Scoop installation SHALL complete before bucket addition
- **AND** bucket addition SHALL complete before package installation
- **AND** package installation SHALL complete before package configuration

### Requirement: Windows PowerShell Integration

The scoop role SHALL use Windows PowerShell for Scoop operations.

#### Scenario: Use win_shell module

- **GIVEN** any Scoop command is being executed
- **WHEN** the task runs
- **THEN** ansible.windows.win_shell module SHALL be used for command execution

### Requirement: Documentation

The project documentation SHALL include commands to export and update Scoop
package lists.

#### Scenario: Export Scoop packages

- **GIVEN** Scoop packages are installed
- **WHEN** a developer wants to update the package list
- **THEN** documentation SHALL provide PowerShell command to export packages
  in the correct YAML format
- **AND** the command SHALL handle global packages appropriately

### Requirement: Idempotency

The scoop role SHALL be idempotent and safe to run multiple times.

#### Scenario: Re-run on existing installation

- **GIVEN** Scoop and packages are already installed
- **WHEN** the scoop role executes again
- **THEN** Scoop installation SHALL be skipped
- **AND** buckets SHALL not be duplicated
- **AND** already installed packages SHALL be detected

### Requirement: Platform Restriction

The scoop role SHALL only execute on Windows systems.

#### Scenario: Windows platform check

- **GIVEN** the scoop role is included in a playbook
- **WHEN** the playbook runs on a non-Windows system
- **THEN** the role tasks SHALL be skipped or fail gracefully
