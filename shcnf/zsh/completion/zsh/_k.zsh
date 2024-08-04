#compdef k

# 检测 k8s 是否存在
if command -v kubectl >/dev/null 2>&1; then
    # Save this in a file named _k
    # _k completion function
    # This function is responsible for generating possible completions.
    # It is invoked when the user presses Tab after typing the function name.
    _k_completion() {
        local compcmd compobj
        local word i
        local cmds="apply get describe delete logs label rollout edit explain"
        local objs="node pod deploy configmap secret service ingress"
        # 求出words的长度并减去1
        local word_size=${#words[@]}
        __kubectl_debug "\n========= starting completion logic =========="
        __kubectl_debug "word size: ${word_size}, words[*]: ${words[*]}"
        # 遍历 words 中的所有内容
        for ((i = 1; i < word_size; i++)); do
            word="${words[i]}"

            # 匹配 cmds 中的单词
            if compcmd=$(grep -oE "\b$word\S*" <<<"$cmds" 2>/dev/null); then
                words[i]=$compcmd
                __kubectl_debug "word: ${word} replace : $compcmd"
            elif compobj=$(grep -oE "\b$word\S*" <<<"$objs" 2>/dev/null); then
                words[i]=$compobj
            elif [[ $word == '-n' ]]; then
                i=$((i + 1))
                k8snamespace="${words[i]}"
            fi
        done
        [[ -z "$k8snamespace" ]] && k8snamespace=default # 如果没有传入ns, 则使用默认ns
        __kubectl_debug "after words[*]: ${words[*]}"
        _kubectl
    }

    # Register the _k_completion function for k command
    compdef _k_completion k
fi
