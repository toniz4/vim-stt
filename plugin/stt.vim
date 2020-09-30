" stt.vim - Simple Togglable Terminal
" Author: Cássio Ávila (AKA toniz4)
" Version: 0.3
" TODO: Hide terminal based on name
" TODO: Better auto commands

if exists("g:stt_auto_insert")
else
	 let g:stt_auto_insert = 0
endif

augroup stt
	autocmd BufEnter term://* startinsert | if g:stt_auto_insert == 1 |
				\ let t:term_exists = 1 | endif
	autocmd WinEnter term://* let t:is_term_win = 1
	autocmd WinLeave term://* let t:is_term_win = 0
	"Quit when the only window is a terminal window
	autocmd bufenter * if (winnr("$") == 1 && exists('t:term_exists')
		\ && t:is_term_win == 1) | q | endif
augroup END

function ToggleTerm()
	if !exists('s:termbufnum')
		call OpenTerm()
	else
		for l:buf in getbufinfo({'buflisted':1})
			let l:win = get(getwininfo(get(l:buf.windows, 0)), 0)

			if !l:buf.hidden
				if l:win.terminal
					let s:termbufnum = l:buf.bufnr
					execute l:win.winnr . 'hide'
				endif
			else
				if s:termbufnum == l:buf.bufnr
					execute 'sbuffer' . l:buf.bufnr | res 9
				endif
			endif
		endfor
	endif
endfunction

function OpenTerm()
	setlocal splitbelow
	9sp | term
	setlocal number&
	setlocal relativenumber&
	if g:stt_auto_insert == 1
		startinsert
	endif
	let s:termbufnum = bufnr("$")
endfunction

command ToggleTerm call ToggleTerm()
command OpenTerm call OpenTerm()
