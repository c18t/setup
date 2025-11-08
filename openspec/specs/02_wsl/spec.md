# wsl Specification

## Purpose

The wsl role manages Windows Subsystem for Linux (WSL) specific configuration including font installation and fstab configuration for mounting Windows drives. This specification defines requirements for configuring WSL environments to integrate properly with the Windows host system.

## Requirements

### Requirement: Font Installation

The wsl role SHALL install fonts in the WSL environment for proper terminal display.

#### Scenario: Install fonts

- **GIVEN** the WSL environment needs fonts configured
- **WHEN** the font installation task runs
- **THEN** fonts SHALL be installed to appropriate locations in WSL

#### Scenario: Font accessibility

- **GIVEN** fonts are installed
- **WHEN** terminal applications are launched
- **THEN** installed fonts SHALL be available for use

### Requirement: Fstab Configuration

The wsl role SHALL configure /etc/fstab to mount Windows drives with appropriate options.

#### Scenario: Configure Google Drive mount

- **GIVEN** the WSL environment needs access to Windows drives
- **WHEN** the fstab configuration task runs
- **THEN** an entry SHALL be added for mounting "G:\マイドライブ" to /mnt/g
- **AND** the mount SHALL use drvfs filesystem type
- **AND** the mount options SHALL include: metadata, noatime, uid=1000, gid=1000, defaults
- **AND** dump and pass values SHALL be set to 0 0

#### Scenario: Metadata support

- **GIVEN** fstab is configured for Windows drive mounting
- **WHEN** the drive is mounted
- **THEN** metadata option SHALL enable Linux file permissions on NTFS
- **AND** uid and gid SHALL map files to the WSL user (1000)

#### Scenario: Performance optimization

- **GIVEN** fstab mount options are configured
- **WHEN** the drive is mounted
- **THEN** noatime option SHALL be used to improve performance
- **AND** defaults option SHALL apply standard mount defaults

### Requirement: Privilege Elevation

The wsl role SHALL use elevated privileges for system configuration.

#### Scenario: Fstab modification

- **GIVEN** /etc/fstab is being modified
- **WHEN** the fstab task runs
- **THEN** elevated privileges SHALL be used (become: true)

### Requirement: Idempotency

The wsl role SHALL be idempotent and safe to run multiple times.

#### Scenario: Re-run fstab configuration

- **GIVEN** fstab entry already exists
- **WHEN** the wsl role executes again
- **THEN** the existing entry SHALL not be duplicated
- **AND** the task SHALL complete successfully

#### Scenario: Re-run font installation

- **GIVEN** fonts are already installed
- **WHEN** the wsl role executes again
- **THEN** font installation SHALL be idempotent

### Requirement: Task Organization

The wsl role SHALL organize configuration into logical task files.

#### Scenario: Font installation tasks

- **GIVEN** the wsl role is executing
- **WHEN** tasks are loaded
- **THEN** font installation SHALL be in 10-install-fonts.yaml

#### Scenario: Fstab configuration tasks

- **GIVEN** the wsl role is executing
- **WHEN** tasks are loaded
- **THEN** fstab configuration SHALL be in 11-make-fstab.yaml

### Requirement: Platform Restriction

The wsl role SHALL only execute on WSL environments.

#### Scenario: WSL platform check

- **GIVEN** the wsl role is included in a playbook
- **WHEN** the playbook runs on a non-WSL system
- **THEN** the role tasks SHALL be skipped or fail gracefully

### Requirement: Drive Mount Points

The wsl role SHALL support configurable mount points for Windows drives.

#### Scenario: Standard mount location

- **GIVEN** a Windows drive is being mounted
- **WHEN** the fstab entry is created
- **THEN** the mount point SHALL be under /mnt/

#### Scenario: Mount point creation

- **GIVEN** a mount point is configured in fstab
- **WHEN** the system attempts to mount the drive
- **THEN** the mount point directory SHALL exist or be created automatically

### Requirement: File System Integration

The wsl role SHALL configure proper integration between WSL Linux filesystem and Windows NTFS.

#### Scenario: NTFS compatibility

- **GIVEN** Windows drives are mounted in WSL
- **WHEN** the drvfs filesystem is used
- **THEN** WSL SHALL provide proper translation between Linux and Windows file systems

#### Scenario: Permission mapping

- **GIVEN** metadata option is enabled on mounted drives
- **WHEN** files are created or modified through WSL
- **THEN** Linux permissions SHALL be preserved in NTFS metadata
- **AND** files SHALL be accessible from both Windows and WSL
