# diyank

A very minimal Neovim plugin to copy diagnostics from the current line to clipboard/register.

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    dir = "Hippasusss/diyank",
    keys = {
        {"<leader>yd", function() require("diyank").copyDiagnosticFromCurrentLine() end, mode = {"n"}},
    },
    opts = { register = "+" } -- default register is unnamed. using this will use the sytem clipboard instead
}
```
## Usage

1. Move cursor to line with diagnostic
2. Press `<leader>yd` (default mapping)
