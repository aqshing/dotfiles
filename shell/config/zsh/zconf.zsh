# 默认跟随系统，一般不需要设置
##export LANGUAGE=en_US #: zh_CN

# 快速目录跳转
zinit ice lucid wait='1'
zinit light skywind3000/z.lua

# 语法高亮
zinit ice lucid wait='0' atinit='zpcompinit'
zinit light zdharma/fast-syntax-highlighting

# 自动恢复到终端上次退出时目录
zinit light mdumitru/last-working-dir
#zinit light Curly-Mo/last-working-dir-tmux

# 自动建议
zinit ice lucid wait="0" atload='_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

# 补全
zinit ice blockf as"completion"
zinit ice lucid wait='0'
zinit light zsh-users/zsh-completions

# One other binary release, it needs renaming from `docker-compose-Linux-x86_64`.
# This is done by ice-mod `mv'{from} -> {to}'. There are multiple packages per
# single version, for OS X, Linux and Windows – so ice-mod `bpick' is used to
# select Linux package – in this case this is actually not needed, Zinit will
# grep operating system name and architecture automatically when there's no `bpick'.
zinit ice from"gh-r" as"program" mv"docker* -> docker-compose" bpick"*linux*"
zinit load docker/compose

# 加载 OMZ 框架及部分插件
zinit snippet OMZ::lib/git.zsh
zinit snippet OMZ::lib/completion.zsh
zinit snippet OMZ::lib/history.zsh
zinit snippet OMZ::lib/key-bindings.zsh
zinit snippet OMZ::lib/theme-and-appearance.zsh
zinit snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh
zinit snippet OMZ::plugins/sudo/sudo.plugin.zsh

# x自动解压缩插件
#zinit ice svn
zinit snippet OMZ::plugins/extract

zinit ice lucid wait='1'
##zinit snippet OMZ::plugins/git/git.plugin.zsh

#   以下内容不推荐使用
#   # 使用 OMZ 主题
#   setopt promptsubst
#   # Load theme from OMZ
#   zinit snippet OMZT:robbyrussell
#   zinit snippet OMZT:gnzh
# 加载 pure 主题
zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure
# Load p10k themes
#zinit ice depth=1; zinit light romkatv/powerlevel10k

# ---- (可选)加载了一堆二进制程序 ----
zinit light zinit-zsh/z-a-bin-gem-node

#zinit as="null" wait="1" lucid from="gh-r" for
#    mv="exa* -> exa" sbin        ogham/exa
#    mv="*/rg -> rg"  sbin        BurntSushi/ripgrep
#    mv="fd* -> fd"   sbin="fd/fd"  @sharkdp/fd
#    sbin="fzf"       junegunn/fzf-bin

# 加载它们的补全等
zinit ice mv="*.zsh -> _fzf" as="completion"
zinit snippet 'https://github.com/junegunn/fzf/blob/master/shell/completion.zsh'
zinit snippet 'https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh'
zinit ice as="completion"
zinit snippet 'https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/fd/_fd'
#   以下内容不推荐使用
#   zinit ice svn mv="*.zsh -> _exa" as="completion"
#   zinit snippet 'https://github.com/ogham/exa'
#
#   # 不需要花里胡哨的 ls，我们有更花里胡哨的 exa
#   DISABLE_LS_COLORS=true
#   alias ls=exa
# 配置 fzf 使用 fd
export FZF_DEFAULT_COMMAND='fd --type f'
# 初始化补全
#autoload -Uz compinit; compinit
# zinit 出于效率考虑会截获 compdef 调用，放到最后再统一应用，可以节省不少时间
zinit cdreplay -q
# ---- 加载完了 ----
