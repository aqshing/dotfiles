#compdef dc

# 检测 docker compose 是否存在
if command -v docker-compose >/dev/null 2>&1; then
    _dc() {
        local -a completions
        local word
        word="${words[-1]}"
        local dcmd_options="down config restart stop logs images kill exec version"

        # Add your custom completions here
        case "${word}" in
        d*)
            completions=("down")
            ;;
        co* | t* | c*)
            completions=("config")
            ;;
        re*)
            completions=("restart")
            ;;
        q*)
            completions=("stop")
            ;;
        lo*)
            completions=("logs")
            ;;
        i*)
            completions=("images")
            ;;
        k*)
            completions=("kill")
            ;;
        e*)
            completions=("exec")
            ;;
        v*)
            completions=("version")
            ;;
        rmi)
            completions=("all" "none")
            ;;
        *)
            completions=($dcmd_options)
            ;;
        esac

        _describe 'values' completions
    }

    # Register the _dc completion function for the dc command
    compdef _dc dc
fi
