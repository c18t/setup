# nvim Specification

## Purpose

The nvim role manages the configuration of Neovim editor by creating necessary
directories and linking Neovim configuration files from a dotfiles repository.
This specification defines requirements for setting up Neovim's configuration
directory structure and backup locations.

## Requirements

### Requirement: Directory Creation

The nvim role SHALL create necessary directories for Neovim configuration and cache.

#### Scenario: Create backup directory

- **GIVEN** Neovim needs a backup directory
- **WHEN** the directory creation task runs
- **THEN** the backup directory SHALL be created at `{{ xdg_cache_home }}/nvim_backup`
- **AND** the directory SHALL have mode u=rwx,g=rx,o=rx

#### Scenario: Follow symbolic links

- **GIVEN** a directory path contains symbolic links
- **WHEN** the directory creation task executes
- **THEN** symbolic links SHALL be followed to their targets

### Requirement: Configuration Link Setup

The nvim role SHALL create symbolic links from the dotfiles repository to
Neovim's configuration directory.

#### Scenario: Define link items

- **GIVEN** the nvim role is executing
- **WHEN** the link configuration task runs
- **THEN** link items SHALL be defined mapping dotfiles/nvim to xdg_config_home/nvim

#### Scenario: Validate link sources

- **GIVEN** symbolic links are to be created
- **WHEN** the validation task runs
- **THEN** the source path SHALL exist and be a directory
- **AND** the task SHALL fail if the source does not exist or is not a directory

#### Scenario: Create configuration link

- **GIVEN** the source directory is validated
- **WHEN** the symbolic link creation task runs
- **THEN** a symbolic link SHALL be created from dotfiles/nvim to xdg_config_home/nvim
- **AND** the link SHALL be owned by the configured user

### Requirement: Link Management

The nvim role SHALL properly manage symbolic links with force replacement.

#### Scenario: Force link creation

- **GIVEN** a symbolic link already exists at the destination
- **WHEN** the link creation task runs
- **THEN** the existing link SHALL be replaced with the new one (force: true)
- **AND** the link SHALL not follow existing links (follow: false)

#### Scenario: Link ownership

- **GIVEN** symbolic links are being created
- **WHEN** the link creation task executes
- **THEN** links SHALL be owned by the configured user
- **AND** elevated privileges SHALL be used (become: true)

### Requirement: XDG Base Directory Compliance

The nvim role SHALL follow XDG Base Directory specification for configuration
and cache.

#### Scenario: Configuration directory location

- **GIVEN** Neovim configuration is being set up
- **WHEN** the configuration link is created
- **THEN** the configuration SHALL be placed in `{{ xdg_config_home }}/nvim`

#### Scenario: Cache directory location

- **GIVEN** Neovim cache directory is being created
- **WHEN** the backup directory is created
- **THEN** the backup directory SHALL be placed in `{{ xdg_cache_home }}/nvim_backup`

### Requirement: Idempotency

The nvim role SHALL be idempotent and safe to run multiple times.

#### Scenario: Re-run on existing setup

- **GIVEN** Neovim directories and links are already configured
- **WHEN** the nvim role executes again
- **THEN** no changes SHALL be made to existing correct configurations
- **AND** all tasks SHALL complete successfully

### Requirement: Platform Independence

The nvim role SHALL work consistently across all supported platforms.

#### Scenario: Cross-platform execution

- **GIVEN** the nvim role is executed on macOS, Windows WSL, or Linux
- **WHEN** configuration tasks run
- **THEN** the same directory structure and links SHALL be created
- **AND** platform-specific paths SHALL be handled through variables
