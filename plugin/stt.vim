" stt.vim - Simple Togglable Terminal
" Author: Cássio Ávila (AKA toniz4)
" Version: 0.4
" TODO: Better terminal resizing, make it possible to configure the size and
" 		make it a fixed size when opening more then one terminal split
" TODO: Better vim support

if !exists('g:stt_auto_insert')
	 let g:stt_auto_insert = 0
endif

if !exists('g:stt_auto_quit')
	let g:stt_auto_quit = 0
endif

if !exists('s:termbufnums')
	let s:termbufnums = {}
endif

if !exists('auloaded')
	let auloaded = 1
	augroup stt
		autocmd BufEnter term:/* if g:stt_auto_insert == 1 | startinsert | endif
		autocmd BufEnter * if (g:stt_auto_quit == 1 && winnr("$") == 1
					\ && exists('s:termbufnums')
					\ && get(getwininfo(win_getid()),0).terminal) | q | endif
		autocmd BufDelete term:/* unlet s:termbufnum
	augroup END
endif

function ToggleTerm(name)
	if a:name == ''
		let l:termname = 'term:/terminal'
	else
		execute "let l:termname = " . "'term:/" . a:name . ".stt'"
	endif

	if !get(s:termbufnums, l:termname)
		call OpenTerm(a:name)
	else
		for l:buf in getbufinfo({'buflisted':1})
			let l:win = get(getwininfo(get(l:buf.windows, 0)), 0)

			if !l:buf.hidden
				if l:win.terminal && l:termname == buf.name
					let s:termbufnums[l:termname] = l:buf.bufnr
					execute l:win.winnr . 'hide'
				endif
			else
				if s:termbufnums[l:termname] == l:buf.bufnr
					execute 'sbuffer' . l:buf.bufnr | res 9
				endif
			endif
		endfor
	endif
endfunction

function! OpenTerm(name) abort
	if has('nvim') || has('terminal')
		setlocal splitbelow
		if has('nvim')
			9sp | terminal
		else
			terminal ++close
			res 9
		endif
		setlocal number&
		setlocal relativenumber&
		setlocal nomodified&
		if g:stt_auto_insert == 1
			startinsert
		endif

		if a:name == ''
			let l:termname = 'term:/terminal'
		else
			execute "let l:termname = " . "'term:/" . a:name . ".stt'"
		endif

		execute "file! " . l:termname
		let s:termbufnums[l:termname] = bufnr("$")
	else
		echoerr "Vim has to be compiled with terminal support!"
	endif
endfunction

command! -nargs=? ToggleTerm call ToggleTerm('<args>')
