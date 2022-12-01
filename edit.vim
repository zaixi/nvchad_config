
" {{{ 改变符号风格
function! String2chars(str) abort
  let save_enc = &encoding
  let &encoding = 'utf-8'
  let chars = []
  for i in range(strchars(a:str))
    call add(chars, strcharpart(a:str,  i , 1))
  endfor
  let &encoding = save_enc
  return chars
endfunction

function! s:parse_symbol(symbol) abort
  if a:symbol =~# '^[a-z]\+\(-[a-zA-Z]\+\)*$'
    return split(a:symbol, '-')
  elseif a:symbol =~# '^[a-z]\+\(_[a-zA-Z]\+\)*$'
    return split(a:symbol, '_')
  elseif a:symbol =~# '^[a-z]\+\([A-Z][a-z]\+\)*$'
    let chars = String2chars(a:symbol)
    let rst = []
    let word = ''
    for char in chars
      if char =~# '[a-z]'
        let word .= char
      else
        call add(rst, tolower(word))
        let word = char
      endif
    endfor
    call add(rst, tolower(word))
    return rst
  elseif a:symbol =~# '^[A-Z][a-z]\+\([A-Z][a-z]\+\)*$'
    let chars = String2chars(a:symbol)
    let rst = []
    let word = ''
    for char in chars
      if char =~# '[a-z]'
        let word .= char
      else
        if !empty(word)
          call add(rst, tolower(word))
        endif
        let word = char
      endif
    endfor
    call add(rst, tolower(word))
    return rst
  else
    return [a:symbol]
  endif
endfunction


function! Delete_extra_space() abort
  if !empty(getline('.'))
    if getline('.')[col('.')-1] ==# ' '
      execute "normal! \"_ciw\<Space>\<Esc>"
    endif
  endif
endfunction

function! LowerCamelCase() abort
  " fooFzz
  let cword = s:parse_symbol(expand('<cword>'))
  ec cword
  if !empty(cword)
    let rst = [cword[0]]
    if len(cword) > 1
      let rst += map(cword[1:], "substitute(v:val, '^.', '\\u&', 'g')")
    endif
    let save_register = @k
    let save_cursor = getcurpos()
    let @k = join(rst, '')
    normal! viw"kp
    call setpos('.', save_cursor)
    let @k = save_register
  endif
endfunction

function! UpperCamelCase() abort
  " FooFzz
  let cword = s:parse_symbol(expand('<cword>'))
  ec cword
  if !empty(cword)
    let rst = map(cword, "substitute(v:val, '^.', '\\u&', 'g')")
    let save_register = @k
    let save_cursor = getcurpos()
    let @k = join(rst, '')
    normal! viw"kp
    call setpos('.', save_cursor)
    let @k = save_register
  endif
endfunction

function! Under_score() abort
  " foo_fzz
  let cword = s:parse_symbol(expand('<cword>'))
  if !empty(cword)
    let save_register = @k
    let save_cursor = getcurpos()
    let @k = join(cword, '_')
    normal! viw"kp
    call setpos('.', save_cursor)
    let @k = save_register
  endif
endfunction

function! Up_case() abort
  " FOO_FZZ
  let cword =map(s:parse_symbol(expand('<cword>')), 'toupper(v:val)')
  if !empty(cword)
    let save_register = @k
    let save_cursor = getcurpos()
    let @k = join(cword, '_')
    normal! viw"kp
    call setpos('.', save_cursor)
    let @k = save_register
  endif
endfunction

function! Kebab_case() abort
  " foo-fzz
  let cword = s:parse_symbol(expand('<cword>'))
  if !empty(cword)
    let save_register = @k
    let save_cursor = getcurpos()
    let @k = join(cword, '-')
    normal! viw"kp
    call setpos('.', save_cursor)
    let @k = save_register
  endif
endfunction
" }}}

" {{{ 空格 TAB 转换
function! Tab2Spa()
    let l:tab_format = &expandtab
    set expandtab
    :%retab!
    if (l:tab_format)
        set expandtab
    else
        set noexpandtab
    endif
endfunction

function! Spa2Tab()
    let l:tab_format = &expandtab
	set noexpandtab
    :%retab!
    if (l:tab_format)
        set expandtab
    else
        set noexpandtab
    endif
endfunction

"}}}

" 精准替换: {{{
" 替换函数。参数说明：
" confirm：是否替换前逐一确认
" wholeword：是否整词匹配
" replace：被替换字符串
function! Replace(confirm, wholeword, replace)
  wa
  let flag = ''
  if a:confirm
    let flag .= 'gec'
  else
    let flag .= 'ge'
  endif
  let search = ''
  if a:wholeword
    let search .= '\<' . escape(expand('<cword>'), '/\.*$^~[') . '\>'
  else
    let search .= expand('<cword>')
  endif
  let replace = escape(a:replace, '/\&~')
  execute 'argdo %s/' . search . '/' . replace . '/' . flag
endfunction
" }}}

" vim-easy-align 设置 {{{
" 例子: EasyAlign /=/r1l3  =号对齐,左边3个空格,右边一个空格
let g:easy_align_delimiters = {
\ '#': {
\     'pattern': '#',
\     'ignore_groups': ['String'] },
\ '>': { 'pattern': '>>\|=>\|>' },
\ '/': {
\     'pattern':         '//\+\|/\*\|\*/',
\     'delimiter_align': 'l',
\     'ignore_groups':   ['!Comment'] },
\ ']': {
\     'pattern':       '[[\]]',
\     'left_margin':   0,
\     'right_margin':  0,
\     'stick_to_left': 0
\   },
\ ')': {
\     'pattern':       '[()]',
\     'left_margin':   0,
\     'right_margin':  0,
\     'stick_to_left': 0
\   },
\ 'd': {
\     'pattern':      ' \(\S\+\s*[;=]\)\@=',
\     'left_margin':  0,
\     'right_margin': 0
\   }
\ }
" }}}

" copy 设置 {{{
function! Copy2system()
  let l:save_register = @"
  normal! y
  let @+ = @"
  let @" = l:save_register
endfunction

function! Paste2system()
  let l:save_register = @"
  let @" = @+
  normal! p
  let @" = l:save_register
endfunction
"}}}

" {{{ 切换鼠标复制
function! ToggleMouseCopy() abort
  let s:copy_enable = get(s:,'copy_enable', 1)
  if s:copy_enable
    let s:copy_enable = 0
    let s:number = &number
    let s:signcolumn = &signcolumn
    let s:list = &list
    let s:wrap = &wrap
    let g:indentLine_enable = get(b:,'__indent_blankline_active', 'false')
    set signcolumn=no
    set nonumber
    set nolist
    set wrap
    if g:indentLine_enable
        IndentBlanklineToggle
    endif
  else
    let s:copy_enable = 1
    let &number = s:number
    let &signcolumn = s:signcolumn
    let &list = s:list
    let &wrap = s:wrap
    if g:indentLine_enable
        IndentBlanklineToggle
    endif
  endif
endfunction
" }}}
