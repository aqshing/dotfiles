# 检测 k8s 是否存在
if command -v kubectl >/dev/null 2>&1; then
    # Save this in a file named _k
    # _k completion function
    # This function is responsible for generating possible completions.
    # It is invoked when the user presses Tab after typing the function name.
    _k_completion() {
        local cur prev k8scmd k8sobj
        local word i notfindcmd=true notfindobj=true
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        prev="${COMP_WORDS[COMP_CWORD - 1]}"

        k8scmds="apply get describe delete logs label rollout edit explain"
        k8sobjs="node pod deploy configmap secret service ingress"
        # 使用索引遍历 COMP_WORDS(当前用户输入) 中的所有内容
        for ((i = 0; i < COMP_CWORD; i++)); do
            word="${COMP_WORDS[i]}"
            # 将word和k8scmds里面的单词依次进行正则匹配,如果匹配成功, 则将该单词赋值给k8scmd
            if $notfindcmd && k8scmd=$(grep -oE "$word\S*" <<<"$k8scmds" 2>/dev/null); then
                notfindcmd=false
            elif [[ $word == '-n' ]]; then
                i=$((i + 1))
                k8snamespace="${COMP_WORDS[i]}"
            elif $notfindobj && k8sobj=$(grep -oE "$word\S*" <<<"$k8sobjs" 2>/dev/null); then
                notfindobj=false
            elif [[ $word == 'svc' ]]; then
                k8sobj=service && notfindobj=false
            fi
        done
        # 如果last_complete只有一个元素, 会自动补全到命令之后, 清空它, 防止后续再次重复补全
        if [[ "$(wc -w <<<"$last_complete" 2>/dev/null)" -eq 1 ]]; then
            last_complete=""
        elif [[ $prev == '-n' || $cur == '-n' ]]; then
            # last_complete=$(kubectl get ns --no-headers 2>/dev/null | awk '{print $1}')
            last_complete=$(kubectl get ns -o jsonpath='{.items[*].metadata.name}' 2>/dev/null)
        elif [[ -z $k8sobj && ("$k8scmd" == "get" || "$k8scmd" == "describe" || "$k8scmd" == "delete") ]]; then
            last_complete=$(compgen -W "${k8sobjs}" -- "${cur}")
        elif [[ "$k8scmd" == apply ]]; then
            last_complete=$(compgen -o default -- "${cur}")
        elif [[ "$k8sobj" == pod || "$k8sobj" == deploy || "$k8sobj" == node ]]; then
            [[ -z "$k8snamespace" ]] && k8snamespace=default # 如果没有传入ns, 则使用默认ns
            # last_complete=$(kubectl get "$k8sobj" -n "$k8snamespace" --no-headers 2>/dev/null | awk '{print $1}')
            last_complete=$(kubectl get "$k8sobj" -n "$k8snamespace" -o custom-columns=:metadata.name --no-headers 2>/dev/null)
        elif [[ $prev == '-o' || $cur == '-o' ]]; then
            last_complete=$(compgen -W "wide yaml json" -- "${cur}")
        else
            last_complete=$(compgen -W "${k8scmds}" -- "${cur}")
        fi

        if [[ $cur != '' ]]; then
            last_complete=$(compgen -W "${last_complete}" -- "${cur}")
        fi
        # shellcheck disable=SC2206
        COMPREPLY=($last_complete) # Shellcheck说这种写法不安全, 推荐用下面的写法
        #IFS=" " read -r -a COMPREPLY <<<"$last_complete" # 但这种写法得不到正确结果

        return 0
    }

    # Register the _k completion function for k command
    complete -o default -F _k_completion k
fi
