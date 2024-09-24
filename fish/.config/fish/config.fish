if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_hybrid_key_bindings
    abbr -a ta 'tmux attach -t'
    abbr -a tad 'tmux attach -d -t'
    abbr -a ts 'tmux new-session -s'
    abbr -a tl 'tmux list-sessions'
    abbr -a tksv 'tmux kill-server'
    abbr -a tkss 'tmux kill-session -t'
    set -gx EDITOR nvim
end
