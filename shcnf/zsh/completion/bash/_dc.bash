# 检测 docker compose 是否存在
if command -v docker-compose >/dev/null 2>&1; then
    # Save this in a file named _dc

    _dc_completion() {
        local cur prev dcmd_options
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        prev="${COMP_WORDS[COMP_CWORD - 1]}"
        dcmd_options="down config restart stop logs images kill exec version"

        # Complete the first argument (dcmd)
        if [[ ${#COMP_WORDS[@]} -eq 2 ]]; then
            COMPREPLY=($(compgen -W "${dcmd_options}" -- "${cur}"))
            return 0
        fi

        case "${prev}" in
        d*)
            COMPREPLY=($(compgen -W "down" -- ${cur}))
            ;;
        co* | t* | c*)
            COMPREPLY=($(compgen -W "config" -- ${cur}))
            ;;
        re*)
            COMPREPLY=($(compgen -W "restart" -- ${cur}))
            ;;
        q*)
            COMPREPLY=($(compgen -W "stop" -- ${cur}))
            ;;
        lo*)
            COMPREPLY=($(compgen -W "logs" -- ${cur}))
            ;;
        i*)
            COMPREPLY=($(compgen -W "images" -- ${cur}))
            ;;
        k*)
            COMPREPLY=($(compgen -W "kill" -- ${cur}))
            ;;
        e*)
            COMPREPLY=($(compgen -W "exec" -- ${cur}))
            ;;
        v*)
            COMPREPLY=($(compgen -W "version" -- ${cur}))
            ;;
        rmi)
            COMPREPLY=($(compgen -W "all none" -- ${cur}))
            ;;
        *) ;;
        esac

        return 0
    }

    # Register the _dc_completion function for dc command
    complete -F _dc_completion dc

fi
