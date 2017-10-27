function _print_path
  set cwd (prompt_segments)
  printf '%s' (string join '/' $cwd)
end

function _top_line
  set_color blue
  _print_path
  set_color normal
end

function _bottom_line
  printf '⋊> '
end

function fish_prompt
  echo -e ''
  _top_line
  echo
  _bottom_line
end
