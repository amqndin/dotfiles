-- Shared helpers for the build-system templates in ./template/.
--
-- This module lives OUTSIDE template/ on purpose. overseer auto-loads every
-- .lua under overseer/template/ as a task, and load_template() auto-assigns a
-- name to whatever it finds -- so a library placed there is treated as a
-- broken template and logs an error every time the task list is built.

local M = {}

---Components shared by every build task. Errors go to quickfix and inline.
M.build_components = {
  { 'on_output_quickfix', open_on_match = true, set_diagnostics = true },
  { 'on_result_diagnostics' },
  'default',
}

---Components shared by every run task. `open_output` is what makes the
---program's own output visible, and focus=true so you can type into programs
---that read stdin (they produce no diagnostics to surface anywhere else).
M.run_components = {
  { 'open_output', direction = 'float', on_start = 'always', focus = true },
  { 'on_output_quickfix', open_on_match = true },
  'default',
}

---Components for setup steps that produce no artifact.
M.setup_components = {
  { 'on_output_quickfix', open_on_match = true },
  'default',
}

---Nearest ancestor of `dir` containing `marker`, as a full path.
---Providers are given a search dir rather than the cwd, so this takes one.
---@param marker string
---@param dir string
---@return string|nil
function M.find(marker, dir)
  return vim.fs.find(marker, { upward = true, type = 'file', path = dir })[1]
end

---Target name derived from the current buffer: problem02.cpp -> problem02
---@return string
function M.stem()
  return vim.fn.expand '%:p:t:r'
end

---build_components plus a run_after step, without mutating the shared list.
---
---Do NOT use vim.tbl_flatten for this: it recurses into every nested table,
---so it would also flatten the run_after component's own `statuses`/`tasks`
---tables and silently break the component.
---@param components table[]
---@param run_task overseer.TaskDefinition
---@return table[]
function M.chain_run(components, run_task)
  local composed = vim.deepcopy(components)
  table.insert(composed, { 'run_after', statuses = { 'SUCCESS' }, tasks = { run_task } })
  return composed
end

return M