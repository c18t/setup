function update_anyenvrc --description 'Update conf.d/anyenv.fish'
    set -l anyenvrc $__fish_config_dir/conf.d/anyenv.fish
    echo 'if status --is-login' >$anyenvrc
    echo '    and type anyenv >/dev/null 2>&1' >>$anyenvrc
    echo >>$anyenvrc
    anyenv init - --no-rehash >>$anyenvrc
    echo >>$anyenvrc
    echo end >>$anyenvrc
end
