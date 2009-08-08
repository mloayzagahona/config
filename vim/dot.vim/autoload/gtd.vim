" gtd - Support to do Getting Things Done
" Version: 0.0.0
" Copyright (C) 2009 kana <http://whileimautomaton.net/>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
" Interface  "{{{1
function! gtd#initialize()  "{{{2
  % delete _

  put ='INBOX'
  put ='NEXT ACTIONS'
  put ='CALENDAR'
  put ='PROJECTS'
  put ='WAITING FOR'
  put ='SOMEDAY'
  put ='ARCHIVE'
  put ='TRASH'
  put ='; vim: filetype=gtd'

  1 delete _
endfunction




function! gtd#jump_to_issue()  "{{{2
  throw 'FIXME: NIY'
endfunction




function! gtd#mark(section_name)  "{{{2
  throw 'FIXME: NIY'
endfunction




function! gtd#new_issue()  "{{{2
  let [max_id, sum] = gtd#status()
  let new_id = max_id + 1

  normal! ggzv
  call search('^INBOX$', 'cW')
  put ='#' . new_id . ' '
  startinsert!
endfunction




function! gtd#new_note()  "{{{2
  throw 'FIXME: NIY'
endfunction




function! gtd#status()  "{{{2
  let max_id = 0
  let sum = 0

  let pos = getpos('.')
    global/^#/
    \   let sum = sum + 1
    \ | let id = str2nr(matchstr(getline('.'), '^#\zs\d\+\ze'))
    \ | let max_id = max_id < id ? id : max_id
  call setpos('.', pos)

  return [max_id, sum]
endfunction








" __END__  "{{{1
" vim: foldmethod=marker
