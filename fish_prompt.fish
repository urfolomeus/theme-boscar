function _top_line
  set_color blue
  printf $PWD
  set_color normal
end

function _bottom_line
  printf '> '
end

function fish_prompt
  echo -e ''
  _top_line
  echo
  _bottom_line
end
