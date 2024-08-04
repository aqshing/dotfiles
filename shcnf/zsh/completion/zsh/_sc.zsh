#compdef sc

if command -v systemctl >/dev/null 2>&1; then
    _sc_completion() {
        local compcmd
        local word i
        local cmds="restart status enable disable list-unit-files is-active get-default"
        # 求出words的长度并减去1
        local word_size=${#words[@]}
        __zshcomp_debug "\n========= starting completion logic =========="
        __zshcomp_debug "word size: ${word_size}, words[*]: ${words[*]}"
        # 遍历 words 中的所有内容
        for ((i = 1; i < word_size; i++)); do
            word="${words[i]}"

            # 匹配 cmds 中的单词
            if compcmd=$(grep -oE "\b$word\S*" <<<"$cmds" 2>/dev/null); then
                words[i]=$compcmd
                __zshcomp_debug "word: ${word} replace : $compcmd"
            elif [[ ($scmd =~ ^r.*$) || ("$scmd" == start) ]];; then
                words[i]=start
            elif [[ ($scmd =~ ^q.*$) || ("$scmd" == stop) ]];; then
                words[i]=stop
            fi
        done

        __zshcomp_debug "after words[*]: ${words[*]}"
        _ctls # callback systemctl completion function
    }

    # Register the _cmd_completion function for command
    compdef _sc_completion sc
fi
