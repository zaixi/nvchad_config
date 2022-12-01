local function termcodes(str)
   return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local M = {}
M.map = {}
local map = M.map
local core_map = require "core.mappings"

core_map.lspconfig = {}
core_map.nvimtree= {}
core_map.bufferline = {}
core_map.tabufline = {}
core_map.comment = {}
core_map.telescope = {}
core_map.whichkey = {}
core_map.general = {}

map.user = {}

map.disabled = {
    n = {
        ["<leader>e"] = "",

        ["<leader>h"] = "",
        ["<leader>v"] = "",
    },
}

map.user.c = {
    -- navigate within cmdline mode
    --["<c-a>"] = { "<home>", "跳到行首"},
    -- ["<c-e>"] = { "<end>", "跳到行尾"},
    -- ["<C-h>"] = { "<Left>", "  move left" },
    -- ["<C-l>"] = { "<Right>", " move right" },
    -- ["<C-j>"] = { "<Down>", " move down" },
    -- ["<C-k>"] = { "<Up>", " move up" },
}

vim.cmd [[
    cnoremap <c-a> <home>
    cnoremap <c-e> <end>
    cnoremap <c-h> <left>
    cnoremap <c-l> <right>
    cmap <c-k> <up>
    cmap <c-j> <down>
    cnoremap <c-d> <del>
    cnoremap <c-w> <del>

    " 使用 < > 在可视模式下缩进
    xnoremap > >gv|
    xnoremap < <gv

    " vim-surround 设置
    xmap " S"
    xmap ' S'
    xmap ` S`
    xmap [ S[
    xmap ( S(
    xmap { S{
    xmap } S}
    xmap ] S]
    xmap ) S)
    " xmap > S>
]]

map.user.i = {
    -- go to  beginning and end
    ["<C-a>"] = { "<ESC>^i", "論 移到行首" },
    ["<C-e>"] = { "<End>", "壟 移到行尾" },

    -- navigate within insert mode
    ["<C-h>"] = { "<Left>", "  左移" },
    ["<C-l>"] = { "<Right>", " 右移" },
    ["<C-j>"] = { "<Down>", " 下移" },
    ["<C-k>"] = { "<Up>", " 上移" },
}

map.user.t = {
     ["<C-x>"] = { termcodes "<C-\\><C-N>", "   退出终端模式" },
}

map.user.v = {
    ["<leader>t"] = {name = '切换'},
    ["<leader>ts"] = { ":Translate ZH -output=floating  <CR>", "翻译选择文本" },
    ["<leader>/"] = { ":lua require('Comment.api').toggle_linewise_op(vim.fn.visualmode())  <CR>", "蘒  切换行注释" },
    ["<leader>/c"] = { ":lua require('Comment.api').toggle_linewise_op(vim.fn.visualmode())  <CR>", "切换行注释" },
    ["<leader>/b"] = { ":lua require('Comment.api').toggle_blockwise_op(vim.fn.visualmode())  <CR>", "切换块注释" },
    -- [">"] = {">gv|", "向右缩进"},
    -- ["<"] = {"<gv", "向左缩进"},
    -- ["<TAB>"] = {">gv|", "向右缩进"},
    -- ["S-<TAB>"] = {"<gv|", "向左缩进"},
    ["J"] = {":m'>+<cr>`<my`>mzgv`yo`z", "向下移动行"},
    ["K"] = {"m'<-2<cr>`>my`<mzgv`yo`", "向上移动行"},
}

map.user.n = {

-- general {{{
     ["<ESC>"] = { "<cmd> noh  <CR>", "  不高亮" },
     ["<c-a>"] = {"<home>", "跳到行首"},
     ["<c-e>"] = {"<end>", "跳到行尾"},

     -- 在窗口之间切换
     ["<C-h>"] = { "<C-w>h", " 左窗口" },
     ["<C-l>"] = { "<C-w>l", " 右窗口" },
     ["<C-j>"] = { "<C-w>j", " 下窗口" },
     ["<C-k>"] = { "<C-w>k", " 上窗口" },

     ["<C-left>"] = { ":TmuxNavigateLeft <CR>", "tmux  左窗口" },
     ["<c-right>"] = { ":TmuxNavigateRight  <CR>", "tmux  右窗口" },
     ["<C-up>"] = { ":TmuxNavigateUp <CR>", "tmux  上窗口" },
     ["<c-down>"] = { ":TmuxNavigateDown <CR>", "tmux  下窗口" },

     ["<C-s>"] = { "<cmd> w  <CR>", "﬚  保存文件" },
     ["<C-c>"] = { "<cmd> %y+  <CR>", "复制整个文件" },


     -- 更新/插件
     ["<leader>u"] = { "<cmd> NvChadUpdate  <CR>", "  更新/ui" },
     ["<leader>uu"] = { "<cmd> NvChadUpdate  <CR>", "  更新 nvchad" },
     ["<leader>up"] = { "<cmd> PackerSync <CR>", "  插件" },
     ["<leader>ups"] = { "<cmd> PackerStatus <CR>", "  插件状态" },
     ["<leader>upu"] = { "<cmd> PackerSync <CR>", "  插件更新" },
     ["<leader>upc"] = { "<cmd> PackerSync <CR>", "  插件编译" },
     ["<leader>upt"] = { "<cmd> LuaCacheProfile <CR>", "  插件加载时间" },

     -- cycle through buffers
     ["<TAB>"] = { "<cmd> BufferLineCycleNext <CR>", "  下一个 buffer" },
     ["<S-Tab>"] = { "<cmd> BufferLineCyclePrev <CR>", "  上一个 buffer" },

     ['q'] =  {":lua require('custom.utils').window_smart_close() <CR>", "   关闭window"},

--}}}

-- 新建 {{{
    ["<leader>n"] = {name = '烙 新建'},
  -- new nvterm
  ["<leader>nt"] = {name = '  终端'},
  ["<leader>nth"] = { ":lua require('nvterm.terminal').new 'horizontal' <CR>", "  水平新终端" },
  ["<leader>ntv"] = { ":lua require('nvterm.terminal').new 'vertical' <CR>", " 垂直新终端" },
  -- new buffer
  ["<leader>nb"] = { "<cmd> enew  <CR>", "烙 新建 buffer" },
-- }}}

-- 窗口 {{{
    ["<leader>w"] = {name = '  窗口'},
    ['<leader>wp'] = { "<cmd>WinShift <CR>", "重新排列窗口"},
    ["<leader>ww"] = { "<cmd>ChooseWin <CR>", "选择窗口" },
    ["<leader>wm"] = { "<cmd>ChooseWinSwap  <CR>", "交换窗口" },
    ["<leader>wd"] = { "<c-w>c  <CR>", "删除窗口" },
-- }}}

-- 切换 {{{
    ["<leader>t"] = { name = "  切换" },
    ["<leader>tt"] = { "<cmd>SymbolsOutline  <CR>", "标签浏览" },
    ["<leader>tw"] = { "<cmd>ToggleWhitespace <CR>", "切换突出显示行尾空格" },
    ["<leader>ti"] = { "<cmd>IndentBlanklineToggle <CR>", "切换缩进显示" },

    ["<leader>th"] = { name = "  切换高亮" },

    ["<leader>thh"] = { ":set cursorline! <CR>", '切换行高亮'},
    ["<leader>thc"] = { ":set cursorcolumn! <CR>", '切换列高亮'},
    ["<leader>thi"] = { "IndentLinesToggle <CR>", '切换缩进高亮'},
    ["<leader>thn"] = { ":set number! <CR>", '关闭/显示行号'},
    ["<leader>thr"] = { ":set relativenumber! <CR>", '切换相对行号'},
    ["<leader>tl"] = { ":set list! <CR>", '切换隐藏的字符'},
    ["<leader>tc"] = { ":call ToggleMouseCopy() <CR>",  '切换鼠标粘贴'},
    -- }}}

    -- 注释 {{{
    ["<leader>/"] = { ":lua require('Comment.api').toggle_current_linewise() <CR>", "  注释" },
    ["<leader>/c"] = { ":lua require('Comment.api').toggle_current_linewise() <CR>", "切换行注释" },
    ["<leader>/b"] = { ":lua require('Comment.api').toggle_current_blockwise() <CR>", "切换块注释" },

    ["<leader>/f"] = { ":Dox <CR>", "生成函数注释" },
    ["<leader>/l"] = { ":DoxLic <CR>", "生成许可证注释" },
    ["<leader>/a"] = { ":DoxAuthor <CR>", "生成作者注释" },

    --- }}}

    -- git {{{
    ["<leader>g"] = { name = "  git" },
    ["<leader>gD"] = { "<cmd>Gitsigns diffthis  <CR>", "diff" },
    ["<leader>gc"] = { "<cmd>DiffviewClose <CR>", "关闭 Diffview" },
    ["<leader>gd"] = { "<cmd>DiffviewOpen <CR>", "diff" },
-- :DiffviewOpen
-- :DiffviewOpen HEAD~2
-- :DiffviewOpen HEAD~4..HEAD~2
-- :DiffviewOpen d4a7b0d
-- :DiffviewOpen d4a7b0d..519b30e
-- :DiffviewOpen origin/main...HEAD
    ["<leader>gL"] = { "<cmd>DiffviewFileHistory <CR>", "git log 当前仓库" },
    ["<leader>gl"] = { "<cmd>DiffviewFileHistory %<CR>", "git log 当前文件" },
-- :DiffviewFileHistory
-- :DiffviewFileHistory %
-- :DiffviewFileHistory path/to/some/file.txt
-- :DiffviewFileHistory path/to/some/directory
-- :DiffviewFileHistory include/this and/this :!but/not/this
-- :DiffviewFileHistory --range=origin..HEAD
-- :DiffviewFileHistory --range=feat/example-branch
    ["<leader>gb"] = { "<cmd>Gitsigns toggle_current_line_blame <CR>", "当前行 blame" },
    ["<leader>gB"] = { "<cmd>Gblame <CR>", "所有行 blame" },
    ["<leader>gs"] = { "<cmd>Gstatus <CR>", "git status" },
-- }}}

    -- buffer {{{
    ["<leader>b"] = { name = "﬘  Buffers" },
    ["<leader>bd"] = { ":bd  <CR>", "删除此buffer" },
    ["<leader>bb"] = { "<cmd>Telescope buffers  <CR>", "buf 浏览器" },
    ["<leader>bn"] = { "<cmd>BufferLineCycleNext  <CR>", "切换下个buf(tab等效)" },
    ["<leader>bp"] = { "<cmd>BufferLineMovePrev  <CR>", "切换上个buf(s-tab等效)" },
    ["<leader>b<TAB>"] = { "<cmd>BufferLineMoveNext  <CR>", "移动buf到下一个" },
    ["<leader>b<S-Tab>"] = { "<cmd>BufferLineMovePrev  <CR>", "移动buf到上一个" },
    --- }}}

    -- 文件/查找 {{{
    ["<leader>f"] = { name = "  查找/文件" },
    ["<leader>ff"] = { "<cmd>Telescope find_files  <CR>", "查找文件" },
    ["<leader>fF"] = { ":lua vim.cmd('Telescope find_files find_command=fdfind,--type,f,-p,' .. vim.fn.expand('<cfile>'))  <CR>", "查找光标下文件" },
    ["<leader>fg"] = { "<cmd>Telescope git_files  <CR>", "查找文件(git范围)" },
    ["<leader>fa"] = { "<cmd>Telescope find_files follow=true no_ignore=true hidden=true  <CR>", "查找所有文件" },
    ["<leader>fo"] = { "<cmd>Telescope oldfiles  <CR>", "查找历史文件" },
    ["<leader>fk"] = { name = "   查找按键" },
    ["<leader>fkt"] = { "<cmd>Telescope keymaps <CR>", "Telescope 查找" },
    ["<leader>fkk"] = { ":WhichKey <CR>", "WhichKey 查找" },
    ["<leader>fh"] = { "<cmd>Telescope themes <CR>", "   查找主题" },
    ["<leader>ft"] = { "<cmd>Telescope terms <CR>", "   查找 term" },
    -- 文件
    ["<leader>fw"] = { ":SudaWrite  <CR>", "以sudo保存文件" },
    ["<leader>fr"] = { ":SudaRead  <CR>", "以sudo读取文件" },
    ["<leader>fl"] = { "<cmd>NvimTreeToggle  <CR>", "切换文件树" },
    ["<leader>fe"] = { "<cmd>NvimTreeFocus  <CR>", "跳转到文件树" },
    -- }}}

    -- 搜索/符号 {{{
    ["<leader>s"] = { name = "  搜索/符号" },
    ["<leader>sa"] = { "<cmd>Telescope <CR>", "Telescope" },
    ["<leader>ss"] = { "<cmd>Telescope grep_string <CR>", "查找当前符号" },
    ["<leader>sw"] = { "<cmd>Telescope live_grep <CR>", "实时查找" },
    ["<leader>sq"] = { "<cmd>Telescope quickfix <CR>", "quickfix查找" },
    ["<leader>sm"] = { ":lua require'marks'.mark_state:all_to_list('quickfixlist') vim.cmd('Telescope quickfix') <CR>", "查找mark" },
    -- }}}

    -- git {{{
    ["<leader>sg"] = { name =  "git" },
    ["<leader>sgm"] = { "<cmd>Telescope git_commits <CR> <CR>", "commit" },
    ["<leader>sgt"] = { "<cmd>Telescope git_status <CR> <CR>", "status" },
    -- }}}

    -- tag/标签 {{{
    ["<leader>m"] = { name = "  tag/标签" },
    ["<leader>mm"] = { name = "标签" },
    ["<leader>mma"] = { ":lua require'marks'.set_next() <CR>", "添加标签" },
    ["<leader>mmd"] = { ":lua require'marks'.delete_line() <CR>", "当前标签" },
    ["<leader>mmD"] = { ":lua require'marks'.delete_buf() <CR>", "删除所有标签" },
    ["<leader>mmn"] = { ":lua require'marks'.next() <CR>", "上一个标签" },
    ["<leader>mmp"] = { ":lua require'marks'.prev() <CR>", "下一个标签" },

    ["<leader>mt"] = { ":GscopeSwitchLayout <CR>", "切换 scope layout" },
    ["<leader>ms"] = { ":GscopeFind s <C-R><C-W> <CR>", "查找符号" },
    ["<leader>mg"] = { ":GscopeFind g <C-R><C-W> <CR>", "查找定义" },
    ["<c-]>"] = { ":Telescope lsp_handlers target=definitions <CR>", "查找定义" },
    ["<leader>mr"] = { ":GscopeFind c <C-R><C-W> <CR>", "查找引用" },
    ["<leader>mf"] = { ":GscopeFind f <C-R>=expand('<cfile>')<cr><cr>", "查找文件" },
    ["<leader>ma"] = { ":GscopeFind a <C-R><C-W> <CR>", "查找赋值" },
    -- }}}

    -- 跳转 {{{
    ["<leader>j"] = { name =  "ﭠ  跳转" },
    ["<leader>jj"] = {":HopChar1CurrentLine <CR>", "在当行按一个字符跳" },
    ["<leader>jJ"] = {":HopChar1", "按一个字符跳" },
    ["<leader>jp"] = {":HopPattern", "按Pattern跳" },
    ["<leader>jw"] = {":HopWord", "按单词跳" },
    ["s"] = {":HopChar1CurrentLine <CR>", "按字符跳"},
    ["f"] = {":HopWord <CR>", "按词跳"},
    -- }}}

    -- lsp {{{
      ["<leader>l"] = {name = '  lsp'},

      ["gD"] = { ":Telescope lsp_handlers target=declaration <CR>", "   lsp 声明" },
      ["gd"] = { ":Telescope lsp_handlers target=definitions <CR>", "   lsp 定义" },
      -- ["gd"] = { function ()
      --   vim.lsp.buf.definition()
      -- end, "定义"},
      ["K"] = { ":lua vim.lsp.buf.hover() <CR>", "   lsp 悬停提示" },
      ["gi"] = { ":Telescope lsp_handlers target=implementations <CR>", "   lsp 实现" },

      ["<leader>ld"] = { ":Telescope lsp_handlers target=definitions <CR>", "   lsp 定义" },
      ["<leader>lD"] = { ":Telescope lsp_handlers target=type_definitions <CR>", "   lsp 类型定义" },
      ["<leader>lr"] = { ":Telescope lsp_handlers target=references <CR>", "   lsp 调用" },
      ["<leader>li"] = { ":Telescope lsp_handlers target=declaration <CR>", "   lsp 声明" },
      ["<leader>lI"] = { ":Telescope lsp_handlers target=implementations <CR>", "   lsp 实现" },
      ["<leader>lk"] = { ":lua vim.lsp.buf.hoignature_helper() <CR>", "   lsp 悬停提示" },
      ["<leader>ls"] = { ":lua vim.lsp.buf.signature_help() <CR>", "   lsp 签名帮助" },
      ["<leader>lR"] = { ":lua require('ui.renamer').open() <CR>", "   lsp 重命名" },
      ["<leader>la"] = { ":lua vim.lsp.buf.code_action() <CR>", "   lsp 代码执行" },

      ["<leader>ll"] = { name = "   诊断" },
      ["<leader>llf"] = { ":lua vim.diagnostic.open_float() <CR>", "   lsp 诊断" },
      ["<leader>lln"] = { ":lua vim.diagnostic.goto_prev() <CR>", "   lsp 下一个诊断" },
      ["<leader>llp"] = { ":lua vim.diagnostic.goto_next() <CR>", "   lsp 上一个诊断" },
      ["<leader>lll"] = { ":lua vim.diagnostic.setloclist() <CR>", "   lsp 诊断列表" },

      ["<leader>lf"] = { ":lua vim.lsp.buf.formatting() <CR>", "   lsp 格式化" },

      ["<leader>lw"] = { name = "   添加工作区" },
      ["<leader>lwa"] = { ":lua vim.lsp.buf.add_workspace_folder() <CR>", "   添加工作区" },
      ["<leader>lwr"] = { ":lua vim.lsp.buf.remove_workspace_folder() <CR>", "   移除工作区" },
      ["<leader>lwl"] = { ":lua print(vim.inspect(vim.lsp.buf.list_workspace_folders())) <CR>", "   显示工作区" },
      -- }}}

      -- 文本/编辑 {{{
      ["<leader>x"] = {name = '﨣文本'},
      ["<leader>xa"] = { ":EasyAlign <CR>", "  文本对齐" },
      ["<leader>xd"] = {name = '删除'},

      ["<leader>xd "] = { ":lua vim.fn.Delete_extra_space() <CR>", "删除光标周围的额外空格" },
      ["<leader>xdw"] = { ":StripWhitespace <CR>", "删除行尾空格" },
      ["<leader>xi"] = {name = '改变符号风格'},
      ["<leader>xic"] = { ":lua vim.fn.LowerCamelCase() <CR>", "转换为小驼峰法" },
      ["<leader>xiC"] = { ":lua vim.fn.UpperCamelCase() <CR>", "转换为大驼峰法" },
      ["<leader>xi-"] = { ":lua vim.fn.Kebab_case() <CR>", "转换为中划线(-)法" },
      ["<leader>xi_"] = { ":lua vim.fn.Under_score() <CR>", "转换为下划线(_)法" },
      ["<leader>xiU"] = { ":lua vim.fn.Up_case() <CR>", "转换为宏定义" },
      ["<leader>xt"] = {name = 'Tab和SPC转换'},
      ["<leader>xtt"] = { ":lua vim.fn.Spa2Tab() <CR>", "空格转Tab" },
      ["<leader>xt "] = { ":lua vim.fn.Tab2Spa() <CR>", "Tab转空格" },

      ["<leader>xR"] = {name = '非整词替换'},
      ["<leader>xr"] = {name = '整词替换'},

      ["<leader>xrc"] = { ":call Replace(1, 1, input('Replace '.expand('<cword>').' with: '))<CR>", "询问替换" },
      ["<leader>xrw"] = { ":call Replace(0, 1, input('Replace '.expand('<cword>').' with: '))<CR>", "直接替换" },
      ["<leader>xRc"] = { ":call Replace(1, 0, input('Replace '.expand('<cword>').' with: '))<CR>", "询问替换" },
      ["<leader>xRw"] = { ":call Replace(0, 0, input('Replace '.expand('<cword>').' with: '))<CR>", "直接替换" },

      ["<leader>xu"] = { ":UndotreeToggle <CR>", "撤销树" },
      ["<leader>xy"] = { ":call copy2system() <CR>", "复制到系统" },
      ["<leader>xp"] = { ":call paste2system() <CR>", "从系统粘贴" },

      --}}}

}

return M
