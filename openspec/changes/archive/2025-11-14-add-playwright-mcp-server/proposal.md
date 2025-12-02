# Change: Add playwright MCP server to claude role

## Why

The playwright MCP server provides browser automation capabilities through the
Model Context Protocol, enabling Claude Code to interact with web pages using
Playwright's accessibility tree. This allows Claude to perform browser testing,
web automation, and web scraping tasks without requiring screenshots or
vision-based models.

Adding the official Microsoft Playwright MCP server (@playwright/mcp) will
enhance Claude Code's capabilities for:

- Automated browser testing and quality assurance
- Web application interaction and testing
- Web scraping and data extraction
- UI/UX testing and validation

## What Changes

- Add playwright MCP server installation task to claude role
- Update both Unix-like (12-mcp-servers.yaml) and Windows
  (12-mcp-servers-windows.yaml) task files
- Use the official Microsoft package: @playwright/mcp

## Impact

- Affected specs: `02_claude`
- Affected code:
  - `ansible/roles/claude/tasks/12-mcp-servers.yaml`
  - `ansible/roles/claude/tasks/12-mcp-servers-windows.yaml`
- Backward compatible: Adds new functionality without breaking existing
  installations
- Dependencies: Requires npx (already available via mise/pnpm configuration)
