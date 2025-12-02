# Change: Remove cipher and simone MCP servers from claude role

## Why

The cipher and simone MCP servers are no longer needed in the claude role
configuration. These servers should be removed to simplify the MCP server setup
and reduce maintenance overhead.

## What Changes

- Remove cipher MCP server installation task from claude role
- Remove simone MCP server installation task from claude role
- Update both Unix-like (12-mcp-servers.yaml) and Windows
  (12-mcp-servers-windows.yaml) task files

## Impact

- Affected specs: `02_claude`
- Affected code:
  - `ansible/roles/claude/tasks/12-mcp-servers.yaml`
  - `ansible/roles/claude/tasks/12-mcp-servers-windows.yaml`
- Backward compatible: Removes existing functionality but does not break
  existing installations
