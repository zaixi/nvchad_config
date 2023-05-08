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

-- telescope grep_string {{{
local get_visual_selection = function()
  local mode = vim.fn.mode()
  if mode ~= "v" and mode ~= "V" and mode ~= "CTRL-V" and mode ~= "\22" then
    return nil
  end
  vim.cmd [[visual]]
  local _, start_row, start_col, _ = unpack(vim.fn.getpos "'<")
  local _, end_row, end_col, _ = unpack(vim.fn.getpos "'>")
  if start_row > end_row or (start_row == end_row and start_col > end_col) then
    start_row, end_row = end_row, start_row
    start_col, end_col = end_col, start_col
  end
  local lines = vim.fn.getline(start_row, end_row)
  local n = 0
  for _ in pairs(lines) do
    n = n + 1
  end
  if n <= 0 then
    return nil
  end
  lines[n] = string.sub(lines[n], 1, end_col)
  lines[1] = string.sub(lines[1], start_col)
  return table.concat(lines, "\n")
end

local opts_contain_invert = function(args)
  local invert = false
  local files_with_matches = false

  for _, v in ipairs(args) do
    if v == "--invert-match" then
      invert = true
    elseif v == "--files-with-matches" or v == "--files-without-match" then
      files_with_matches = true
    end

    if #v >= 2 and v:sub(1, 1) == "-" and v:sub(2, 2) ~= "-" then
      local non_option = false
      for i = 2, #v do
        local vi = v:sub(i, i)
        if vi == "=" then -- ignore option -g=xxx
          break
        elseif vi == "g" or vi == "f" or vi == "m" or vi == "e" or vi == "r" or vi == "t" or vi == "T" then
          non_option = true
        elseif non_option == false and vi == "v" then
          invert = true
        elseif non_option == false and vi == "l" then
          files_with_matches = true
        end
      end
    end
  end
  return invert, files_with_matches
end


--function! VisualSelectiosn()
--  try
--    let a_save = @-
--    normal! gv"-y
--    return @-
--  finally
--    let @- = a_save
--  endtry
--endfunction

local escape_chars = function(string)
  return string.gsub(string, "[%(|%)|\\|%[|%]|%-|%{%}|%?|%+|%*|%^|%$|%.]", {
    ["\\"] = "\\\\",
    ["-"] = "\\-",
    ["("] = "\\(",
    [")"] = "\\)",
    ["["] = "\\[",
    ["]"] = "\\]",
    ["{"] = "\\{",
    ["}"] = "\\}",
    ["?"] = "\\?",
    ["+"] = "\\+",
    ["*"] = "\\*",
    ["^"] = "\\^",
    ["$"] = "\\$",
    ["."] = "\\.",
  })
end

M.grep_string = function(opts)
    local finders = require "telescope.finders"
    local make_entry = require "telescope.make_entry"
    local pickers = require "telescope.pickers"

    local conf = require("telescope.config").values
    local flatten = vim.tbl_flatten
    opts.cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.loop.cwd()
    local vimgrep_arguments = vim.F.if_nil(opts.vimgrep_arguments, conf.vimgrep_arguments)
    local word

    word = get_visual_selection() or vim.fn.expand "<cword>"
    word = vim.F.if_nil(opts.search, word)
    local search = opts.use_regex and word or escape_chars(word)

    local additional_args = {}
    if opts.additional_args ~= nil then
        if type(opts.additional_args) == "function" then
            additional_args = opts.additional_args(opts)
        elseif type(opts.additional_args) == "table" then
            additional_args = opts.additional_args
        end
    end

    if search == "" then
        search = { "-v", "--", "^[[:space:]]*$" }
    else
        search = { "--", search }
    end

    local args
    if visual == true then
        args = flatten {
            vimgrep_arguments,
            additional_args,
            search,
        }
    else
        args = flatten {
            vimgrep_arguments,
            additional_args,
            opts.word_match,
            search,
        }
    end

    opts.__inverted, opts.__matches = opts_contain_invert(args)

    if opts.grep_open_files then
        for _, file in ipairs(get_open_filelist(opts.grep_open_files, opts.cwd)) do
            table.insert(args, file)
        end
    elseif opts.search_dirs then
        for _, path in ipairs(opts.search_dirs) do
            table.insert(args, vim.fn.expand(path))
        end
    end

    opts.entry_maker = opts.entry_maker or make_entry.gen_from_vimgrep(opts)
    pickers
        .new(opts, {
            prompt_title = "Find Word (" .. word:gsub("\n", "\\n") .. ")",
            finder = finders.new_oneshot_job(args, opts),
            previewer = conf.grep_previewer(opts),
            sorter = conf.generic_sorter(opts),
        })
        :find()
end

-- }}}

return M
