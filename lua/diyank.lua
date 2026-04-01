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

    if message ~= '' then
        print("Yanked Errors")
    else
        print("No diagnostics under cursor")
    end
    vim.fn.setreg(config.options.register, message)
    return message
end

function M.yankWithDiagnostic()
    local lines = {}
    local mode = vim.fn.mode()

    -- Get selected lines or current line
    if mode:match("[vV]") then
        local start_pos = vim.fn.getpos("'<")
        local end_pos = vim.fn.getpos("'>")
        lines = vim.api.nvim_buf_get_lines(0, start_pos[2]-1, end_pos[2], false)
    else
        local lineNum = vim.fn.line('.')-1
        lines = {vim.api.nvim_buf_get_lines(0, lineNum, lineNum+1, false)[1]}
    end

    -- Get all diagnostics for buffer
    local diags = vim.diagnostic.get(0, {})
    local diag_map = {}

    -- Create map of line numbers to diagnostics
    for _, diag in ipairs(diags) do
        if not diag_map[diag.lnum] then
            diag_map[diag.lnum] = {}
        end
        table.insert(diag_map[diag.lnum], diag)
    end

    -- Append diagnostics as comments
    local result = {}
    for i, line in ipairs(lines) do
        local current_line = line
        local line_diags = diag_map[i-1] -- lnum is 0-based

        if line_diags then
            for _, diag in ipairs(line_diags) do
                current_line = current_line .. " -- " .. ErrorCodes[diag.severity] .. ": " .. diag.message
            end
        end

        table.insert(result, current_line)
    end

    local yank_text = table.concat(result, "\n")
    vim.fn.setreg(config.options.register, yank_text)
    return yank_text
end

function M.setup(opts)
    config.setOptions(opts)
end

return M
