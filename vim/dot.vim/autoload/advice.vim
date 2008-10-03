" advice - alter the behavior of a command in modular way
" Version: 0.0.0
" Copyright (C) 2008 kana <http://whileimautomaton.net/>
" CONT:
" - advice#*_pattern()
" - the core - interface mapping & s:do_adviced_command()
" - error handling
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
" Variables  "{{{1

" {
"   '{cmd_name}': {
"     'cmd_key': '{cmd_key}',
"     'need_remap_p': '{need_remap_p}',
"     'cmd_specs': 'cmd_specs',
"     '{mode}': {
"       'before': [[{ad_name}, {func_name}, {enabled_p}], ...],
"       'after': [[{ad_name}, {func_name}, {enabled_p}], ...],
"     }
"   },
"   ...
" }
"
" PLAN: {priority} to control the order of advices.
let s:_ = {}

let s:I_AD_NAME = 0
let s:I_FUNC_NAME = 1
let s:I_ENABLED_P = 2








" Interface  "{{{1
function! advice#define(cmd_name, modes, cmd_key, need_remap_p, cmd_specs)  "{{{2
  for mode in s:each_char(a:modes)
    call s:define_interface_mapping_in(mode, a:cmd_name)
  endfor

  call s:ensure_cmd_entry(a:cmd_name, a:modes)
  let cmd_entry = s:cmd_entry_of(a:cmd_name)
  let cmd_entry['cmd_key'] = a:cmd_key
  let cmd_entry['need_remap_p'] = a:need_remap_p
  let cmd_entry['cmd_specs'] = a:cmd_specs
endfunction




function! advice#add(cmd_name, modes, class, ad_name, func_name)  "{{{2
  for mode in s:each_char(a:modes)
    let advices = s:advices_of(a:cmd_name, mode, a:class)
    let i = s:index_of_advice(a:ad_name, advices)
    if i == -1
      call insert(advices, [a:ad_name, a:func_name, !0])
    else
      let advices[i][s:I_FUNC_NAME] = a:func_name
    endif
  endfor
endfunction




function! advice#remove(cmd_name, modes, class, ad_name)  "{{{2
  for mode in s:each_char(a:modes)
    let advices = s:advices_of(a:cmd_name, mode, a:class)
    let i = s:index_of_advice(a:ad_name, advices)
    if i == -1
      echoerr 'No such advice'
    else
      call remove(advices, i)
    endif
  endfor
endfunction




function! advice#remove_all(cmd_name, modes, class)  "{{{2
  for mode in s:each_char(a:modes)
    let advices = s:advices_of(a:cmd_name, mode, a:class)
    call remove(advices, 0, -1)
  endfor
endfunction




function! advice#remove_pattern(pattern)  "{{{2
  throw 'NIY'
endfunction




function! advice#enable(cmd_name, modes, class, ad_name)  "{{{2
  call s:set_enabled_flag(a:cmd_name, a:modes, a:class, a:ad_name, !0)
endfunction




function! advice#disable(cmd_name, modes, class, ad_name)  "{{{2
  call s:set_enabled_flag(a:cmd_name, a:modes, a:class, a:ad_name, !!0)
endfunction




function! advice#enable_all(cmd_name, modes, class)  "{{{2
  call s:set_enabled_flag_all(a:cmd_name, a:modes, a:class, !0)
endfunction




function! advice#disable_all(cmd_name, modes, class)  "{{{2
  call s:set_enabled_flag_all(a:cmd_name, a:modes, a:class, !!0)
endfunction




function! advice#enable_pattern(pattern)  "{{{2
  throw 'NIY'
endfunction




function! advice#disable_pattern(pattern)  "{{{2
  throw 'NIY'
endfunction








" Misc.  "{{{1
function! s:cmd_entry_of(cmd_name)  "{{{2
  return s:_[a:cmd_name]
endfunction




function! s:do_adviced_command(cmd_name, mode)  "{{{2
  throw 'NIY'
  " XXX: error on undefined modes.
  " XXX: handling errors raised in advices.

  " (1) do before advices.
  let before_advices = s:advices_of(a:cmd_name, a:mode, 'before')
  for advice in before_advices
    if advice[s:I_ENABLED_P]
      call {advice[s:I_FUNC_NAME]}()
    endif
  endfor

  " (2) do the original command.
  let _ = s:cmd_entry_of(a:cmd_name)
  let cmd_key = _['cmd_key']
  let need_remap_p = _['need_remap_p']
  let cmd_specs = _['cmd_specs']

  if cmd_specs ==# 'none'
    if a:mode =~# '[nvoi]'
      execute 'normal'.(need_remap_p ? '' : '!') cmd_key
    elseif a:mode ==# 'c'
      return cmd_key
    else
      echoerr 'Not supported mode:' string(a:mode)
    endif
  else
    " XXX: cmd_specs support - motion, char, line.
    echoerr 'Not supported {cmd-specs}:' string(cmd_specs)
  endif

  " (3) do after advices.
  let after_advices = s:advices_of(a:cmd_name, a:mode, 'after')
  for advice in after_advices
    if advice[s:I_ENABLED_P]
      call {advice[s:I_FUNC_NAME]}()
    endif
  endfor

  return
endfunction




function! s:each_char(s)  "{{{2
  " for c in s:each_char('abc') ==> for c in ['a', 'b', 'c']
  let _ = split(a:s, '.\zs', !0)
  call remove(_, -1)
  return _
endfunction




function! s:set_enabled_flag_all(cmd_name, modes, class, value)  "{{{2
  for mode in s:each_char(a:modes)
    let advices = s:advices_of(a:cmd_name, mode, a:class)
    for _ in advices
      let _[s:I_ENABLED_P] = !0
    endfor
  endfor
endfunction




function! s:set_enabled_flag(cmd_name, modes, class, ad_name, value)  "{{{2
  for mode in s:each_char(a:modes)
    let advices = s:advices_of(a:cmd_name, mode, a:class)
    let i = s:index_of_advice(a:ad_name, advices)
    if i == -1
      echoerr 'No such advice'
    else
      let advices[i][s:I_ENABLED_P] = a:value
    endif
  endfor
endfunction




function! s:index_of_advice(ad_name, advices)  "{{{2
  let i = 0
  for entry in a:advices
    let [ad_name, func_name, enabed_p] = entry
    if a:ad_name ==# ad_name
      return i
    endif
    let i += 1
  endfor
  return -1
endfunction




function! s:advices_of(cmd_name, mode, class)  "{{{2
  call s:ensure_cmd_entry(a:cmd_name, a:mode)
  return s:_[a:cmd_name][a:mode][a:class]
endfunction




function! s:ensure_cmd_entry(cmd_name, modes)  "{{{2
  if !has_key(s:_, a:cmd_name)
    let s:_[a:cmd_name] = {}
  endif

  for mode in s:each_char(a:modes)
    if !has_key(s:_[a:cmd_name], mode)
      let s:_[a:cmd_name][mode] = {'before': [], 'after': []}
    endif
  endfor
endfunction




function! advice#_dump()  "{{{2
  echo string(s:_)
endfunction




function! s:define_interface_mapping_in(mode, cmd_name)  "{{{2
  execute printf(
  \   '%snoremap <expr> <Plug>(adviced-%s)  <SID>do_adviced_command(%s, "%s")',
  \   a:mode,
  \   a:cmd_name,
  \   string(a:cmd_name),
  \   a:mode
  \ )
endfunction




" To save the cursor position before <C-o> in Insert mode  "{{{2

inoremap <expr> <SID>(save-position)  <SID>push_position()

let s:saved_positions = []  " [cursor_position, ...]  new <-> old

function! s:push_position()
  call insert(s:saved_positions, getpos('.'))
endfunction

function! s:pop_position()
  return remove(s:saved_positions, 0)
endfunction








" __END__  "{{{1
" vim: foldmethod=marker