function _print_path
  set cwd (prompt_segments)
  printf '%s' (string join '/' $cwd)
end

function _print_prompt_char
  printf '⋊> '
end

function fish_prompt
  set -l last_status $status

  set -l normal (set_color normal)
  set -l blue (set_color blue)
  set -l green (set_color green)
  set -l red (set_color red)

  set -l dir_color $blue

  set -l prompt_color $red
  if test $last_status = 0
    set prompt_color $green
  end

  echo -e ''
  echo -e -n -s $dir_color (_print_path) $normal
  echo -e ''
  echo -e -n -s $prompt_color (_print_prompt_char) $normal
end
