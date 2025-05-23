local M = {}
local default_options = {
    register = "",
}

M.options = {}

function M.setOptions(opts)
    M.options = vim.tbl_deep_extend("force", default_options, opts or {})
    return M.options
end

return M
