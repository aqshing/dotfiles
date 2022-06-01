" color
if !has("gui_running")
	set t_Co=256
endif
""选择要使用的配色方案
"colorscheme khaki
let g:molokai_original = 1
let g:rehash256 = 1
""colorscheme molokai
""set background=dark
""colorscheme solarized


""coc.nvim
""nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>
""如果版本号小于810,禁止coc插件弹出警告
""if version < 810
""	let g:coc_disable_startup_warning = 1
""endif
let g:coc_global_extensions = [
	\ 'coc-json',
	\ 'coc-diagnostic',
	\ 'coc-explorer',
	\ 'coc-clangd',
	\ 'coc-gitignore',
	\ 'coc-prettier',
	\ 'coc-syntax',
	\ 'coc-translator',
	\ 'coc-vimlsp',
	\ 'coc-clang-format-style-options']


inoremap <silent><expr> <F1>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
""inoremap <silent><expr> <c-space> coc#refresh()
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Use K to show documentation in preview window.
nnoremap <silent> <leader>h :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

""""vimspector
""let g:vimspector_enable_mappings = 'VISUAL_STUDIO'
""function! s:read_template_into_buffer(template)
""    " has to be a function to avoid the extra space fzf#run insers otherwise
""    execute '0r ~/.config/nvim/vimspector_json/'.a:template
""endfunction
""command! -bang -nargs=* LoadVimSpectorJsonTemplate call fzf#run({
""            \   'source': 'ls -1 ~/.config/nvim/vimspector_json',
""            \   'down': 20,
""            \   'sink': function('<sid>read_template_into_buffer')
""            \ })
""noremap <leader>vs :tabe .vimspector.json<CR>:LoadVimSpectorJsonTemplate<CR>
""sign define vimspectorBP text=b texthl=Normal
""sign define vimspectorBPDisabled text=🚫 texthl=Normal
""sign define vimspectorPC text=👉 texthl=SpellBad


""" ultisnips
" Trigger configuration. You need to change this to something else than <tab>
" if you use https://github.com/Valloric/YouCompleteMe.
let g:tex_flavor = "latex"
let g:UltiSnipsExpandTrigger="<leader>e"
let g:UltiSnipsJumpForwardTrigger="<C-e>"
let g:UltiSnipsJumpBackwardTrigger="<C-b>"
" If you want :UltiSnipsEdit to split your window.
"let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetDirectories = [$HOME.'/.config/nvim/UltiSnips/', 'UltiSnips']


" ===
" === vim-table-mode
" ===
"noremap <LEADER>tm :TableModeToggle<CR>
"let g:table_mode_disable_mappings = 1
let g:table_mode_cell_text_object_i_map = 'k<Bar>'
let g:vimwiki_list = [{'path': '~/vimwiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]


"打开vim时,自动定位到上次最后编辑的位置, 需要确认 .viminfo 当前用户可写
if has("autocmd")
	au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif


"设置C文件一行的宽度限制为80字符
au FileType c,cpp,python,vim set textwidth=120


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
