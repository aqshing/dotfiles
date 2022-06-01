" 设置注释快捷键(注释必须成双结对)
map <silent> <SPACE><SPACE> :call MyComments()<CR>
func! MyComments()
    if &filetype == 'c' || &filetype == 'cpp' || &filetype == 'java' || &filetype == 'json'
        normal 0i//
    elseif &filetype == 'vim'
        normal 0i""
    elseif &filetype == 'shell' || &filetype == 'sh' ||
\          &filetype == 'python' || &filetype == 'py'||
\          &filetype == 'conf'
        normal 0i##
    elseif &filetype == 'lua'
        normal 0i--
    else
        let s:fileName = expand("%:t")
        if s:fileName == 'CMakeLists.txt' || s:fileName == 'Makefile' ||
\          s:fileName == 'makefile'
            normal 0i##
        endif
    endif
    normal j
endfunc
" 设置取消注释
map <silent> \\ :call UnComments()<CR>
""map <silent> \\ 0df j
func! UnComments()
    if &filetype == 'c' || &filetype == 'cpp' || &filetype == 'java' || &filetype == 'json'
        normal 0df/j
    elseif &filetype == 'vim'
        normal 0df"j
    elseif &filetype == 'shell'|| &filetype == 'sh' ||
\          &filetype == 'python'|| &filetype == 'py'||
\          &filetype == 'conf'
        normal 0df#j
    elseif &filetype == 'lua'
        normal 0df-j
    else
        let s:fileName = expand("%:t")
        if s:fileName == 'CMakeLists.txt' || s:fileName == 'Makefile' ||
\          s:fileName == 'makefile'
            normal 0df#j
        endif
    endif
endfunc


""自动更新文件保存时间
function! TimeOfLastChange()
	""保存光标原位置
""	let save_cursor=getpos(".")
	let win_view = winsaveview()
	let pattern = "Changed: "
	normal gg
	""从头查找Changed，搜索到就跳转，最多索引50行
	let row = search(pattern, 'e', 50)
	if row  == 0
		return
	else
		""更改Changed后面的时间，若有多个Changed，只改第一个
		normal 0
		s/\(Changed\s*:\s*\)\(.*\)$/\=submatch(1).strftime("%Y-%m-%d %H:%M:%S")/ge
	endif
	""恢复光标位置
""	call setpos(".", save_cursor)
	call winrestview(win_view)
endfunction
"" 当下列文件保存时触发修改最后保存时间
augroup TimeStamping
	autocmd!
	au BufWritePre,FileAppendPre *.c,*.cpp,*.cc,*.java,*.py,*.sh :call TimeOfLastChange()
augroup END


""随时间的不同变化，使用不同颜色的主题
""主题每6h变换一次，此函数仅在启动vi的时候被调用
function! SetTimeOfDayColors()
    let currentHour = strftime("%H")
""    echo "currentHour is " . currentHour
    if currentHour < 6 + 0
""        syntax enable
        set background=dark
        let colorScheme="solarized"
    elseif currentHour < 12 + 0
        set background=dark
        let colorScheme = "gruvbox"
    elseif currentHour < 18 + 0
        let colorScheme = "khaki"
    else
        let colorScheme = "molokai"
    endif
""    echo "setting color scheme to " . colorScheme
    execute "colorscheme " . colorScheme
endfunction
"set statusline +=\ %{SetTimeOfDayColors()}
"此函数默认关闭
"call SetTimeOfDayColors()

" See [http://vim.wikia.com/wiki/Highlight_unwanted_spaces]
" - highlight trailing whitespace in red
" - have this highlighting not appear whilst you are typing in insert mode
" - have the highlighting of whitespace apply when you open new buffers
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches() " for performance


" 设置状态栏格式
set statusline=%1*\%<%f\             "显示文件名
set statusline+=%=%2*\[%{&fenc}]\ %{&ff}\ %y%m%r%h%w\ %n\ %*        "显示文件编码类型及文件状态和文件类型
set statusline+=%3*\ line:%l,col:%c,total:%L\ %*   "显示光标所在行和列以及总行数
set statusline+=%4*\ hex:0x%B\ %*   "显示当前字符十六进制
set statusline+=%5*\%3p%%\%*            "显示光标前文本所占总文本的比例
"set statusline+=%4*\ hex:0x%B\%3p%%\ %*   "显示当前字符十六进制和显示光标前文本所占总文本的比例
"set statusline+=%5*\ %{strftime(\"%c\")}\%*            "显示年月日和当前时间
hi User1 cterm=none ctermfg=25 ctermbg=0    "这一行和set statusline=%1是对应的，其他以此类推，实现了vim的背景透明
hi User2 cterm=none ctermfg=208 ctermbg=0
hi User3 cterm=none ctermfg=169 ctermbg=0
hi User4 cterm=none ctermfg=100 ctermbg=0
hi User5 cterm=none ctermfg=green ctermbg=0


" 设置背景透明
"hi Normal ctermfg=252 ctermbg=none
" 改成你自己的名字
"iabbrev xname shing
" 改成你自己的电邮
""iabbrev xmail asm.best
""iabbrev xfile <c-r>=expand("%:t")<CR>
"if exists("*strftime")
"    iabbrev xdate <c-r>=strftime("%Y-%m-%d")<CR>  " 当前日期
"    iabbrev xtime <c-r>=strftime("%H:%M:%S")<CR>  " 当前时间
"endif
