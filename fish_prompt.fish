# Prompt Char
set prompt_char '⋊>'

# Status Chars
set cleanstate_char '✓'
set dirtystate_char '!'
set stashstate_char '↩'
set untrackedstate_char '☡'

function _path_info
  set cwd (prompt_segments)
  printf '%s' (string join '/' $cwd)
end

function _branch_info
  set -l branch (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
  printf '%s' $branch
end

# Display the state of the branch when inside of a git repo
function _build_local_status_info
  git update-index --really-refresh -q 1> /dev/null

    # Check for changes to be commited
  if git_is_touched
    echo -n $dirtystate_char
  else
    echo -n $cleanstate_char
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

function _print_prompt_char
  printf '%s ' $prompt_char
end

function _new_line
  echo -e ''
end

function _info
  set -l branch_color (set_color yellow)
  set -l dir_color (set_color blue)

  set -l local_status_info (_local_status_info)
  set local_status_color (set_color red)
  if test $local_status_info = '✓'
    set local_status_color (set_color green)
  end

  echo -ns $dir_color (_path_info)
  echo -ns ' '
  echo -ns $branch_color (_branch_info)
  echo -ns ' '
  echo -ns $local_status_color'['
  echo -ns $local_status_info
  echo -ns ']'
end

function _prompt
  set -l normal (set_color normal)
  set -l prompt_color (set_color green)

  echo -ns $prompt_color (_print_prompt_char) $normal
end

function fish_prompt
  _new_line
  _info
  _new_line
  _prompt
end
