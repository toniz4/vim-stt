" stt.vim - Simple Togglable Terminal 
" Author: Cássio Ávila (AKA toniz4)
" Version: 0.1

if exists("g:stt_auto_insert")
else
	 let g:stt_auto_insert = 1
endif

let t:term_exists = 0

augroup stt
	autocmd!
	autocmd WinEnter term://* let t:is_term_win = 1 
	autocmd WinLeave term://* let t:is_term_win = 0
	autocmd bufenter * if (winnr("$") == 1 && t:term_exists == 1 && t:is_term_win == 1) | q | endif
	autocmd BufDelete term://* let t:term_exists = 0 
augroup END

function Term()
	if t:term_exists == 1
		let t:term_exists = 0
		bd! term:*
	else
		let t:term_exists = 1
		set splitbelow
		9sp | term
		if g:stt_auto_insert == 1
			startinsert
		endif
		set number&
		set relativenumber&
		autocmd! bufenter
	endif
endfunction

command ToggleTerm call Term()
