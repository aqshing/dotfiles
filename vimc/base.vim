"""""""""""""""""""""""""自定义基础配置区"""""""""""""""""""""""
"" 本区内的配置将会被vi全局引用, 请谨慎修改
"""""""""""""""""""""""""""""start"""""""""""""""""""""""""""""
"让vim配置保存后立马生效
autocmd BufWritePost $MYVIMRC source $MYVIMRC
"开启文件类型侦测
filetype on
"针对不同文件类型采用不同缩进格式
filetype indent on
"针对不同文件类型加载对应的插件
filetype plugin on
"启用自动补全
""filetype plugin indent on
"关闭兼容性
set nocompatible
"设置编码格式为utf-8
set encoding=utf-8
"显示行号
set number
"Tab键的宽度
set tabstop=4
"设置自动对齐为4
set shiftwidth=4
"编辑时backspace为2
set backspace=2
"统一缩进为4
set softtabstop=4
""vim<740会出现粘贴<Tab>出错的情况
if version > 800 || has('nvim')
"自动缩进cindent:使用C标准风格缩进
set cin
"智能对齐
set smartindent
"自动对齐
set autoindent
endif
"不要用空格代替制表符
set noexpandtab
"语法高亮
syntax on
"高亮显示对应的括号
set showmatch
"对应括号高亮的时间（单位：1/10s）
set matchtime=10
"开启实时搜索
set incsearch
"开启智能搜索
set smartcase
"搜索时不区分大小写
set ignorecase
"搜索时高亮显示
set hlsearch
"开启vim自身命令行模式智能补全
set wildmenu
"高亮显示光标所在的当前行
set cursorline
"上下移动光标时,光标的上方或下方至少会保留显示的行数
set scrolloff=5
"设置vim执行命令的路径为当前路径
set autochdir
"设置底部状态栏的高度为2
set laststatus=2
"修改未保存时可以切换窗口 TextEdit might fail if hidden is not set.
set hidden
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=200
"补全时少打出没用的信息 Don't pass messages to |ins-completion-menu|.
set shortmess+=c
"设置自动保存
set autowrite
"如果文本超过宽度限制(80),画一条数线警告
set colorcolumn=80
"设置tab键的缩进线条\¦\ (here is a space)
""set list lcs=tab:\|\.
"不仅可以显示tab键的缩进,也可以显示行尾结束符
set list
set listchars=trail:▫,tab:\|\.
""set listchars=eol:☺,trail:➤,tab:\|\.
"指定拼写检查字典为英文字典
setlocal spelllang=en_us
"打开拼写检查
"set spell
"高亮光标所在当前列
"set cursorcolumn
"use mouse
"set mouse=a
" 细节调整，主要为了适应 Google C++ Style
" t0: 函数返回类型声明不缩进
" g0: C++ "public:" 等声明缩进一个字符
" h1: C++ "public:" 等声明后面的语句缩进一个字符
" N-s: C++ namespace 里不缩进
" j1: 合理的缩进 Java 或 C++ 的匿名函数，应该也适用于 JS
set cinoptions=t0,g0,h4,N-s,j1
"设置备份文件存放目录
silent !mkdir -p ~/.config/nvim/tmp/backup
silent !mkdir -p ~/.config/nvim/tmp/undo
"silent !mkdir -p ~/.config/nvim/tmp/sessions
set backupdir=~/.config/nvim/tmp/backup,.
set directory=~/.config/nvim/tmp/backup,.
if has('persistent_undo')
	set undofile
	set undodir=~/.config/nvim/tmp/undo,.
endif
"EOL针对不同平台设置不同的行尾符(*nix为\n,win为\r\n)
"mac平台自OS X始，换行符与unix一致;越靠前优先级越高
if has("win32")
	set fileformats=dos,unix,mac
else
	set fileformats=unix,mac,dos
endif


"打开vim时,自动定位到上次最后编辑的位置, 需要确认 .viminfo 当前用户可写
if has("autocmd")
	au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif


"设置C文件一行的宽度限制为80字符
au FileType c,cpp,python,vim set textwidth=120

"让python支持PEP8风格的自动缩进
""au BufNewFile,BufRead *.py
""    \ set tabstop=4 |
""    \ set softtabstop=4 |
""    \ set shiftwidth=4 |
""    \ set textwidth=79 |
""    \ set expandtab |
""    \ set autoindent |
""    \ set fileformat=unix |

"前端开发
""au BufNewFile,BufRead *.js,*.html,*.css
""    \ set tabstop=2 |
""    \ set softtabstop=2 |
""    \ set shiftwidth=2 |


"auto spell 编辑markdown时，自动打开拼写检查
"autocmd BufRead,BufNewFile *.md setlocal spell


"相对行号: 行号变成相对，可以用 nj/nk 进行跳转
set relativenumber number
au FocusLost * :set norelativenumber number
au FocusGained * :set relativenumber
" 插入模式下用绝对行号, 普通模式下用相对行号
autocmd InsertEnter * :set norelativenumber number
autocmd InsertLeave * :set relativenumber
"<ctrl-n>进行相对行号/绝对行号切换
function! NumberToggle()
	if(&relativenumber == 1)
		set norelativenumber number
	else
		set relativenumber
	endif
endfunc


"为方便复制，用<F4>开启/关闭行号显示:
function! HideNumber()
	if(&relativenumber == &number)
		set relativenumber! number!
	elseif(&number)
		set number!
	else
		set relativenumber!
	endif
	set number?
endfunc


"保存文件时, 自动移除多余空格
"保存python文件时删除多余空格
fun! <SID>StripTrailingWhitespaces()
	let l = line(".")
	let c = col(".")
	%s/\s\+$//e
	call cursor(l, c)
endfun
autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()
"这个函数通过替换命令删除行尾空格
func! DeleteTrailingWS()
	exec "normal mz"
	%s/\s\+$//ge
	exec "normal `z"
endfunc


"多窗口编辑时, 临时放大某个窗口, 编辑完再切回原来的布局
"Zoom / Restore window.快捷键:<Leader>z控制此功能的开关
function! s:ZoomToggle() abort
	if exists('t:zoomed') && t:zoomed
		execute t:zoom_winrestcmd
		let t:zoomed = 0
	else
		let t:zoom_winrestcmd = winrestcmd()
		resize
		vertical resize
		let t:zoomed = 1
	endif
endfunction
command! ZoomToggle call s:ZoomToggle()

""********************end of vim setting***********************
""********************vim所有配置到此结束**********************
