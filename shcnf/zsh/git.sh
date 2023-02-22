if [ -e "$HOME/.ssh" ] && grep -irq _rsa "$HOME/.ssh"; then
ssh_env=~/.ssh/agent.env

agent_load_env () { test -f "$ssh_env" && . "$ssh_env" > /dev/null ; }

agent_start () {
    (umask 077; ssh-agent > "$ssh_env")
    . "$ssh_env" > /dev/null ;
}

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
agent_run_state=$(ssh-add -l > /dev/null 2>&1; echo $?)

if [ ! "$SSH_AUTH_SOCK" ] || [ "$agent_run_state" = 2 ]; then
    agent_start
    ssh-add "$HOME"/.ssh/*_rsa > /dev/null 2>&1
elif [ "$SSH_AUTH_SOCK" ] && [ "$agent_run_state" = 1 ]; then
    ssh-add "$HOME"/.ssh/*_rsa > /dev/null 2>&1
fi

unset ssh_env
fi
