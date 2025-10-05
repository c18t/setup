function sshfs --description 'alias sshfs=sshfs $argv[1]:/ ~/Desktop/$argv[1]'
  set -l which_sshfs (which sshfs)
  set -l ssh_config (cat ~/.ssh/config)
  if contains "Host $argv[1]" $ssh_config
    eval $which_sshfs $argv[1]:/ ~/Desktop/$argv[1]
  else
    eval $which_sshfs $argv
  end
end
