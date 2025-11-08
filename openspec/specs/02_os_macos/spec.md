# os_macos Specification

## Purpose

The os_macos role manages macOS system preferences and settings. This specification defines requirements for configuring Dock behavior, Finder preferences, and other macOS-specific system settings through the macOS defaults system.

## Requirements

### Requirement: Dock Configuration

The os_macos role SHALL configure macOS Dock preferences according to user specifications.

#### Scenario: Enable Dock autohide

- **GIVEN** Dock configuration is being applied
- **WHEN** the Dock settings task runs
- **THEN** Dock autohide SHALL be enabled (value: 1)
- **AND** the Dock SHALL be restarted to apply changes

#### Scenario: Set Dock minimize effect

- **GIVEN** Dock configuration is being applied
- **WHEN** the minimize effect setting task runs
- **THEN** the minimize effect SHALL be set to "genie"
- **AND** the Dock SHALL be restarted to apply changes

#### Scenario: Configure Dock tile size

- **GIVEN** Dock configuration is being applied
- **WHEN** the tile size setting task runs
- **THEN** the tile size SHALL be set to the value in `os_macos_dock_tilesize`
- **AND** the value SHALL be set as a float type
- **AND** the Dock SHALL be restarted to apply changes

#### Scenario: Dock restart notification

- **GIVEN** any Dock setting is changed
- **WHEN** the setting task completes
- **THEN** the RestartDock handler SHALL be notified
- **AND** the Dock SHALL be restarted once after all changes

### Requirement: Finder Configuration

The os_macos role SHALL configure macOS Finder preferences.

#### Scenario: Configure Finder settings

- **GIVEN** Finder configuration is being applied
- **WHEN** the Finder settings task runs
- **THEN** Finder preferences SHALL be set via osx_defaults module

### Requirement: Settings Persistence

The os_macos role SHALL use the macOS defaults system to ensure settings persist across system restarts.

#### Scenario: Use osx_defaults module

- **GIVEN** macOS settings are being configured
- **WHEN** any setting task runs
- **THEN** the community.general.osx_defaults module SHALL be used
- **AND** settings SHALL specify the correct domain (e.g., com.apple.dock)

#### Scenario: Type-safe value setting

- **GIVEN** a macOS setting is being configured
- **WHEN** the value is set
- **THEN** the correct type SHALL be specified (int, string, float, etc.)
- **AND** the value SHALL be properly formatted for that type

### Requirement: Handler Implementation

The os_macos role SHALL implement handlers to apply settings that require service restarts.

#### Scenario: RestartDock handler

- **GIVEN** Dock settings have been changed
- **WHEN** the RestartDock handler is triggered
- **THEN** the Dock process SHALL be restarted
- **AND** the handler SHALL only run once even if notified multiple times

### Requirement: Idempotency

The os_macos role SHALL be idempotent and safe to run multiple times.

#### Scenario: Re-run on existing settings

- **GIVEN** macOS settings are already configured correctly
- **WHEN** the os_macos role executes again
- **THEN** no changes SHALL be made to existing correct settings
- **AND** services SHALL not be restarted unnecessarily

### Requirement: Platform Restriction

The os_macos role SHALL only execute on macOS systems.

#### Scenario: macOS platform check

- **GIVEN** the os_macos role is included in a playbook
- **WHEN** the playbook runs on a non-macOS system
- **THEN** the role tasks SHALL be skipped or fail gracefully

### Requirement: Task Organization

The os_macos role SHALL organize settings into logical task files.

#### Scenario: Separate task files for components

- **GIVEN** the os_macos role is executing
- **WHEN** tasks are loaded
- **THEN** Dock settings SHALL be in 10-dock.yaml
- **AND** Finder settings SHALL be in 11-finder.yaml
- **AND** additional component settings SHALL be in separate numbered files

### Requirement: Variable Configuration

The os_macos role SHALL support variable-driven configuration for customizable settings.

#### Scenario: Configurable values

- **GIVEN** a setting has a configurable value (e.g., dock tile size)
- **WHEN** the setting is applied
- **THEN** the value SHALL be read from a role variable
- **AND** the variable SHALL have a default value in defaults/main.yaml
