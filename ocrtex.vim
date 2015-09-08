let s:imgpattern =  "%s/%s-%03d.jpg"
let s:filename = @%
let g:ocrimgdir = "img"
let g:ocrcorrection=0

nnoremap <leader>o :call OpenPageImage()<cr>
nnoremap <leader>s :source ocrtex.vim<cr>
nnoremap <leader>- :call SubOcrCorrection()<cr>
nnoremap <leader>+ :call AddOcrCorrection()<cr>
nnoremap <leader>r :call RemoveMarkup()<cr>

lua << EOF
local function getBreakPageNo(i, buffer)
  local line = buffer[i] or ""
  local matcher = function(a) return a:match("breakpage%{([0-9]+)") end
  local page = matcher(line)
  while i > 0 and not page do
    i = i - 1
    line = buffer[i]
    page = matcher(line)
  end
  return tonumber(page), i
end


local function getImageName(page)
  local pattern = vim.eval "s:imgpattern"
  local filename = vim.eval "s:filename":gsub(".tex$","")
  local imgdir = vim.eval "g:ocrimgdir"
  return string.format(pattern,imgdir, filename, page)
end
EOF

function! RemoveMarkup()
lua << EOF
  local i = vim.window().line
  local buffer = vim.buffer()
  local text = buffer[i]
  buffer[i] = text:gsub("\\[a-z]+","")
EOF
endfunction

function! OpenPageImage()
lua << EOF
  local i = vim.window().line
  local buffer = vim.buffer()
  local page, i =  getBreakPageNo(i,  buffer)
  local correction = vim.eval "g:ocrcorrection"
  page = page + correction
  local imagename = getImageName(page)
  -- vim.command 'execute system("killall feh")'
  -- vim.command(string.format("execute 'silent !feh %s &'", imagename))
  local cmd = string.format("execute system('feh %s &')", imagename)
  print("Open image: "..cmd)
  vim.command(cmd)
EOF
endfunction

function! AddOcrCorrection()
  let g:ocrcorrection = g:ocrcorrection + 1
endfunction

function! SubOcrCorrection()
  let g:ocrcorrection = g:ocrcorrection - 1
endfunction
