# Implementation Tasks

## 1. Create Default Package Files

- [x] 1.1 Create `.default-pnpm-packages` file in
      `~/GoogleDrive/share/dotfiles/mise/` with current pnpm global packages
- [x] 1.2 Create `.default-uv-tools` file in
      `~/GoogleDrive/share/dotfiles/mise/` for uv tools
- [x] 1.3 Migrate Python packages from `.default-python-packages` to
      `.default-uv-tools`
- [x] 1.4 Create test files in `ansible/playbooks/files/tests/dotfiles/mise/`

## 2. Update Role Configuration

- [x] 2.1 Add `mise_default_pnpm_packages` variable to
      `ansible/roles/mise/defaults/main.yaml`
- [x] 2.2 Add `mise_default_uv_tools` variable to
      `ansible/roles/mise/defaults/main.yaml`

## 3. Update Playbook Variables

- [x] 3.1 Add `mise_default_pnpm_packages` to
      `ansible/playbooks/iapetus-macos.yaml`
- [x] 3.2 Add `mise_default_uv_tools` to
      `ansible/playbooks/iapetus-macos.yaml`
- [x] 3.3 Add `mise_default_pnpm_packages` to
      `ansible/playbooks/khronos-windows.yaml`
- [x] 3.4 Add `mise_default_uv_tools` to
      `ansible/playbooks/khronos-windows.yaml`

## 4. Create Global Tool Installation Task

- [x] 4.1 Create new task file
      `ansible/roles/mise/tasks/20-install-global-tools.yaml`
- [x] 4.2 Implement pnpm global package installation with conditional
      execution
- [x] 4.3 Implement uv tool installation with conditional execution
- [x] 4.4 Add appropriate changed_when conditions for idempotency
- [x] 4.5 Handle cases where pnpm or uv are not available (skip gracefully)
- [x] 4.6 Implement file reading with comment and empty line filtering

## 5. Integrate into Main Tasks

- [x] 5.1 Import new task in `ansible/roles/mise/tasks/main.yaml` after
      mise setup task

## 6. Testing and Validation

- [x] 6.1 Run ansible-lint on modified files
- [x] 6.2 Test on WSL environment
- [x] 6.3 Verify pnpm packages install correctly
- [x] 6.4 Verify uv tools install correctly
- [x] 6.5 Verify idempotency with changed_when conditions

## 7. Documentation

- [x] 7.1 Update CLAUDE.md with information about managing global tools
- [x] 7.2 Add commands for exporting current pnpm global packages to
      README.md
- [x] 7.3 Add commands for exporting current uv tools to README.md
- [x] 7.4 Update proposal.md to reflect dotfiles directory usage
