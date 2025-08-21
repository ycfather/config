local M = {}

M.set = function(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
end

M.create_mapping_group = function(prefix, name)
    local ok, which_key = pcall(require, "which-key")
    if ok then
        which_key.add({ { prefix, group = name } })
    end
end

M.map_group = function(mappings, opts)
    opts = opts or {}
    for mode, mode_mappings in pairs(mappings) do
        for lhs, mapping in pairs(mode_mappings) do
            local rhs = mapping.rhs or mapping[1]
            local desc = mapping.desc or mapping[2]
            local map_opts = vim.tbl_extend("force", opts, mapping.opts or {})
            map_opts.desc = desc
            M.set(mode, lhs, rhs, map_opts)
        end
    end
end

M.buf_map = function(bufnr, mode, lhs, rhs, opts)
    opts = opts or {}
    opts.buffer = bufnr
    M.set(mode, lhs, rhs, opts)
end

M.create_buf_mappings = function(bufnr, mappings)
    for mode, mode_mappings in pairs(mappings) do
        for lhs, mapping in pairs(mode_mappings) do
            M.buf_map(bufnr, mode, lhs, mapping.rhs, { desc = mapping.desc })
        end
    end
end

return M