# Entrypoint Scripts Specification

## Purpose

The entrypoint scripts provide the primary interface for users to set up their
development environments. These scripts orchestrate the bootstrap process and
Ansible playbook execution for each target platform (macOS, WSL).

## Requirements

### Requirement: Platform-Specific Entrypoint Scripts

The project SHALL provide dedicated entrypoint scripts for each supported platform.

#### Scenario: macOS entrypoint available

- **GIVEN** a user wants to set up a macOS system
- **WHEN** they look for the setup script
- **THEN** a `setup-iapetus.sh` script SHALL be available at the project root

#### Scenario: WSL/Linux entrypoint available

- **GIVEN** a user wants to set up a WSL/Linux system
- **WHEN** they look for the setup script
- **THEN** a `setup-khronos.sh` script SHALL be available at the project root

### Requirement: Bootstrap Process Orchestration

Entrypoint scripts SHALL orchestrate the two-phase setup process: bootstrap and configuration.

#### Scenario: Ansible installation before playbook execution

- **GIVEN** an entrypoint script is executed
- **WHEN** the script runs
- **THEN** it SHALL first execute the platform-specific Ansible installation script
- **AND** only proceed to playbook execution if installation succeeds

#### Scenario: Playbook execution after bootstrap

- **GIVEN** Ansible has been successfully installed
- **WHEN** the entrypoint script continues
- **THEN** it SHALL execute the appropriate platform-specific Ansible playbook
- **AND** pass through all command-line arguments to the playbook

### Requirement: Error Handling and Propagation

Entrypoint scripts SHALL properly handle and propagate errors from all
subprocess executions.

#### Scenario: Bootstrap failure stops execution

- **GIVEN** the Ansible installation script fails
- **WHEN** the entrypoint script checks the exit code
- **THEN** it SHALL exit immediately with the same error code
- **AND** NOT proceed to playbook execution

#### Scenario: Playbook failure propagated

- **GIVEN** the Ansible playbook execution fails
- **WHEN** the entrypoint script completes
- **THEN** it SHALL exit with the playbook's error code

#### Scenario: Successful completion message

- **GIVEN** both bootstrap and playbook execution succeed
- **WHEN** the entrypoint script finishes
- **THEN** it SHALL display a success message
- **AND** exit with code 0

### Requirement: Verbose Logging Support

Entrypoint scripts SHALL support verbose logging via file descriptor 3
controlled by the VERBOSE environment variable.

#### Scenario: Verbose logging enabled

- **GIVEN** the VERBOSE environment variable is set
- **WHEN** the entrypoint script executes
- **THEN** file descriptor 3 SHALL redirect to stderr
- **AND** diagnostic messages SHALL be visible to the user

#### Scenario: Verbose logging disabled by default

- **GIVEN** the VERBOSE environment variable is not set
- **WHEN** the entrypoint script executes
- **THEN** file descriptor 3 SHALL redirect to /dev/null
- **AND** diagnostic messages SHALL be suppressed

### Requirement: Safe Directory Navigation

Entrypoint scripts SHALL use pushd/popd for safe directory navigation.

#### Scenario: Directory navigation with cleanup

- **GIVEN** an entrypoint script needs to change directories
- **WHEN** using pushd to enter a directory
- **THEN** it SHALL use popd to restore the previous directory
- **AND** ensure cleanup occurs even on error conditions

### Requirement: Platform-Specific Environment Setup

Entrypoint scripts SHALL configure platform-specific environment requirements.

#### Scenario: Homebrew PATH for WSL

- **GIVEN** the setup-khronos.sh script runs on WSL
- **WHEN** the script initializes
- **THEN** it SHALL add /home/linuxbrew/.linuxbrew/bin to PATH
- **AND** ensure Homebrew commands are available for bootstrap

#### Scenario: Ansible configuration for WSL

- **GIVEN** the setup-khronos.sh script executes the playbook
- **WHEN** running ansible-playbook
- **THEN** it SHALL explicitly set ANSIBLE_CONFIG=ansible.cfg
- **AND** set ANSIBLE_HOME=. to work around permission issues

#### Scenario: Standard Ansible execution for macOS

- **GIVEN** the setup-iapetus.sh script executes the playbook
- **WHEN** running ansible-playbook
- **THEN** it SHALL set ANSIBLE_HOME=. only
- **AND** rely on default ansible.cfg discovery

### Requirement: Command-Line Argument Pass-Through

Entrypoint scripts SHALL pass all command-line arguments to the Ansible
playbook unchanged.

#### Scenario: Arguments forwarded to playbook

- **GIVEN** a user runs `./setup-khronos.sh -e win_username=user -K`
- **WHEN** the script executes the playbook
- **THEN** it SHALL pass `-e win_username=user -K` to ansible-playbook
- **AND** preserve argument order and quoting

### Requirement: Success Message Display

Entrypoint scripts SHALL provide clear feedback on successful completion.

#### Scenario: User-friendly success message

- **GIVEN** the entire setup process completes successfully
- **WHEN** the script finishes
- **THEN** it SHALL display "setup-[platform].sh: your machine have been
  configured! enjoy your development!"
- **AND** use the script's basename in the message
