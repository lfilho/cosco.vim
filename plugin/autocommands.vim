" =========================================================
" Filename: autocommands.vim
" Author: TornaxO7
" Last changes: 27.01.21
" Version: 1.0
" Usage: 
"     Enable the auto comma/semicolon for the specifique
"     events.
" =========================================================
" find out which filetypes are allowed to have the autosetter
augroup auto_comma_or_semicolon
    autocmd!
    "for event in g:auto_comma_or_semicolon_events

    "    " set the auto-setting only for specifique filetypes
    "    execute "au " . event . " c call AutoCommaOrSemiColon()"
    "endfor
    if g:cosco_auto_comma_or_semicolon >= 1
        autocmd TextChangedI *.c call cosco#CommaOrSemiColon()
    endif
augroup END
