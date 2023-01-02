if exists('g:loaded_date_time_inserter') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=0 InsertDate lua require('date-time-inserter').insert_date()
command! -nargs=0 InsertTime lua require('date-time-inserter').insert_time()
command! -nargs=0 InsertDateTime lua require('date-time-inserter').insert_date_time()

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_date_time_inserter = 1
