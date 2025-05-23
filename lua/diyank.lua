local config = require("diyank.config")

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

    print("Yanked Errors")
    vim.fn.setreg(config.options.register, message)
    return message
end

function M.yankWithDiagnostic()
end

function M.setup(opts)
    config.setOptions(opts)
end

return M
