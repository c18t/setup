if status --is-login
    # homebrew/linuxbrew
    if ! type brew >/dev/null 2>&1
        set -gx PATH /home/linuxbrew/.linuxbrew/bin /home/linuxbrew/.linuxbrew/sbin $PATH
    end
    if type brew >/dev/null 2>&1
        brew shellenv | source
        set -e -g fish_user_paths
    end
end
