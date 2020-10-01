" stt.vim - Simple Togglable Terminal
" Author: Cássio Ávila (AKA toniz4)
" Version: 0.3
" TODO: Hide terminal based on name
" TODO: Better vim support

if !exists('g:stt_auto_insert')
	 let g:stt_auto_insert = 0
endif

if !exists('g:stt_auto_quit')
	let g:stt_auto_quit = 0
endif

augroup stt
	autocmd BufEnter stt-term if g:stt_auto_insert == 1 | startinsert | endif
	autocmd BufEnter * if (g:stt_auto_quit == 1 && winnr("$") == 1
				\ && exists('s:termbufnum')
				\ && get(getwininfo(win_getid()),0).terminal) | q | endif
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
	if has('nvim')
		9sp | terminal
	elseif has('terminal')
		terminal ++close
		res 9
	endif
	setlocal number&
	setlocal relativenumber&
	setlocal nomodified&
	if g:stt_auto_insert == 1
		startinsert
	endif
	file stt-term
	let s:termbufnum = bufnr("$")
endfunction

command ToggleTerm call ToggleTerm()
