function uniq_path --description 'set deduplicated PATH'
  set -l UNIQ_PATH

  for path in $PATH
    if not contains -- "$path" $UNIQ_PATH
      set --append UNIQ_PATH "$path"
    end
  end

  set -gx PATH $UNIQ_PATH
end
