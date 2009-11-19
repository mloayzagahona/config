" ku kind: buffer
" Version: 0.2.0
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

if exists('g:loaded_ku_kind_buffer')
  finish
endif




call ku#define_kind({
\   'default_action_table': {
\     'default': function('ku#action#buffer#open'),
\     'delete': function('ku#action#buffer#delete'),
\     'open!': function('ku#action#buffer#open_x'),
\     'open': function('ku#action#buffer#open'),
\     'unload': function('ku#action#buffer#unload'),
\     'wipeout': function('ku#action#buffer#wipeout'),
\    },
\   'default_key_table': {
\     "\<C-o>": 'open',
\     'D': 'delete',
\     'O': 'open!',
\     'U': 'unload',
\     'W': 'wipeout',
\     'o': 'open',
\    },
\   'name': 'buffer',
\ })




let g:loaded_ku_kind_buffer = 1

" __END__
" vim: foldmethod=marker