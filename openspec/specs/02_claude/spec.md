# claude Specification

## Purpose

The claude role manages the installation and configuration of Claude Code CLI and its MCP (Model Context Protocol) servers. This specification defines requirements for installing Claude Code, configuring symbolic links to Claude configuration directories, and setting up multiple MCP servers for enhanced functionality.

## Requirements

### Requirement: Claude Code Installation

The claude role SHALL install Claude Code CLI if it is not already available.

#### Scenario: Claude Code not installed

- **GIVEN** Claude Code is not available in the system PATH
- **WHEN** the claude role executes the installation check
- **THEN** Claude Code SHALL be installed via the official installation script

#### Scenario: Claude Code already installed

- **GIVEN** Claude Code is available in the system PATH
- **WHEN** the claude role executes the installation check
- **THEN** the installation step SHALL be skipped

#### Scenario: Installation verification

- **GIVEN** the installation task is running
- **WHEN** checking for Claude Code availability
- **THEN** the check SHALL use the configured Fish shell to detect the binary

### Requirement: Configuration Directory Setup

The claude role SHALL create and configure Claude Code configuration directories with proper symbolic links.

#### Scenario: Create configuration directories

- **GIVEN** Claude Code needs configuration
- **WHEN** the directory setup task runs
- **THEN** the claude home directory SHALL be created with appropriate permissions

#### Scenario: Validate symbolic link sources

- **GIVEN** symbolic links are to be created
- **WHEN** the validation task runs
- **THEN** all link source directories and files SHALL exist before linking
- **AND** the task SHALL fail if any source does not exist or has incorrect type

#### Scenario: Create symbolic links

- **GIVEN** all link sources are validated
- **WHEN** the symbolic link task executes
- **THEN** all configured links SHALL be created with proper ownership
- **AND** existing links SHALL be replaced (force: true)

### Requirement: MCP Server Installation

The claude role SHALL install and configure multiple MCP servers for enhanced Claude Code functionality.

#### Scenario: Install context7 MCP server

- **GIVEN** context7 is not in the installed MCP server list
- **WHEN** the MCP server installation runs
- **THEN** context7 SHALL be installed via npx with user scope

#### Scenario: Install ccusage MCP server

- **GIVEN** ccusage is not in the installed MCP server list
- **WHEN** the MCP server installation runs
- **THEN** ccusage SHALL be installed via npx with user scope

#### Scenario: Install cipher MCP server with environment variables

- **GIVEN** cipher is not in the installed MCP server list
- **WHEN** the MCP server installation runs
- **THEN** cipher SHALL be installed with the following environment variables:
  - CIPHER_EMBEDDER=local
  - MCP_SERVER_MODE=aggregator
  - STORAGE_DATABASE_PATH=./.cipher
  - OLLAMA_BASE_URL=http://localhost:11434

#### Scenario: Install scopecraft MCP server

- **GIVEN** scopecraft is not in the installed MCP server list
- **WHEN** the MCP server installation runs
- **THEN** scopecraft SHALL be installed via sc-stdio with user scope

#### Scenario: Install simone MCP server with project path

- **GIVEN** simone is not in the installed MCP server list
- **WHEN** the MCP server installation runs
- **THEN** simone SHALL be installed via npx with PROJECT_PATH environment variable

#### Scenario: Install language server MCP servers

- **GIVEN** typescript or go servers are not installed
- **WHEN** the MCP server installation runs
- **THEN** typescript SHALL be installed via @mizchi/lsmcp with tsgo parameter
- **AND** go SHALL be installed via @mizchi/lsmcp with gopls parameter

#### Scenario: Skip already installed servers

- **GIVEN** an MCP server is already installed
- **WHEN** the MCP server check runs
- **THEN** the installation for that server SHALL be skipped

### Requirement: Platform-Specific Configuration

The claude role SHALL support both Unix-like and Windows platforms with appropriate task files.

#### Scenario: Unix-like platform execution

- **GIVEN** the role is running on macOS or WSL
- **WHEN** the main tasks execute
- **THEN** the standard task files SHALL be used

#### Scenario: Windows platform execution

- **GIVEN** the role is running on Windows
- **WHEN** the windows.yaml tasks execute
- **THEN** Windows-specific MCP server installation tasks SHALL be used

### Requirement: Idempotency

The claude role SHALL be idempotent and safe to run multiple times.

#### Scenario: Re-run installation

- **GIVEN** Claude Code and MCP servers are already installed
- **WHEN** the claude role executes again
- **THEN** no changes SHALL be made to the system
- **AND** all checks SHALL pass without errors
