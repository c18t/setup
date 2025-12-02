# Change: Remove obsolete MCP servers from claude role

## Why

The go, typescript, and scopecraft MCP servers are no longer needed in the
claude role configuration. These servers should be removed to simplify the MCP
server setup, reduce maintenance overhead, and focus on core functionality.

- **go** and **typescript**: These language server integrations consume
  significant tokens even when not actively used. Configuring them on a
  per-project basis (when needed) is more efficient for token consumption and
  allows better control over which projects require LSP integration
- **scopecraft**: This MCP server was not used in practice. Task management is
  better handled through a combination of:
  - Short-term tasks: Claude Code's built-in task management
  - Issue-specific tasks: OpenSpec proposals
  - Long-term tasks: Project-specific task management tools

## What Changes

- Remove go MCP server installation task from claude role
- Remove typescript MCP server installation task from claude role
- Remove scopecraft MCP server installation task from claude role
- Update both Unix-like (12-mcp-servers.yaml) and Windows
  (12-mcp-servers-windows.yaml) task files
- Update project documentation to reflect the reduced MCP server list

## Impact

- Affected specs: `02_claude`
- Affected code:
  - `ansible/roles/claude/tasks/12-mcp-servers.yaml`
  - `ansible/roles/claude/tasks/12-mcp-servers-windows.yaml`
  - `openspec/project.md`
- Backward compatible: Removes existing functionality but does not break
  existing installations
- Remaining MCP servers: context7, ccusage, playwright, container-use
