let s:save_cpo = &cpo
set cpo&vim


let s:cmdline_was_empty = 1

function! vimshell_kawaii#emptycmd(cmdline, context)
  let s:cmdline_was_empty = 1
  " emptycmd as error
  let b:vimshell.system_variables['status'] = 1
  return a:cmdline
endfunction

function! vimshell_kawaii#notfound(cmdline, context)
  let s:cmdline_was_empty = 0
  " notfound as error
  let b:vimshell.system_variables['status'] = 1
  return a:cmdline
endfunction

function! vimshell_kawaii#preexec(cmdline, context)
  let s:cmdline_was_empty = 0
  " ステータスコードを返さないコマンドがあるので、
  " 一旦コードを0にリセット
  " Some commands doesn't return the status code,
  " so I need to reset this manually.
  let b:vimshell.system_variables['status'] = 0
  return a:cmdline
endfunction

function! vimshell_kawaii#postexec(cmdline, context)
  let g:vimshell_kawaii_last_cmd = a:cmdline
  return a:cmdline
endfunction

function! vimshell_kawaii#prompt()
  if s:cmdline_was_empty
      return g:vimshell_kawaii_prompt_normal
  endif
  let l:status = b:vimshell.system_variables['status'] 
  let l:prompt = l:status == 0 ? g:vimshell_kawaii_prompt_happy : g:vimshell_kawaii_prompt_sad
  if l:status != 0 && g:vimshell_kawaii_prompt_append_error == 1
    let l:prompt = l:prompt . 'exit ' . l:status . ' "' . g:vimshell_kawaii_last_cmd . '"'
  endif
  return l:prompt
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
