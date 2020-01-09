if status --is-login
    # homebrew/linuxbrew
    if type brew >/dev/null 2>&1
        brew shellenv | source
    end
end
