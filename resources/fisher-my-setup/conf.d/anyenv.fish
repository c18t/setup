if status --is-login
    # anyenv
    if type anyenv >/dev/null 2>&1
        anyenv init - | source
    end
end
