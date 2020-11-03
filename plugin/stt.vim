" stt.vim - Simple Togglable Terminal
" Author: Cássio Ávila (AKA toniz4)
" Version: 0.4
" TODO: Better terminal resizing, make it possible to configure the size and
" 		make it a fixed size when opening more then one terminal split
" TODO: Better vim support
" TODO: Fix this mess of a code

if !exists('g:stt_auto_insert')
	 let g:stt_auto_insert = 0
endif

if !exists('g:stt_auto_quit')
	let g:stt_auto_quit = 0
endif


if !exists('auloaded')
	let auloaded = 1
	augroup stt
		autocmd BufEnter term://* if g:stt_auto_insert == 1 | startinsert | endif
		autocmd BufEnter * if (g:stt_auto_quit == 1 && winnr("$") == 1
					\ && exists('s:termbufnums')
					\ && get(getwininfo(win_getid()),0).terminal) | q | endif
	augroup END
endif

function CleanBuffer()
	unlet s:termbufnums[s:termname]
endfunction

function UpdateBuffer()
	let s:termbufnums[s:termname] = bufnr(s:termname)
endfunction

function ToggleTerm(name)
	if a:name == ''
		let s:termname = 'term://terminal'
	else
		execute "let s:termname = " . "'term://" . a:name . ".stt'"
	endif

	if !exists('s:termbufnums')
		let s:termbufnums = {}
	endif

	if !get(s:termbufnums, s:termname)
		call OpenTerm(a:name)
	else
		for l:buf in getbufinfo({'buflisted':1})
			let l:win = get(getwininfo(get(l:buf.windows, 0)), 0)

			if !l:buf.hidden
				if l:win.terminal && s:termname == buf.name
					let s:termbufnums[s:termname] = l:buf.bufnr
					execute l:win.winnr . 'hide'
				endif
			else
				if s:termbufnums[s:termname] == l:buf.bufnr
					execute 'sbuffer' . l:buf.bufnr | res 9
				endif
			endif
		endfor
	endif

	augroup CLEAN
		autocmd!
		if &hidden
			exec "autocmd BufHidden " . s:termname . " call UpdateBuffer()"
		else
			exec "autocmd BufDelete " . s:termname . " call CleanBuffer()"
		endif
	augroup END
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
			let s:termname = 'term://terminal'
		else
			execute "let s:termname = " . "'term://" . a:name . ".stt'"
		endif

		execute "file! " . s:termname
		let s:termbufnums[s:termname] = bufnr("$")
	else
		echoerr "Vim has to be compiled with terminal support!"
	endif
endfunction

command! -nargs=? ToggleTerm call ToggleTerm('<args>')
