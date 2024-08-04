# 默认跟随系统，一般不需要设置
export LANGUAGE=en_US     #: zh_CN
export LC_ALL=en_US.UTF-8 #: zh_CN.UTF-8
export LANG=en_US.UTF-8   # 让zsh支持中文

# 快速目录跳转
zinit ice lucid wait='1'
#zinit light skywind3000/z.lua
zinit light agkozak/zsh-z

# 语法高亮
zinit ice lucid wait='0' atinit='zpcompinit'
zinit light zdharma/fast-syntax-highlighting

# 自动恢复到终端上次退出时目录
zinit light mdumitru/last-working-dir
#zinit light Curly-Mo/last-working-dir-tmux

# 自动建议
zinit ice lucid wait="0" atload='_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions
# 启用自动切换目录特性(只需输入目录名, 不需显式输入cd命令, zsh会自动切换到该目录)
setopt AUTO_CD # unsetopt AUTO_CD # 查看是否启用该选项: setopt | grep -i autocd
# 设置zsh忽略以 # 开头的注释
setopt interactive_comments

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
zinit snippet OMZL::/git.zsh
zinit snippet OMZL::/completion.zsh
zinit snippet OMZL::/history.zsh
zinit snippet OMZL::/key-bindings.zsh
zinit snippet OMZL::/theme-and-appearance.zsh
zinit snippet OMZP::/colored-man-pages/colored-man-pages.plugin.zsh
zinit snippet OMZP::/sudo/sudo.plugin.zsh

# x自动解压缩插件
#zinit ice svn
zinit snippet OMZP::/extract

zinit ice lucid wait='1'
##zinit snippet OMZP::/git/git.plugin.zsh

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
#zinit ice depth=1
#zinit light romkatv/powerlevel10k

# 加载它们的补全等
zinit ice mv="*.zsh -> _fzf" as="completion"
zinit snippet 'https://github.com/junegunn/fzf/blob/master/shell/completion.zsh'
zinit snippet 'https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh'
#zinit ice as="completion"
# 配置 fzf 使用 fd
export FZF_DEFAULT_COMMAND='fd --type f'
# 初始化补全
autoload -Uz compinit && compinit
# zinit 出于效率考虑会截获 compdef 调用，放到最后再统一应用，可以节省不少时间
zinit cdreplay -q
