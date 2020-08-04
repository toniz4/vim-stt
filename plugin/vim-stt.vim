
function Term()
  if exists("t:termEx")
    unlet t:termEx
    bd! term:*
  else
    set splitbelow
    9sp | term
    startinsert
    set number&
    set relativenumber&
    autocmd! bufenter
    let t:termEx = 1
    autocmd bufenter * if (winnr("$") == 1 && exists("t:termEx")) | q | endif
    autocmd BufWinEnter,WinEnter term://* startinsert
  endif
endfunction


nmap <silent><F2> :call Term()<CR>
tmap <silent><F2> <C-\><C-n> :call Term()<CR>
