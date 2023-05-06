local M = require "core.utils"
local merge_tb = vim.tbl_deep_extend

-- 覆盖 core.utils 的 load_mappings 以支持 which key 的 name {{{
M.load_mappings = function(section, mapping_opt)
  vim.schedule(function()
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

                    if mapping_info['name'] == nil then
          vim.keymap.set(mode, keybind, mapping_info[1], opts)
                    else
                        --print(vim.inspect(mapping_info))
                        map_name[mode][keybind] = mapping_info
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
  end)
end
-- }}}

-- 从 spacevim copy 的window_smart_closee {{{
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
--}}}
return M
