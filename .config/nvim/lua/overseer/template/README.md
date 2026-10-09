---
name: "Personal templates"
description: "How to add your own overseer tasks."
---

# Personal overseer templates

Drop a `.lua` file in this directory. overseer discovers it automatically — no
registration, no restart. Files are re-read each time the task list is built.

Two shapes exist. Pick whichever fits.

| Shape | Use when |
|---|---|
| **Template** — has `builder` | One fixed task: "run the tests", "start the dev server" |
| **Provider** — has `generator` | A family of tasks derived from a project: "one per target", "one per build system" |

Tags are how the keymaps find your tasks. Stick to these four and the existing
keys work with no changes:

| Tag | Key |
|---|---|
| `configure` | `<leader>rc` |
| `build` | `<leader>rb` |
| `build_all` | `<leader>ra` |
| `run` | `<leader>rr` |

## Shape 1: a fixed task

```lua
-- lua/overseer/template/mytask.lua
---@type overseer.TemplateFileDefinition
return {
  name = 'Tests: run',                  -- REQUIRED
  desc = 'Runs the test suite',         -- optional, tooltip only
  tags = { 'run' },                     -- so <leader>rr can find it
  builder = function()
    return {
      cmd = { 'pytest', '-x' },         -- argv list; a string runs via shell
      cwd = vim.fn.getcwd(),
      components = { 'default' },
    }
  end,
}
```

`name` is not optional. Leave it out and the template is silently discarded by
`validate_template_definition` — no error in the picker, just a warning in
`:messages` and nothing to select. This costs people hours.

## An empty file breaks everything

A `.lua` file here that is empty, or contains only comments, returns `true`
from `require`. `load_template` then does `if not defn.name` on a boolean and
throws:

```
attempt to index local 'defn' (a boolean value)
```

Because the directory is scanned before any result is returned, **one empty
file takes out every template, for every language**, and the error names
overseer's internals rather than the file at fault. If `:OverseerRun` suddenly
shows nothing or every key errors, check for a stray 0-byte file here first:

```
find ~/.config/nvim/lua/overseer/template -name '*.lua' -size 0
```


## Shape 2: a provider

A provider yields several templates. Use it to key off a project file so the
tasks only appear in projects that can actually run them.

```lua
-- lua/overseer/template/go.lua
local shared = require 'overseer.shared'

---@type overseer.TemplateFileProvider
return {
  -- Rebuilds the cache when this file changes. Without it, results are cached
  -- per directory and can go stale after you create the project file.
  cache_key = function(opts)
    return shared.find('go.mod', opts.dir)
  end,

  generator = function(opts)
    local mod = shared.find('go.mod', opts.dir)
    if not mod then
      return 'No go.mod found'          -- a string explains the absence
    end

    local root = vim.fs.dirname(mod)
    return {
      {
        name = 'Go: build',
        tags = { 'build' },
        builder = function()
          return { cmd = { 'go', 'build', './...' }, cwd = root, components = shared.build_components }
        end,
      },
    }
  end,
}
```

**A generator must return a table or a string — never `nil`.** Given `nil`,
overseer never invokes the callback, so the provider stays pending until
`template_timeout_ms` and logs `Listing templates timed out`. Return a string
to say why there's nothing.

## Do not gate with a function

```lua
-- WRONG. Crashes: template.lua:147 attempt to index local 'condition'
condition = function() return vim.fn.filereadable 'go.mod' == 1 end,
```

`condition` is a table with two keys, both optional:

```lua
condition = { filetype = { 'go', 'gomod' }, dir = '/home/me/project' }
```

To gate on anything else — does an ancestor hold this file, is this the right
project — do it inside `builder`/`generator` and return a string when it does
not apply. That is what `shared.find` is for.

## Helpers in `overseer.shared`

| Helper | Does |
|---|---|
| `shared.find(marker, dir)` | Nearest ancestor of `dir` holding `marker` |
| `shared.stem()` | Current buffer name without extension: `problem02.cpp` → `problem02` |
| `shared.build_components` | quickfix + inline diagnostics |
| `shared.run_components` | `open_output` float, focused — needed for stdin programs |
| `shared.setup_components` | bare quickfix, for configure steps |
| `shared.chain_run(components, task)` | Adds a `run_after` step safely |

Use `shared.chain_run` rather than `vim.tbl_flatten` when appending a
`run_after`. `tbl_flatten` recurses into the component's own `statuses`/`tasks`
tables and silently breaks it.

## Components

| Component | Does |
|---|---|
| `on_output_quickfix` | Parses errors into quickfix. `open_on_match = true` to pop up on failure. `set_diagnostics = true` for inline squiggles |
| `on_result_diagnostics` | Inline diagnostics from the task result |
| `open_output` | Shows the output. `on_start = 'always'`, and `focus = true` so you can type into programs that read stdin |
| `run_after` | Chains a second task. `statuses = { 'SUCCESS' }` to run only on success |
| `restart_on_save` | Re-runs when a matched file changes |

## Ad-hoc commands

`:OverseerShell <cmd>` runs any command as a tracked task, no file needed.
Bound to `OS`:

```
:OS npm run dev
:OS tail -f log.txt
```

Write a template only for commands you run often.

## A key for a custom tag

If your task doesn't fit the four tags, add a key in
`lua/plugins/overseer.lua`:

```lua
{ '<leader>rt', function() require('overseer').run_task { tags = { 'test' }, first = true } end, desc = '[T]est' },
```

## Per-project tasks

For tasks that only make sense in one repo, register them from that repo rather
than here — `.nvim.lua` with `vim.o.exrc = true`:

```lua
require('overseer').register_template {
  name = 'Project: serve',
  condition = { dir = vim.fn.getcwd() },
  builder = function()
    return { cmd = { 'npm', 'run', 'serve' } }
  end,
}
```

Keep graded or coursework repos clean — prefer `OS`, or a `.nvim.lua` in a
parent directory.

The built-in `vscode` provider also reads a project's `.vscode/tasks.json`.
