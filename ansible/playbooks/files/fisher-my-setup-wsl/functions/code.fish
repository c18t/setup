function code --description 'exec vscode'
    set -l which_code (which code)
    set -l regex_scoop_code "/scoop/shims/code\$"
    set -l replacement_scoop_code "/scoop/apps/vscode/current/bin/code"
    if string match -r $regex_scoop_code $which_code > /dev/null
        eval (string replace -r $regex_scoop_code $replacement_scoop_code $which_code) $argv
    else
        eval $which_code $argv
    end
end
