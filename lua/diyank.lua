local config = require("diyank.config")

local M = {}

local ErrorCodes = { "Error", "Warning", "Info", "Hint" }

local function format_diagnostic(diag)
    local severity = ErrorCodes[diag.severity] or "Unknown"
    return severity .. ": " .. diag.message
end

function M.yankDiagnosticFromCurrentLine()
    local lineNum = vim.fn.line('.') - 1
    local diags = vim.diagnostic.get(0, {})
    if not diags or #diags == 0 then
        print("No diagnostics")
        return
    end

    local lines = {}
    for _, diagnostic in ipairs(diags) do
        if diagnostic.lnum == lineNum then
            table.insert(lines, format_diagnostic(diagnostic))
        end
    end

    if #lines > 0 then
        local message = table.concat(lines, "\n")
        print("Yanked Errors")
        vim.fn.setreg(config.options.register, message)
        return message
    else
        print("No diagnostics under cursor")
    end
end

function M.yankWithDiagnostic()
    local mode = vim.fn.mode()
    local start_line
    local lines

    -- Get selected lines or current line
    if mode:match("[vV]") then
        local start_pos = vim.fn.getpos("'<")
        local end_pos = vim.fn.getpos("'>")
        start_line = start_pos[2] - 1
        lines = vim.api.nvim_buf_get_lines(0, start_line, end_pos[2], false)
    else
        start_line = vim.fn.line('.') - 1
        lines = vim.api.nvim_buf_get_lines(0, start_line, start_line + 1, false)
    end

    -- Get all diagnostics for buffer
    local diags = vim.diagnostic.get(0, {})

    -- Create map of line numbers to diagnostics
    local diag_map = {}
    for _, diag in ipairs(diags) do
        diag_map[diag.lnum] = diag_map[diag.lnum] or {}
        table.insert(diag_map[diag.lnum], diag)
    end

    -- Append diagnostics as comments
    local result = {}
    local found = false
    for i, line in ipairs(lines) do
        local line_diags = diag_map[start_line + i - 1] -- lnum is 0-based
        local current_line = line

        if line_diags then
            found = true
            for _, diag in ipairs(line_diags) do
                current_line = current_line .. " -- " .. format_diagnostic(diag)
            end
        end

        table.insert(result, current_line)
    end

    if found then
        local yank_text = table.concat(result, "\n")
        print("Yanked " .. #result .. " line(s) with diagnostics")
        vim.fn.setreg(config.options.register, yank_text)
        return yank_text
    else
        print("No diagnostics on selected line(s)")
    end
end

function M.setup(opts)
    config.setOptions(opts)
end

return M
