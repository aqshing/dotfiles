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


""vim-gutentags
""gutentags搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归 "
let g:gutentags_project_root = ['.root', '.svn', '.git', '.project']
""所生成的数据文件的名称 "
let g:gutentags_ctags_tagfile = '.tags'
""将自动生成的 tags 文件全部放入 $HOME/.cache/tags 目录中，避免污染工程目录 "
let s:vim_tags = expand('$HOME/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags
""检测 $HOME/.cache/tags 不存在就新建 "
if !isdirectory(s:vim_tags)
   silent! call mkdir(s:vim_tags, 'p')
endif
""配置 ctags 的参数 "
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+pxI']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']


""emmet
""仅对 html/css 启用
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall
""重新定义触发键,触发键被定义为,,
""连按两次英文状态的逗号
let g:user_emmet_leader_key=','


""coc.nvim
""nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>
""如果版本号小于810,禁止coc插件弹出警告
if version < 810
	let g:coc_disable_startup_warning = 1
endif
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
	\ 'coc-sumneko-lua',
	\ 'coc-sh',
	\ 'coc-pyright',
	\ '@yaegassy/coc-nginx',
	\ 'coc-clang-format-style-options']


inoremap <silent><expr> <F1>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

""Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

""Make <CR> auto-select the first completion item and notify coc.nvim to
""format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

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

""Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

""Applying codeAction to the selected region.
""Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

""Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
""Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

""Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

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
""    execute '0r $HOME/.config/nvim/vimspector_json/'.a:template
""endfunction
""command! -bang -nargs=* LoadVimSpectorJsonTemplate call fzf#run({
""            \   'source': 'ls -1 $HOME/.config/nvim/vimspector_json',
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
let g:vimwiki_list = [{'path': '$HOME/vimwiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]
