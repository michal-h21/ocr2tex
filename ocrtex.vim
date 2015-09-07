let g:imgpattern =  "img/%s-%i.jpg"
lua << EOF

-- img_pattern = "img/%s-%i.jpg"

EOF

function! OpenPageImage()
lua << EOF
  local i = vim.window().line
  local buffer = vim.buffer()
  local line = buffer[i] or ""
  local matcher = function(a) return a:match("breakpage%{([0-9]+)") end
  local page = matcher(line)
  while i > 0 and not page do
    i = i - 1
    line = buffer[i]
    page = matcher(line)
  end
  print("Radek "..i.. " strana "..page)
  local pattern = vim.eval "g:imgpattern"
  print(string.format(pattern, "vlcek_ekonomie2", page))
EOF
endfunction


