""""""""寓繁于简""""""""""""""""""""""""""""""以简驭繁"""""""""
"""""""""""""""""""""""""插件安装管理区""""""""""""""""""""""""
"""""""""""""""""""""""""""""start""""""""""""""""""""""""""""
call plug#begin('~/.local/share/nvim/plugged')
""*********************所有插件请统统写在下面******************
""vim配色方案相关插件
""Explorer:配色方案管理插件```
Plug 'sjas/csExplorer', { 'on': 'ColorSchemeExplorer' }

""Khaki:vim配色方案插件
Plug 'vim-scripts/khaki.vim'

""Molokai:vim配色方案插件
Plug 'tomasr/molokai'

""Gruvbox:vim配色方案插件
Plug 'morhetz/gruvbox'

""Solarized:vim配色方案插件```
Plug 'altercation/vim-colors-solarized'

""Snazzy:vim配色方案插件```
""Plug 'connorholyday/vim-snazzy', { 'on': 'ColorSchemeExplorer' }
""-------------------------------------------------------------------------

" Status line```deprecated
"Plug 'theniceboy/eleline.vim'

""Doxygen:注释自动生成插件```deprecated
"Plug 'vim-scripts/DoxygenToolkit.vim', { 'for': ['c', 'cpp', 'vim-plug'] }

""Startify:炫酷的启动界面```
""Plug 'mhinz/vim-startify'

""Signature:书签管理插件```deprecated
""Plug 'kshenoy/vim-signature'

""Indentline:缩进线条插件```deprecated
Plug 'yggdroot/indentline', { 'on': 'IndentLinesToggle' }

""Format:格式化代码插件
Plug 'rhysd/vim-clang-format'

""TrailSpace:清理行尾空格插件```deprecated
""Plug 'bronson/vim-trailing-whitespace'

""Commentary:代码批量注释插件```deprecated
""Plug 'tpope/vim-commentary', { 'for': ['c', 'cpp', 'vim-plug'] }

""COC:c代码补全插件
Plug 'neoclide/coc.nvim', {'branch': 'release'}
""Plug 'prabirshrestha/vim-lsp'

""Spector:代码调试插件
""Plug 'puremourning/vimspector', {'do': './install_gadget.py --enable-c --enable-bash'}

""Highlight:STL高亮插件
Plug 'octol/vim-cpp-enhanced-highlight', { 'for': ['c', 'cpp', 'vim-plug'] }
""Plug 'jackguo380/vim-lsp-cxx-highlight', { 'for': ['c', 'cpp', 'vim-plug'] }

""ACP:字符串自动补全插件```
""Plug 'vim-scripts/AutoComplPop'

""Snippets:代码片段插件
Plug 'SirVer/ultisnips'

""InterestWord:可以使用不同颜色同时高亮多个单词
Plug 'lfv89/vim-interestingwords', { 'for': ['c', 'cpp', 'vim-plug'] }

""Cursorword:给当前光标单词增加下划线```
""Plug 'itchyny/vim-cursorword', { 'for': ['c', 'cpp', 'vim-plug'] }

""Translater:英语翻译插件```deprecated
""Plug 'ianva/vim-youdao-translater'

""FZF:文件路径模糊搜索```deprecated
""Plug 'junegunn/fzf', { 'dir': '~/.config/nvim/.fzf', 'do': './install --all' }
""-------------------------------------------------------------------------
"Plug 'iamcco/mathjax-support-for-mkdp'

""markdown相关插件
""Table:markdown插入表格
Plug 'dhruvasagar/vim-table-mode', { 'on': 'TableModeToggle', 'for': ['text', 'markdown', 'vim-plug'] }
""Preview:markdown预览插件`^`^can not uesd
""Plug 'suan/vim-instant-markdown', {'for': 'markdown'}
""Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug'] }

""Wiki:vim插入表格```
""Plug 'vimwiki/vimwiki', { 'for': ['markdown', 'wiki', 'vim-plug'] }
""*********************所有插件请统统写在上面******************
call plug#end()              " required
filetype plugin indent on    " required
""""""""""""""""""""""""""""""end""""""""""""""""""""""""""""""

