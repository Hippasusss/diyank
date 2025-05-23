local config = require("config")

local M = {}

local ErrorCodes = { "Error", "Warning", "Info", "Hint" }

function M.yankDiagnosticFromCurrentLine()

    local lineNum = vim.fn.line('.') - 1;

    local diags = vim.diagnostic.get(0, {})
    if not diags or #diags == 0 then
        print("No diagnostics")
        return
    end

    local message = ''
    for i, diagnostic in ipairs(diags) do
        if diagnostic.lnum == lineNum then
            message = message .. string.format("%d %s: %s\n", i, ErrorCodes[diagnostic.severity], diagnostic.message)
        end
    end

    vim.fn.setreg(config.options.register, message)
    print("Copied diagnostics to clipboard.")
end

function M.setup(opts)
    config.setOptions(opts)
end

return M
