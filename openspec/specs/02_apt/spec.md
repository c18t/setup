# apt Specification

## Purpose

The apt role manages package installation and system updates on Debian/Ubuntu-based
systems.
This specification defines requirements for adding APT repositories, managing
GPG keys, updating package caches, upgrading packages, and installing specified packages.

## Requirements

### Requirement: APT Repository Management

The apt role SHALL add APT repositories with their GPG keys before installing packages.

#### Scenario: Add GPG keys for repositories

- **GIVEN** a list of APT keys is configured in `apt_keys`
- **WHEN** the apt role executes repository setup
- **THEN** all GPG keys SHALL be downloaded to `/usr/share/keyrings/` with
  appropriate permissions

#### Scenario: Add APT repositories

- **GIVEN** a list of APT repositories is configured in `apt_repositories`
- **WHEN** the apt role executes repository setup
- **THEN** all repositories SHALL be added to the system with their specified filenames

#### Scenario: No repositories configured

- **GIVEN** no repositories are defined in `apt_repositories`
- **WHEN** the apt role executes
- **THEN** no repository additions SHALL be attempted

### Requirement: Package Cache Management

The apt role SHALL update the APT package cache before installing packages.

#### Scenario: Update package cache

- **GIVEN** the apt role is executing
- **WHEN** the update task runs
- **THEN** the APT cache SHALL be updated with a validity period of 3600 seconds

#### Scenario: Cache is current

- **GIVEN** the APT cache was updated within the last hour
- **WHEN** the update task runs
- **THEN** the cache update SHALL be skipped

### Requirement: Package Upgrade

The apt role SHALL perform safe package upgrades after updating the cache.

#### Scenario: Upgrade system packages

- **GIVEN** the APT cache has been updated
- **WHEN** the upgrade task executes
- **THEN** all packages SHALL be upgraded using the "safe" upgrade method

#### Scenario: Safe upgrade only

- **GIVEN** packages need upgrading
- **WHEN** the upgrade task runs
- **THEN** only safe upgrades SHALL be performed to avoid removing packages

### Requirement: Package Installation

The apt role SHALL install all packages specified in the configuration.

#### Scenario: Install configured packages

- **GIVEN** a list of packages is defined in `apt_packages`
- **WHEN** the package installation task runs
- **THEN** all packages in the list SHALL be installed via APT

#### Scenario: Empty package list

- **GIVEN** the `apt_packages` list is empty
- **WHEN** the apt role executes
- **THEN** no package installations SHALL be attempted

### Requirement: Execution Order

The apt role SHALL execute tasks in the correct order to ensure dependencies are
met.

#### Scenario: Sequential execution

- **GIVEN** the apt role is executing
- **WHEN** tasks are processed
- **THEN** repository addition SHALL complete before cache update
- **AND** cache update SHALL complete before package upgrade
- **AND** package upgrade SHALL complete before package installation

### Requirement: Privilege Elevation

The apt role SHALL use elevated privileges for system package management operations.

#### Scenario: Privileged operations

- **GIVEN** any APT management task is running
- **WHEN** the task executes
- **THEN** the operation SHALL run with elevated privileges (become: true)
