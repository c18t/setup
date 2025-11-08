# scripts Specification

## Purpose

The scripts directory contains bootstrap and utility scripts that enable automated environment setup across macOS, Windows, and WSL platforms. These scripts handle prerequisite installation, dependency management, and system configuration before Ansible playbook execution. The scripts are organized by platform and provide idempotent, error-resilient installation of package managers, build tools, and runtime dependencies.

## Requirements

### Requirement: Bootstrap Script Execution Model

All bootstrap scripts SHALL follow a consistent execution pattern with verbose logging, error handling, and idempotency checks.

#### Scenario: Verbose logging control

- **GIVEN** a bootstrap script is executed
- **WHEN** the VERBOSE environment variable is set
- **THEN** detailed logging SHALL be written to stderr via file descriptor 3
- **AND** when VERBOSE is not set, logging SHALL be suppressed

#### Scenario: Existence checking

- **GIVEN** a bootstrap script is about to install a tool
- **WHEN** the script checks for tool availability
- **THEN** the script SHALL verify if the tool is already installed
- **AND** skip installation if the tool exists
- **AND** log the check result (ok/no) when verbose logging is enabled

#### Scenario: Exit code propagation

- **GIVEN** a bootstrap script executes
- **WHEN** any installation step fails
- **THEN** the script SHALL propagate the error exit code to the caller
- **AND** SHALL NOT continue to dependent installation steps

### Requirement: macOS Bootstrap Scripts

The macOS bootstrap scripts SHALL install Homebrew and Ansible with proper dependency management.

#### Scenario: Homebrew installation on macOS

- **GIVEN** Homebrew is not installed on macOS
- **WHEN** install-homebrew.sh is executed
- **THEN** Homebrew SHALL be installed via the official installation script from GitHub
- **AND** the installation result SHALL be reported

#### Scenario: Homebrew already exists on macOS

- **GIVEN** Homebrew is already available in PATH
- **WHEN** install-homebrew.sh is executed
- **THEN** installation SHALL be skipped
- **AND** the script SHALL exit successfully

#### Scenario: Ansible installation on macOS

- **GIVEN** Ansible is not installed on macOS
- **WHEN** install-ansible-macos.sh is executed
- **THEN** install-homebrew.sh SHALL be called first
- **AND** Ansible SHALL be installed via brew install ansible
- **AND** the installation result SHALL be reported

#### Scenario: Ansible already exists on macOS

- **GIVEN** Ansible is already available in PATH
- **WHEN** install-ansible-macos.sh is executed
- **THEN** Ansible installation SHALL be skipped
- **AND** the script SHALL exit successfully

### Requirement: WSL Bootstrap Scripts

The WSL bootstrap scripts SHALL install dependencies, Linuxbrew, Python packages, and Ansible in the correct order.

#### Scenario: Ansible dependency installation on Ubuntu

- **GIVEN** required packages (expect, python3-apt, sshpass) are not installed
- **WHEN** install-ansible-dependencies-ubuntu.sh is executed
- **THEN** apt update SHALL be run
- **AND** expect, python3-apt, and sshpass SHALL be installed via apt
- **AND** installation SHALL use -y flag for non-interactive execution

#### Scenario: Ansible dependencies already installed

- **GIVEN** expect, python3-apt, and sshpass are already installed
- **WHEN** install-ansible-dependencies-ubuntu.sh is executed
- **THEN** package installation SHALL be skipped
- **AND** the script SHALL exit successfully

#### Scenario: Linuxbrew dependency installation

- **GIVEN** Linuxbrew prerequisites are not installed
- **WHEN** install-linuxbrew.sh is executed
- **THEN** build-essential, procps, curl, file, and git SHALL be checked
- **AND** missing packages SHALL be installed via apt
- **AND** installation SHALL use -y flag for non-interactive execution

#### Scenario: Linuxbrew installation via expect

- **GIVEN** Linuxbrew is not installed
- **WHEN** install-linuxbrew.sh is executed
- **THEN** the user SHALL be prompted for their password
- **AND** the password SHALL be passed to install-linuxbrew.exp
- **AND** the expect script SHALL handle password and continuation prompts
- **AND** Linuxbrew SHALL be installed to /home/linuxbrew/.linuxbrew

#### Scenario: Linuxbrew PATH configuration

- **GIVEN** install-linuxbrew.sh is executing
- **WHEN** any brew commands are run
- **THEN** /home/linuxbrew/.linuxbrew/bin SHALL be prepended to PATH

#### Scenario: Python package installation for Ansible

- **GIVEN** pywinrm is not installed
- **WHEN** install-python-packages.sh is executed
- **THEN** python3 SHALL be installed via Homebrew if not present
- **AND** pywinrm SHALL be installed via pip3 with --break-system-packages flag
- **AND** the installation result SHALL be reported

#### Scenario: Ansible installation on WSL

- **GIVEN** Ansible is not installed on WSL
- **WHEN** install-ansible-ubuntu.sh is executed
- **THEN** install-ansible-dependencies-ubuntu.sh SHALL be called first
- **AND** install-linuxbrew.sh SHALL be called second
- **AND** install-python-packages.sh SHALL be called third
- **AND** Ansible SHALL be installed via brew install ansible
- **AND** if any step fails, subsequent steps SHALL NOT execute

#### Scenario: Ansible already exists on WSL

- **GIVEN** Ansible is already available in PATH
- **WHEN** install-ansible-ubuntu.sh is executed
- **THEN** Ansible installation via Homebrew SHALL be skipped
- **AND** the script SHALL exit successfully

### Requirement: Windows Configuration Scripts

The Windows configuration scripts SHALL set up WSL system configuration files.

#### Scenario: WSL configuration file creation

- **GIVEN** /etc/wsl.conf does not exist or lacks [automount] section
- **WHEN** make-wsl-config.sh is executed
- **THEN** an [automount] section SHALL be appended to /etc/wsl.conf
- **AND** metadata option SHALL be enabled to allow chmod operations
- **AND** umask=22 SHALL be set to restrict write permissions (777 -> 755)
- **AND** the configuration SHALL be written via sudo tee
- **AND** the script SHALL exit with code 1 to indicate configuration was added

#### Scenario: WSL configuration already exists

- **GIVEN** /etc/wsl.conf exists with [automount] section
- **WHEN** make-wsl-config.sh is executed
- **THEN** no changes SHALL be made to wsl.conf
- **AND** the script SHALL exit with code 0

#### Scenario: WSL configuration documentation

- **GIVEN** the WSL configuration script
- **WHEN** reviewing script comments
- **THEN** comments SHALL reference Microsoft WSL configuration documentation
- **AND** SHALL explain metadata and umask settings

### Requirement: Pre-commit Hook Scripts

The pre-commit hook scripts SHALL perform code quality checks during git operations.

#### Scenario: ansible-lint execution

- **GIVEN** a git commit is being prepared
- **WHEN** the ansible-lint pre-commit hook runs
- **THEN** ansible-lint SHALL be executed with ANSIBLE_HOME set to ./ansible
- **AND** the hook SHALL check Ansible playbooks and roles for errors

#### Scenario: Skip in GitHub Actions

- **GIVEN** the pre-commit hook runs in GitHub Actions environment
- **WHEN** GITHUB_ACTIONS environment variable equals 'true'
- **THEN** the hook SHALL exit with code 0 without running ansible-lint
- **AND** linting SHALL be performed by dedicated CI workflows instead

### Requirement: Script Organization

Bootstrap scripts SHALL be organized by platform with clear naming conventions.

#### Scenario: Platform-specific directories

- **GIVEN** bootstrap scripts exist
- **WHEN** organizing scripts by platform
- **THEN** macOS scripts SHALL be in script/macos/
- **AND** Windows scripts SHALL be in script/windows/
- **AND** WSL scripts SHALL be in script/wsl/
- **AND** pre-commit scripts SHALL be in script/pre-commit/

#### Scenario: Script naming convention

- **GIVEN** a bootstrap script
- **WHEN** naming the script file
- **THEN** the name SHALL follow pattern: install-{component}-{platform}.sh
- **AND** utility scripts SHALL follow pattern: {action}-{component}.sh
- **AND** all scripts SHALL have .sh extension for shell scripts
- **AND** expect scripts SHALL have .exp extension

### Requirement: Error Handling and Recovery

Bootstrap scripts SHALL provide clear error messages and handle failures gracefully.

#### Scenario: Installation failure reporting

- **GIVEN** a tool installation fails
- **WHEN** the installation command completes with non-zero exit code
- **THEN** the script SHALL print "... failed!" message
- **AND** SHALL exit with the failure exit code
- **AND** SHALL NOT attempt dependent installations

#### Scenario: Installation success reporting

- **GIVEN** a tool installation succeeds
- **WHEN** the installation command completes with exit code 0
- **THEN** the script SHALL print "... done!" message
- **AND** SHALL continue to next steps if applicable

#### Scenario: Directory navigation safety

- **GIVEN** a script changes directories with pushd
- **WHEN** the script exits or encounters an error
- **THEN** the script SHALL restore the original directory with popd
- **AND** SHALL propagate the exit code to the caller

### Requirement: Interactive Installation Handling

Scripts that require user interaction SHALL use expect for automation.

#### Scenario: Password prompt automation

- **GIVEN** Linuxbrew installation requires sudo password
- **WHEN** install-linuxbrew.sh prompts for password
- **THEN** the password SHALL be read securely with -s flag (silent input)
- **AND** SHALL be passed to install-linuxbrew.exp script
- **AND** expect SHALL automatically provide password when prompted

#### Scenario: Continuation prompt automation

- **GIVEN** Homebrew installation prompts "Press RETURN to continue"
- **WHEN** install-linuxbrew.exp handles the installation
- **THEN** the expect script SHALL automatically send newline
- **AND** SHALL continue without manual intervention

#### Scenario: Expect timeout configuration

- **GIVEN** install-linuxbrew.exp is executing
- **WHEN** waiting for installation prompts
- **THEN** timeout SHALL be set to -1 (infinite)
- **AND** the script SHALL wait for installation to complete regardless of duration

### Requirement: Package Manager Prerequisites

Scripts SHALL ensure package manager prerequisites are met before package installation.

#### Scenario: apt update before install

- **GIVEN** packages need to be installed via apt
- **WHEN** running apt install command
- **THEN** apt update SHALL be run first
- **AND** both commands SHALL use -y flag for non-interactive execution
- **AND** commands SHALL be chained with && operator

#### Scenario: Homebrew available before use

- **GIVEN** a script needs to use brew command
- **WHEN** checking prerequisites
- **THEN** Homebrew installation SHALL be verified or installed first
- **AND** brew commands SHALL only execute after Homebrew is confirmed available

#### Scenario: pip3 system package flag

- **GIVEN** Python packages need to be installed via pip3 on Debian-based systems
- **WHEN** installing packages that would normally require virtual environment
- **THEN** --break-system-packages flag SHALL be used
- **AND** this allows installation in system Python on Debian/Ubuntu
