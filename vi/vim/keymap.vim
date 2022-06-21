"""""""""""""""""""""""自定义键盘映射管理区“""""""""""""""""""""
"""""""""""""""""""""""""""""start"""""""""""""""""""""""""""""
""*********************""VI快捷键映射""***********************""
"设置自己的leader(组合键)
let mapleader=","
"let g:mapleader=","
"关于保存退出文件
nnoremap <leader>w :w<CR>
inoremap <C-s> <esc>:w<CR>
nmap <leader>q :q!<CR>
nmap <S-q> :qa!<CR>
"删除一行
inoremap <leader>d <esc>ddi
"批量复制粘贴(+:copy到系统剪切板,a:copy到A这个register中)
vnoremap <leader>y "+y
"vnoremap <leader>y "ay
nmap <leader>p "ap
vnoremap <leader>c "by
nmap <leader>v "bp
"全选(select all)
nnoremap <C-a> ggVG"
inoremap <C-a> <esc>ggVG"
"单行复制粘贴
inoremap <C-d> <esc>yypi
"将当前行上移一行
inoremap <C-up> <esc>ddkPi
"将当前行下移一行
inoremap <C-down> <esc>ddpi
"撤销
inoremap <C-u> <esc>ui
"反撤销
inoremap <C-r> <esc><C-r>i
noremap U <C-r>
"多窗口跳转<C-k>:up;<C-j>:down;<C-h>:left;<C-l>:right;
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
"更改分屏大小(:sp上下分屏;vsp:左右分屏)
nnoremap <space><up> :res +5<CR>
nnoremap <space><down> :res -5<CR>
nnoremap <space><left> :vertical resize-5<CR>
nnoremap <space><right> :vertical resize+5<CR>
"标签页设置:tb(tabnew):打开一个新标签页;
"tn(next):切换到下一个标签页;tp(prefix):切换到上一个标签页
map tb :tabe<CR>
map tp :-tabnext<CR>
map tn :+tabnext<CR>
"分号映射为冒号, 省得要进入命令模式需要按shift
"Map ; to : and save a million keystrokes 用于快速进入命令行
nnoremap ; :
"定义快捷键到行首或行尾
nmap H ^
nmap L $
"快速上下移动(一次跳5行)
nmap J 5j
nmap K 5k
"Treat long lines as break lines (useful when moving around in them)
"se swap之后，同物理行上下直接跳
nnoremap k gk
nnoremap gk k
nnoremap j gj
nnoremap gj j
"把搜索到的结果放到屏幕的中间
nnoremap n nzz
nnoremap N Nzz
"调整缩进后自动选中，方便再次操作
vnoremap < <gv
vnoremap > >gv
"打开一个新文件和当前文件进行对比
nnoremap <C-d> :vert diffsplit 
"ctrl-s控制拼写检查的开关
nnoremap <C-s> :set spell!<CR>
"ctrl-x:插入模式下弹出拼写检查的提示
inoremap <C-x> <esc>ea<C-x>s
nnoremap s <nop>
"F4键控制行号开关,用于鼠标复制代码
nnoremap <F4> :call HideNumber()<CR>
"F3键控制目录的打开与关闭
nnoremap <silent> <F3> :CocCommand explorer<CR>
"F2键为代码添加注释
inoremap <silent> <F2> <esc>:Dox<CR>
",+空格键功能清除行尾空格
""nnoremap <silent> <leader><space> :FixWhitespace<CR>
nnoremap <silent> <leader><space> :call DeleteTrailingWS()<CR>
"ctrl-n进行相对行号/绝对行号切换
nnoremap <silent> <C-n> :call NumberToggle()<cr>
"多窗口编辑时, 临时放大某个窗口, 编辑完再切回原来的布局
nnoremap <silent> <Leader>z :ZoomToggle<CR>
"Call figlet艺术字(ascii banner)
nnoremap tx :r !figlet 
"执行make clean命令
"nnoremap mc :make clean<CR>
"格式化代码
"nnoremap <C-l> ggVG=
"保存, 没权限的时候
" w!! to sudo & write a file
cmap w!! w !sudo tee >/dev/null %
map bb `]
map ee `[
noremap <LEADER>tm :TableModeToggle<CR>
"autocmd Filetype markdown inoremap <buffer> ,f <Esc>/<++><CR>:nohlsearch<CR>"_c4l
inoremap ,f <esc>/<++><CR>:nohlsearch<CR>"_c4l
"打开一个新终端并分屏显示
noremap <F12> :term<CR><ESC><C-w>L
"在普通模式下，按 ctrl+t， 会翻译当前光标下的单词；
"在 visual 模式下选中单词或语句，按 ctrl+t，会翻译选择的单词或语句；
"点击引导键再点y，d，可以在命令行输入要翻译的单词或语句；
"译文将会在编辑器底部的命令栏显示。
""vnoremap <silent> <C-T> :<C-u>Ydv<CR>
""nnoremap <silent> <C-T> :<C-u>Ydc<CR>
nnoremap <silent> <C-t> :CocCommand translator.popup<CR>
""noremap <leader>yd :<C-u>Yde<CR>
""""""""""""""""""""""""""""""end""""""""""""""""""""""""""""""

