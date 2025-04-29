






local config = require("config")

M = {}

function M.copyDiagnosticFromCurrentLine()

    local lineNum = vim.fn.line('.') - 1;

    local diags = vim.diagnostic.get(0, {})
    if not diags or #diags == 0 then
        print("No diagnostics")
        return
    end

    local message = ''
    for _, diagnostic in ipairs(diags) do
        if diagnostic.lnum == lineNum then
            message = message .. diagnostic.message
        end
    end

    vim.fn.setreg(config.options.register, message)
    print("Copied diagnostics to clipboard.")
end

function M.setup(opts)
    config.options = config.setAllOptions(opts)
end

return M
