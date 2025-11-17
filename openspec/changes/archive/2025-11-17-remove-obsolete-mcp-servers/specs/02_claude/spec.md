# claude Role - Remove obsolete MCP Servers

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

#### Scenario: Install playwright MCP server

- **GIVEN** playwright is not in the installed MCP server list
- **WHEN** the MCP server installation runs
- **THEN** playwright SHALL be installed via npx with user scope
- **AND** the official Microsoft package @playwright/mcp SHALL be used

#### Scenario: Skip already installed servers

- **GIVEN** an MCP server is already installed
- **WHEN** the MCP server check runs
- **THEN** the installation for that server SHALL be skipped

**Removed scenarios:**

- ~~Install scopecraft MCP server~~ - Not used in practice. Task management is
  better handled through Claude Code's built-in task management, OpenSpec
  proposals, and project-specific task management tools.
- ~~Install language server MCP servers (typescript/go)~~ - Removed to reduce
  token consumption. These language server integrations consume significant
  tokens even when not actively used. Configuring them on a per-project basis
  is more efficient.
