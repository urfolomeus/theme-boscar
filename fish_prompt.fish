# Prompt Char
set prompt_char '⋊>'

# Status Chars
set dirtystate_char '!'
set stashstate_char '⚑'
set untrackedstate_char '*'

function _path_info
  set cwd (prompt_segments)
  printf '%s' (string join '/' $cwd)
end

# Display the state of the branch when inside of a git repo
function _build_local_status_info
  git update-index --really-refresh -q 1> /dev/null

    # Check for changes to be commited
  if git_is_touched
    echo -n $dirtystate_char
  end

  # Check for untracked files
  set -l git_untracked (command git ls-files --others --exclude-standard 2> /dev/null)
  if [ -n "$git_untracked" ]
    echo -n $untrackedstate_char
  end

  # Check for stashed files
  if git_is_stashed
    echo -ns $local_status_color $stashstate_char
  end
end

function _local_status_info
  set state (_build_local_status_info)
  printf '%s' $state
end

function _upstream_status_info
  set state (git_ahead)
  printf '%s' $state
end

function _status_info
  set -l branch_color (set_color yellow)
  echo -ns $branch_color (_branch_info)

  set local_status_info (_local_status_info)
  set upstream_status_info (_upstream_status_info)

  if test -z $local_status_info; and test -z $upstream_status_info
    echo -ns ''
  else
    set -l local_status_color (set_color red)
    set -l normal_color (set_color normal)
    set -l upstream_status_color (set_color cyan)

    echo -ns ' '
    echo -ns $normal_color '('
    echo -ns $local_status_color $local_status_info
    echo -ns $upstream_status_color $upstream_status_info
    echo -ns $normal_color ')'
  end
end

function _branch_info
  set branch_symbol \uE0A0
  set branch (command git symbolic-ref HEAD ^/dev/null | sed -e "s|^refs/heads/|$branch_symbol |")
  printf '%s' $branch
end

function _show_user
  if test $USER = 'root'
    set_color red
  else
    set_color green
  end

  set user (whoami)
  if test $user != $DEFAULT_USER
    printf '%s ' $user
  end
end

function _info
  _show_user

  set -l dir_color (set_color blue)
  echo -ns $dir_color (_path_info)

  set -l pwd (prompt_pwd)
  set -l is_dot_git (string match '*/.git' $pwd)

  if git_is_repo; and test -z $is_dot_git
    echo -ns ' '
    _status_info
  end

end

function _print_prompt_char
  printf '%s ' $prompt_char
end

function _prompt
  set -l normal (set_color normal)
  set -l prompt_color (set_color green)

  echo -ns $prompt_color (_print_prompt_char) $normal
end

function _new_line
  echo -e ''
end

function fish_prompt
  _new_line
  _info
  _new_line
  _prompt
end
