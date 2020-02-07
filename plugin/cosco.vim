" File: plugin/cosco.vim

" ===============================================
" Examples on how to use it (also on the README):
" ===============================================

" autocmd FileType c,cpp,css,java,javascript,perl,php,jade nmap <silent> <Leader>; <Plug>(cosco-commaOrSemiColon)
" autocmd FileType c,cpp,css,java,javascript,perl,php,jade imap <silent> <Leader>; <c-o><Plug>(cosco-commaOrSemiColon)
" command! CommaOrSemiColon call cosco#commaOrSemiColon()

if !exists("g:cosco_auto_comma_or_semicolon")
    let g:cosco_auto_comma_or_semicolon = 0
endif

if !exists("g:cosco_auto_comma_or_semicolon_events")
    let g:cosco_auto_comma_or_semicolon_events = ["InsertLeave"]
endif

augroup auto_comma_or_semicolon
    autocmd!
    for event in g:cosco_auto_comma_or_semicolon_events
        execute "au " . event . " * call AutoCommaOrSemiColon()"
    endfor
augroup END

command! AutoCommaOrSemiColonToggle :call AutoCommaOrSemiColonToggle()
function! AutoCommaOrSemiColonToggle()
    if g:cosco_auto_comma_or_semicolon >= 1
        let g:cosco_auto_comma_or_semicolon = 0
        echo "AutoCommaOrSemiColon is OFF"
    else
        let g:cosco_auto_comma_or_semicolon = 1
        echo "AutoCommaOrSemiColon is ON"
    endif
endfunction

function! AutoCommaOrSemiColon()
    if g:cosco_auto_comma_or_semicolon >= 1
        call cosco#commaOrSemiColon()
    endif
endfunction

command! CommaOrSemiColon call cosco#commaOrSemiColon()

"====================================
" <Plug> mapping with repeat support:
"====================================

nnoremap <silent> <nowait> <Plug>(cosco-commaOrSemiColon)
\ :<C-u>silent! call cosco#commaOrSemiColon()<Bar>
\ silent! call repeat#set("\<Plug>(cosco-commaOrSemiColon)")<CR>

