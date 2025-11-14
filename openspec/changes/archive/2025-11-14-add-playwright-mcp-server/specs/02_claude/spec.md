# claude Role - Add playwright MCP Server

## MODIFIED Requirements

### Requirement: MCP Server Installation

The claude role SHALL install and configure multiple MCP servers for enhanced
Claude Code functionality.

#### Scenario: Install context7 MCP server

- **GIVEN** context7 is not in the installed MCP server list
- **WHEN** the MCP server installation runs
- **THEN** context7 SHALL be installed via npx with user scope

#### Scenario: Install ccusage MCP server

- **GIVEN** ccusage is not in the installed MCP server list
- **WHEN** the MCP server installation runs
- **THEN** ccusage SHALL be installed via npx with user scope

#### Scenario: Install scopecraft MCP server

- **GIVEN** scopecraft is not in the installed MCP server list
- **WHEN** the MCP server installation runs
- **THEN** scopecraft SHALL be installed via sc-stdio with user scope

#### Scenario: Install playwright MCP server

- **GIVEN** playwright is not in the installed MCP server list
- **WHEN** the MCP server installation runs
- **THEN** playwright SHALL be installed via npx with user scope
- **AND** the official Microsoft package @playwright/mcp SHALL be used

#### Scenario: Install language server MCP servers

- **GIVEN** typescript or go servers are not installed
- **WHEN** the MCP server installation runs
- **THEN** typescript SHALL be installed via @mizchi/lsmcp with tsgo parameter
- **AND** go SHALL be installed via @mizchi/lsmcp with gopls parameter

#### Scenario: Skip already installed servers

- **GIVEN** an MCP server is already installed
- **WHEN** the MCP server check runs
- **THEN** the installation for that server SHALL be skipped
