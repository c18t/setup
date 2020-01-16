if status --is-login; and type brew >/dev/null 2>&1
    # for homebrew ruby
    set -l BREW_PREFIX (brew --prefix)
    set -l GEM_BIN ($BREW_PREFIX/opt/ruby/bin/gem environment | grep 'EXECUTABLE DIRECTORY' | awk -F= '{ print substr($1, index($1, ":")+2); }')
    set -gx PATH "$GEM_BIN" "$BREW_PREFIX/opt/ruby/bin" $PATH
end
