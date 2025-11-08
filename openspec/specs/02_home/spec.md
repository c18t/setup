# home Specification

## Purpose

The home role manages home directory structure and dotfiles setup through symbolic links. This specification defines requirements for creating necessary directories and linking configuration files from a dotfiles repository to their target locations, with platform-specific support for macOS, Windows, and WSL.

## Requirements

### Requirement: Platform-Specific Entry Points

The home role SHALL provide separate entry points for different platforms and fail if called without specifying the platform.

#### Scenario: Direct main.yaml call fails

- **GIVEN** the home role is included without tasks_from parameter
- **WHEN** the role executes
- **THEN** the role SHALL fail with a message requiring explicit entry point specification

#### Scenario: macOS entry point

- **GIVEN** the home role is included with tasks_from: macos.yaml
- **WHEN** the role executes on macOS
- **THEN** macOS-specific home directory tasks SHALL run

#### Scenario: Windows entry point

- **GIVEN** the home role is included with tasks_from: windows.yaml
- **WHEN** the role executes on Windows
- **THEN** Windows-specific home directory tasks SHALL run

#### Scenario: WSL entry point

- **GIVEN** the home role is included with tasks_from: windows.wsl.yaml
- **WHEN** the role executes on WSL
- **THEN** WSL-specific home directory tasks SHALL run

### Requirement: Directory Creation

The home role SHALL create all necessary directories for user configuration and data.

#### Scenario: Create standard directories

- **GIVEN** a list of required directories is configured
- **WHEN** the directory creation task runs
- **THEN** all directories SHALL be created with appropriate permissions
- **AND** symbolic links SHALL be followed to their targets

#### Scenario: Permission settings

- **GIVEN** directories are being created
- **WHEN** the creation task executes
- **THEN** directories SHALL have mode u=rwx,g=rx,o=rx

#### Scenario: Platform-specific directories

- **GIVEN** the role is running on a specific platform
- **WHEN** the directory creation task runs
- **THEN** platform-specific directory lists SHALL be used

### Requirement: Symbolic Link Management

The home role SHALL create symbolic links from dotfiles repository to target locations in the home directory.

#### Scenario: Create symbolic links

- **GIVEN** a list of symbolic link mappings is configured
- **WHEN** the link creation task runs
- **THEN** all links SHALL be created from source to destination

#### Scenario: Validate link sources

- **GIVEN** symbolic links are to be created
- **WHEN** the validation task runs
- **THEN** all source paths SHALL exist before creating links
- **AND** the task SHALL fail if any source does not exist

#### Scenario: Force link creation

- **GIVEN** a symbolic link already exists at the destination
- **WHEN** the link creation task runs
- **THEN** the existing link SHALL be replaced with the new one (force: true)

#### Scenario: Link ownership

- **GIVEN** symbolic links are being created
- **WHEN** the link creation task executes
- **THEN** links SHALL be owned by the configured user
- **AND** elevated privileges SHALL be used if necessary

### Requirement: Platform-Specific Link Sets

The home role SHALL support different sets of symbolic links for different platforms.

#### Scenario: macOS-specific links

- **GIVEN** the role is running on macOS
- **WHEN** the symbolic link task executes
- **THEN** macOS-specific link configurations SHALL be used

#### Scenario: Windows-specific links

- **GIVEN** the role is running on Windows
- **WHEN** the symbolic link task executes
- **THEN** Windows-specific link configurations SHALL be used
- **AND** Windows-compatible link creation methods SHALL be used

#### Scenario: WSL-specific links

- **GIVEN** the role is running on WSL
- **WHEN** the symbolic link task executes
- **THEN** WSL-specific link configurations SHALL be used
- **AND** Unix-style symbolic links SHALL be created

### Requirement: Idempotency

The home role SHALL be idempotent and safe to run multiple times.

#### Scenario: Re-run on existing setup

- **GIVEN** directories and symbolic links are already created
- **WHEN** the home role executes again
- **THEN** no changes SHALL be made to existing correct configurations
- **AND** all tasks SHALL complete successfully

### Requirement: Configuration Variables

The home role SHALL use standardized configuration variables for paths.

#### Scenario: Use common variables

- **GIVEN** the role is executing
- **WHEN** creating directories and links
- **THEN** common variables (home, dotfiles, xdg_config_home, etc.) SHALL be used
- **AND** variables SHALL be defined in common.yaml or role defaults
