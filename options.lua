local options = {
    mapleader = " ",
    ------------------------------------------------------------
    -- 基础设置
    ------------------------------------------------------------
    conceallevel = 0,          -- ``在markdown文件中是可见的
    splitbelow = true,         -- 强制所有水平拆分到当前窗口下方
    splitright = true,         -- 强制所有垂直拆分到当前窗口右侧
    undofile = true,           -- 持久撤消
    clipboard = "unnamedplus", -- 允许neovim访问系统剪贴板
    backup = false,            -- 创建备份文件
    writebackup = false,       -- 保存时不备份
    swapfile = false,          -- 禁用交换文件
    cmdheight = 2,             -- neovim命令行中有更多空间用于显示消息
    updatetime = 300,          -- 更快完成,默认为4000毫秒,更新时间较长会导致明显的延迟和糟糕的用户体验
    shortmess = "c",           -- 不要将消息传递到| ins完成菜单|。
    ttimeout = true,           -- 打开功能键超时检测（终端下功能键为一串 ESC 开头的字符串）
    ttimeoutlen = 100,         -- 功能键超时检测(毫秒)
    timeoutlen = 400,

    winaltkeys = "no",         -- Windows 禁用 ALT 操作菜单（使得 ALT 可以用到 Vim里）
    wrap = false,              -- 关闭长行自动折行
    hidden = true,             -- 允许在有未保存的修改时切换缓冲区
    iskeyword = "_,@,%,#",     -- 以下字符被视为单词的一部分

    ruler = true,              -- 显示光标位置
    laststatus = 3,            -- 全局状态栏
    showtabline = 2,           -- 总是显示标签栏
    signcolumn = "yes",        -- 总是显示侧边栏（用于显示 mark/gitdiff/诊断信息）
    number = true,             -- 显示行号
    relativenumber = false,    -- 设置相对行号
    numberwidth = 2,           -- 将行号列宽设置为2{default 4}
    cursorcolumn = true,       -- 高亮光标所在列
    cursorline = true,         -- 高亮光标所在行
    scrolloff = 8,             -- 光标移动到顶部和底部时保持几行距离
    sidescrolloff = 8,         -- 光标左右两侧保留的最少屏幕列数

    ------------------------------------------------------------
    -- 搜索设置
    ------------------------------------------------------------
    ignorecase = true,        -- 搜索时忽略大小写
    smartcase = true,         -- 智能搜索大小写判断，默认忽略大小写，除非搜索内容包含大写字母
    hlsearch = true,          -- 高亮搜索内容
    incsearch = true,         -- 查找输入时动态增量显示查找结果

    ------------------------------------------------------------
    -- 编码设置
    ------------------------------------------------------------
    langmenu = "zh_CN.UTF-8", -- 菜单翻译的语言
    helplang = "cn",          -- 消息语言为中文
    encoding = "utf-8",       -- 文件默认编码
    fileencoding = "utf-8",   -- 写入文件使用的编码
    fileencodings = "ucs-bom,utf-8,gbk,gb18030,big5,euc-jp,latin1",  -- 打开文件时自动尝试下面顺序的编码

    ------------------------------------------------------------------------
    -- 其他设置
    ------------------------------------------------------------------------
    mouse = "",           -- 允许在neovim中使用鼠标
    showmatch = true,     -- 显示匹配的括号
    matchtime = 1,        -- 显示括号匹配的时间
    wildmenu = true,      -- 命令行菜单补全
    lazyredraw = true,    -- 延迟绘制（提升性能）
    formatoptions = "mB", -- 如遇Unicode值大于255的文本,不必等到空格再折行,合并两行中文时,不在中间加空格
    pumheight = 15,       -- 自动补全菜单的高度
    title = true,         -- 窗口标题会被设为 'titlestring' 的值
    termguicolors = true, -- 在终端上使用 highlight-guifg 和 highlight-guibg 属性
    completeopt = { "menuone", "noselect" }, -- 主要是为了cmp
    diffopt = "internal,algorithm:patience", -- 更好的 Diff 选项
    -- disable tilde on end of buffer: https://github.com/neovim/neovim/pull/8546#issuecomment-643643758
    fillchars = { eob = " " },

    ------------------------------------------------------------
    -- 缩进和折叠(可以后期覆盖)
    ------------------------------------------------------------
    -- 行首的 <Tab>: 长度是 'shiftwidth'(smarttab on) 或者 'softtabstop'(smarttab off) 或者 tabstop(smarttab off && softtabstop = 0)
    -- 非行首的 <Tab>: 长度是 'softtabstop' 或者 tabstop(softtabstop=0)
    -- > 和 < 的缩进长度由 shiftwidth 决定
    -- expandtab: 置位时 tab 按键将解释成空格, 不置位时将 tab 按键解释成 shiftwidth或softtabstop个空格,当达到 tabstop 的之时合并成一个 tab(\t)
    -- 例子: shiftwidth=4 tabstop=8 softtabstop=4 noexpandtab 时, 按一次 TAB 是 4 个空格,按两次 TAB 是 TAB 符号,按3次 TAB 是一个 TAB 符号,加上 4 个空格
    smarttab = true,       -- 行首的 <Tab> 根据 'shiftwidth' 插入或删除空白
    shiftwidth = 8,        -- 缩进宽度
    expandtab = false,      -- 将制表符转换为空格
    tabstop = 8,           -- 将 TAB 显示成多少宽度
    autoindent = true,     -- 自动缩进
    cindent = true,        -- 打开 C/C++ 语言缩进优化
    smartindent = true,    -- make indenting smarter again

    foldenable = true,     -- 允许代码折叠
    -- foldmethod = "indent", -- 代码折叠默认使用缩进
    foldmethod = "marker", -- 代码折叠默认使用标记
    -- foldlevel = 99,        -- 默认打开所有缩进


    -- NvChad options
    nvChad = {
        copy_cut = true, -- copy cut text ( x key ), visual and normal mode
        copy_del = true, -- copy deleted text ( dd key ), visual and normal mode
        insert_nav = true, -- navigation in insertmode
        window_nav = true,
        terminal_numbers = false,

        -- updater
        update_url = "https://github.com/NvChad/NvChad",
        update_branch = "main",
    },
}

local function rev_tab(tab)
  local revtab = {}
  for _, v in pairs(tab) do
    revtab[v] = true
  end
  return revtab
end

local add_opt = {"iskeyword", "formatoptions", "shortmess", "diffopt"}
local special_opt = rev_tab(add_opt)

-- 配置 options
for k, v in pairs(options) do
  local opt = vim.opt
  -- print(k .. ":", v)
  if special_opt[k] then
    vim.cmd(string.format("set %s +=%s", k, v))
    elseif not (k == "nvChad" or k == "mapleader" or k == "terminal" or k == "user") then
      opt[k] = v
  end
end
