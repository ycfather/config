local M = {}

M.has_plugin = function(plugin)
    local lazy_config = pcall(require, "lazy.core.config")
    if not lazy_config then
        return false
    end
    return require("lazy.core.config").plugins[plugin] ~= nil
end

M.safe_require = function(module)
    local ok, result = pcall(require, module)
    if ok then
        return result
    else
        vim.notify("Failed to load module: " .. module, vim.log.levels.WARN)
        return nil
    end
end

M.executable = function(name)
    return vim.fn.executable(name) == 1
end

M.has_file_upwards = function(startpath, names)
    local found = vim.fs.find(
        names,
        { upward = true, path = startpath, stop = vim.loop.os_homedir() }
    )
    return #found > 0
end

M.merge_tables = function(...)
    return vim.tbl_deep_extend("force", ...)
end

M.get_mason_path = function(package)
    local mason_path = vim.fn.stdpath("data") .. "/mason/packages/" .. package
    if vim.fn.isdirectory(mason_path) == 1 then
        return mason_path
    end
    return nil
end

M.create_augroup = function(name, opts)
    opts = opts or { clear = true }
    return vim.api.nvim_create_augroup(name, opts)
end

return M