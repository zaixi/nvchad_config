local M = {}

local merge_tb = vim.tbl_deep_extend

local ok, err = pcall(require, "core.utils")
if not ok then
  print("Error loading " .. module .. "\n\n" .. err)
else
  M = err
end

M.plugs = {}

M.rev_tab = function(tab)
  local revtab = {}
  for _, v in pairs(tab) do
    revtab[v] = true
  end
  return revtab
end

M.file_exists = function(path)
  local file = io.open(path, "rb")
  if file then file:close() end
  return file ~= nil
end

M.exec = function(cmd, raw)
    local f = assert(io.popen(cmd, 'r'))
    local s = assert(f:read('*a'))
    f:close()
    if raw then return s end
    s = string.gsub(s, '^%s+', '')
    s = string.gsub(s, '%s+$', '')
    s = string.gsub(s, '[\n\r]+', ' ')
    return s
end

local packadd_plugin = function(plugin)
   -- local PlugMg = require("core.utils")
   local user_plugins = require "core.utils".load_config().plugins
  --print("num: " .. #packer.plugs)
  local plugin_name = nil
  if plugin["module"] ~= nil then
    plugin_name = plugin["module"]
  else
    -- 去掉仓库用户名
    plugin_name = string.sub(plugin[1], string.find(plugin[1], '/') + 1, -1)
    -- 去掉仓库尾部的 .nvim
    if string.find(plugin_name, '%.') then
      plugin_name = string.sub(plugin_name, 1, string.find(plugin_name, '%.') - 1)
    end
  end
  -- print("plugin_name: " .. plugin_name)
  --function_is_exists("plugins/configs/" .. plugin_name, "setup")
  -- t = os.date("*t", os.time());

  -- print(PlugMg.config_path .. plugin_name .. ".lua")
  -- if PlugMg.file_exists(PlugMg.config_path .. plugin_name .. ".lua") then
  --   -- plugin[config] = PlugMg.override_req("bufferline", "plugins.configs.bufferline", "config")
    -- plugin["setup"] = PlugMg.override_req(plugin_name, "setup")
    -- plugin["config"] = { PlugMg.override_req(plugin_name, "config") }
    -- plugin["config"] = M.init()
  -- end

  -- PlugMg.plugs[#PlugMg.plugs + 1] = plugin
  --print(type(table.remove(plugin, 1)))
  --print(vim.inspect(plugin))
  user_plugins[table.remove(plugin, 1)] = plugin
end

M.Plug = function(plugins)
  local plugin = nil
  if type(plugins) == "string" then
    plugin = {plugins}
  elseif type(plugins) == "table" then
    if type(plugins[1]) == "string" then
      plugin = plugins
    elseif type(plugins[1]) == "table" then
      for k, v in ipairs(plugins) do
        M.Plug(v)
      end
      return
    else
      error("Unsupported format: ", plugins)
    end
  end
  packadd_plugin(plugin)
end

M.window_smart_close = function()
    vim.cmd [[

    function! s:is_float(winid) abort
    if a:winid > 0 && exists('*nvim_win_get_config')
        try
        return has_key(nvim_win_get_config(a:winid), 'col')
        catch
        return 0
        endtry
    else
        return 0
    endif
    endfunction

    let ignorewin = get(g:,'spacevim_smartcloseignorewin',['OUTLINE', 'NvimTree_1', 'vimfiler:default'])
    let ignoreft = get(g:, 'spacevim_smartcloseignoreft',['Outline', 'NvimTree'])
    let num = winnr('$')
    for i in range(1,num)
        if index(ignorewin , bufname(winbufnr(i))) != -1 || index(ignoreft, getbufvar(bufname(winbufnr(i)),'&filetype')) != -1
            let num = num - 1
        " elseif getbufvar(winbufnr(i),'&buftype') ==# 'quickfix'
        "     let num = num - 1
        elseif getwinvar(i, '&previewwindow') == 1 && winnr() !=# i
            let num = num - 1
        elseif exists('*win_getid') && s:is_float(win_getid(i))
            let num = num - 1
        endif
    endfor
    if num == 1
        "lua require('core.utils').close_buffer()
        lua require("nvchad_ui.tabufline").close_buffer()
    else
        quit
    endif
    ]]
end

M.load_mappings = function(section, mapping_opt)
  local function set_section_map(section_values)
    if section_values.plugin then
      return
    end
    section_values.plugin = nil

    map_name = {}
    local chadrc_exists, chadrc = pcall(require, "custom.chadrc")
    if chadrc_exists then
      map_name = chadrc.map_name
    end

    for mode, mode_values in pairs(section_values) do
      local default_opts = merge_tb("force", { mode = mode }, mapping_opt or {})
      for keybind, mapping_info in pairs(mode_values) do
        -- merge default + user opts
        local opts = merge_tb("force", default_opts, mapping_info.opts or {})

        mapping_info.opts, opts.mode = nil, nil
        opts.desc = mapping_info[2]
        if mapping_info['name'] ~= nil then
          --print(vim.inspect(mapping_info))
          map_name[mode][keybind] = mapping_info
        else
          vim.keymap.set(mode, keybind, mapping_info[1], opts)
        end
      end
    end
  end

  local mappings = require("core.utils").load_config().mappings

  if type(section) == "string" then
    mappings[section]["plugin"] = nil
    mappings = { mappings[section] }
  end

  for _, sect in pairs(mappings) do
    set_section_map(sect)
  end
end

return M
