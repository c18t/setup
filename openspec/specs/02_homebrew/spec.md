# homebrew Specification

## Purpose

The homebrew role manages the installation of Homebrew package manager and applications defined in Brewfiles. This specification defines requirements for installing Homebrew on macOS and Linux systems, and managing packages through Brewfile-based installations with platform-specific configurations.

## Requirements

### Requirement: Homebrew Installation

The homebrew role SHALL install Homebrew if it is not already available on the system.

#### Scenario: Homebrew not installed

- **GIVEN** Homebrew is not available in the system PATH
- **WHEN** the Homebrew installation check runs
- **THEN** Homebrew SHALL be installed via the official installation script

#### Scenario: Homebrew already installed

- **GIVEN** Homebrew is available in the system PATH
- **WHEN** the Homebrew installation check runs
- **THEN** the installation step SHALL be skipped

#### Scenario: Installation verification

- **GIVEN** Homebrew installation is attempted
- **WHEN** the installation completes
- **THEN** the brew command SHALL be available for subsequent tasks

### Requirement: Precondition Checking

The homebrew role SHALL verify that Homebrew is available before attempting package installation.

#### Scenario: Check Homebrew availability

- **GIVEN** the role is about to install packages
- **WHEN** the precondition check runs
- **THEN** Homebrew SHALL be verified as installed and accessible

### Requirement: Brewfile-Based Package Installation

The homebrew role SHALL install and upgrade applications using platform-specific Brewfiles.

#### Scenario: macOS package installation

- **GIVEN** the role is running on macOS
- **WHEN** the application installation task runs
- **THEN** packages SHALL be installed from the macOS-specific Brewfile

#### Scenario: Non-macOS package installation

- **GIVEN** the role is running on Linux or WSL
- **WHEN** the application installation task runs
- **THEN** packages SHALL be installed from the appropriate platform Brewfile

#### Scenario: Bundle installation

- **GIVEN** a Brewfile exists for the platform
- **WHEN** the bundle install command runs
- **THEN** all packages defined in the Brewfile SHALL be installed
- **AND** `brew bundle install` SHALL be used for installation

### Requirement: Environment Configuration

The homebrew role SHALL configure appropriate environment variables for non-macOS platforms.

#### Scenario: macOS environment

- **GIVEN** the role is running on macOS
- **WHEN** Homebrew operations execute
- **THEN** no additional environment variables SHALL be required

#### Scenario: Non-macOS environment

- **GIVEN** the role is running on Linux or WSL
- **WHEN** Homebrew operations execute
- **THEN** the following environment variables SHALL be set:
  - PATH with Homebrew bin directory
  - LIBRARY_PATH with Homebrew lib directory
  - LD_LIBRARY_PATH with Homebrew lib directory
  - C_INCLUDE_PATH with Homebrew include directory
  - CPLUS_INCLUDE_PATH with Homebrew include directory
  - OBJC_INCLUDE_PATH with Homebrew include directory

#### Scenario: Homebrew prefix detection

- **GIVEN** Homebrew is installed
- **WHEN** the prefix detection task runs
- **THEN** the brew --prefix path SHALL be determined and stored for use in environment variables

### Requirement: Execution Order

The homebrew role SHALL execute tasks in the correct order.

#### Scenario: Sequential execution

- **GIVEN** the homebrew role is executing
- **WHEN** tasks are processed
- **THEN** precondition check SHALL complete before Homebrew installation
- **AND** Homebrew installation SHALL complete before package installation
- **AND** Homebrew prefix SHALL be set before environment configuration

### Requirement: Documentation

The project documentation SHALL include commands to export and update Brewfiles.

#### Scenario: Export macOS Brewfile

- **GIVEN** packages are installed via Homebrew on macOS
- **WHEN** a developer wants to update the Brewfile
- **THEN** documentation SHALL provide the command to dump the Brewfile with descriptions

#### Scenario: Export WSL Brewfile

- **GIVEN** packages are installed via Homebrew on WSL
- **WHEN** a developer wants to update the Brewfile
- **THEN** documentation SHALL provide the command to dump the WSL Brewfile with descriptions

#### Scenario: Preserve Brewfile comments

- **GIVEN** the Brewfile contains inline comments and commented-out entries
- **WHEN** updating the Brewfile
- **THEN** inline comments and commented-out entries SHALL be preserved
