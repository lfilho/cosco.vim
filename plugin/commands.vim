" =========================================================
" Filename: commands.vim
" Author: TornaxO7
" Last changes: 27.01.21
" Version: 1.0
" Usage: 
"     Here are all available commands of the plugin.
" =========================================================

" =========================
" Commandline commands 
" =========================
command! CommaOrSemiColon call cosco#commaOrSemiColon()
command! AutoCommaOrSemiColonToggle :call cosco_helpers#AutoCommaOrSemiColonToggle()

" ====================
" <Plug> Commands 
" ====================
nnoremap <silent> <nowait> <Plug>(cosco-commaOrSemiColon)
\ :<C-u>silent! call cosco#commaOrSemiColon()<Bar>
\ silent! call repeat#set("\<Plug>(cosco-commaOrSemiColon)")<CR>
