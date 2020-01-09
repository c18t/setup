if status --is-login
    # homebrew/linuxbrew
    if type brew >/dev/null 2>&1
        eval (echo (brew --prefix)/bin/brew shellenv) | source
    end
end
