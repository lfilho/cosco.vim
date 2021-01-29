" =========================================================
" Filename: test_cosco.vim
" Author: TornaxO7
" Last changes: 29.01.21
" Version: 1.0
" Usage: 
"     This lets cosco goes through some unittest
"     in order to check if everything works fine.
"
"     To run the tests in this file, install:
"       https://github.com/h1mesuke/vim-unittest
"     and then run (in this file):
"       :UnitTest
"     After that, leave with
"       :qa!
"
" Order of unittests:
"
" =========================================================

" =================
" Preparations 
" =================
let s:tc = unittest#testcase#new("Cosco.vim")

function! s:tc.setup()
    new
endfunction

function! s:tc.teardown()
    close!
endfunction

" ================
" Adding code 
" ================
" -- Assignment --
function! s:tc.test_assignment()
    put! = 
endfunction
