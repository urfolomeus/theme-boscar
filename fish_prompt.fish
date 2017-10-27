function _path_info
  set cwd (prompt_segments)
  printf '%s' (string join '/' $cwd)
end

function _branch_info
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _prompt_char
  printf '⋊> '
end

function _new_line
  echo -e ''
end

function _info
  set -l blue (set_color blue)
  set -l yellow (set_color yellow)

  set -l branch_color $yellow
  set -l dir_color $blue

  echo -ns $dir_color (_path_info)
  echo -ns ' '
  echo -ns $branch_color (_branch_info) $normal
end

function _prompt
  set -l normal (set_color normal)
  set -l green (set_color green)

  set prompt_color $green

  echo -ns $prompt_color (_prompt_char) $normal
end

function fish_prompt
  _new_line
  _info
  _new_line
  _prompt
end
