" stt.vim - Simple Togglable Terminal 
" Author: Cássio Ávila (AKA toniz4)
" Version: 0.2
" TODO: Hide terminal buffer, not delete it

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
	autocmd BufDelete term://* let t:term_exists = 0 | unlet t:term_win_num | unlet t:term_visible
	if g:stt_auto_insert == 1
		autocmd BufEnter term://* startinsert
	endif
augroup END

function TermInit() 
	let t:term_visible = 1
	let t:term_exists = 1
	setlocal splitbelow
	9sp | term
	if g:stt_auto_insert == 1
		startinsert
	endif
	setlocal number&
	setlocal relativenumber&
	let t:term_win_num = bufnr('term://*')
endfunction

function Term()
	if (exists('t:term_visible') && exists('t:term_win_num'))
		let t:term_win_num = bufnr('term://*')
		if t:term_visible == 1
			execute t:term_win_num . ' hide'
			let t:term_visible = 0
		else
			let t:term_visible = 1
			execute 'sbuffer' . t:term_win_num | res 9
		endif
	else
		call TermInit()
	endif
endfunction

command ToggleTerm call Term()
