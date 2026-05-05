# diyank

A very minimal Neovim plugin to copy diagnostics from the current line to a register.

## Installation

### lazy.nvim

```lua
{
    "Hippasusss/diyank",
    keys = {
        -- Example keymaps — pick whichever you want
        {"<leader>yd", function() require("diyank").yankDiagnosticFromCurrentLine() end, mode = {"n"}},
        {"<leader>yD", function() require("diyank").yankWithDiagnostic() end, mode = {"n", "x"}},
    },
    opts = { register = "+" },
}
```

### vim.pack

```bash

vim.pack.add({
    "https://github.com/Hippasusss/diyank" 
})
```

Then configure mappings in your `init.lua`:

```lua
vim.keymap.set("n", "<leader>yd", function() require("diyank").yankDiagnosticFromCurrentLine() end)
vim.keymap.set({"n", "x"}, "<leader>yD", function() require("diyank").yankWithDiagnostic() end)
```

## Configuration

```lua
require("diyank").setup({
    register = "+",   -- default: "+" (system clipboard)
})
```

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `register` | `string` | `"+"` | Register to yank diagnostics into |

## Functions

### `yankDiagnosticFromCurrentLine()`

Yanks all diagnostics on the current line as plain text. Each diagnostic is formatted as `Severity: message`, one per line.

`<leader>yd` → yanks diagnostics under cursor.

### `yankWithDiagnostic()`

Yanks the current line (or visual selection) with diagnostics appended as inline comments.

- **Normal mode**: yanks the current line with its diagnostics appended as `-- Severity: message`.
- **Visual mode**: yanks the selected lines, each with its diagnostics appended.

```
// Before 
int x = NULL;

// Yanked
int x = NULL; -- Warning: assignment from NULL
```
