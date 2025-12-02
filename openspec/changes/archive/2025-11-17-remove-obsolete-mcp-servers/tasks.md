# Implementation Tasks

## 1. Implementation

- [x] 1.1 Remove go MCP server task from
      `ansible/roles/claude/tasks/12-mcp-servers.yaml`
- [x] 1.2 Remove typescript MCP server task from
      `ansible/roles/claude/tasks/12-mcp-servers.yaml`
- [x] 1.3 Remove scopecraft MCP server task from
      `ansible/roles/claude/tasks/12-mcp-servers.yaml`
- [x] 1.4 Remove go MCP server task from
      `ansible/roles/claude/tasks/12-mcp-servers-windows.yaml`
- [x] 1.5 Remove typescript MCP server task from
      `ansible/roles/claude/tasks/12-mcp-servers-windows.yaml`
- [x] 1.6 Remove scopecraft MCP server task from
      `ansible/roles/claude/tasks/12-mcp-servers-windows.yaml`

## 2. Documentation

- [x] 2.1 Update specs to reflect removal of go, typescript, and scopecraft
      servers
- [x] 2.2 Update `openspec/project.md` to remove obsolete MCP servers from the
      list

## 3. Validation

- [x] 3.1 Run ansible-lint on modified files
- [x] 3.2 Verify remaining MCP servers are still configured correctly
- [x] 3.3 Run `openspec validate remove-obsolete-mcp-servers --strict`
