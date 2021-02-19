" =========================================================
" Filename: cosco.vim
" Usage: 
"     Here are all values which are loaded first for the
"     cosco plugin. It has the following structure:
"       1. Variables
"         1.1 Configurable Variables
"         1.2 Core variables (shouldn't be configured directly
"           from the user).
"       2. Autocommands.
"       3. Available commands for the user.
"         3.1 Commandline commands
"         3.2 <Plug> commands
" =========================================================

" don't reload the plugin too often
if exists("b:cosco_initialised")
    finish
endif
let b:cosco_initialised = 1

" =================
" 1. Variables 
" =================
" ---------------------------
" 1.1 Configurable variables 
" ---------------------------
" should cosco set the semicolons/commas automatically?
" Possible Vales:
"   0 => Don't set commas/semicolons automatically
"   1 => Set commas/semicolons automatically
if !exists("g:cosco_auto_setter")
    let g:cosco_auto_setter = 1
endif

" all events where cosco should set comments/semicolons automatically
" see :h autocmd-events to get all possible events
if !exists("g:cosco_auto_setter_events")
    let g:cosco_auto_setter_events = ["TextChangedI"]
endif

" should cosco add semicolons/commas in comments as well?
" Possible Values:
"   0 => No
"   1 => Yes
if !exists("g:cosco_ignore_comments")
    let g:cosco_ignore_comments = 1
endif

" which filetypes should be added?
if !exists("g:cosco_whitelist")
    let g:cosco_whitelist = [
        \ "c",
        \ "cpp",
        \ "css",
        \ "javascript",
        \ "rust"
        \]
endif

" Possible values:
"   0 => Disable cosco :(
"   1 => Enable cosco :)
if !exists("g:cosco_enable")
    let g:cosco_enable = 1
endif

" -------------------
" Core variables 
" -------------------
" here are all variables which shouldn't be changed by
" the user. Only rather for debugging or intern usages.

" enable logging while scanning the situation in the
" cosco_eval#Decide() function.
if !exists("g:cosco_debug")
    let g:cosco_debug = 0
endif

" ============================
" 2. Autocommands/Mapping 
" ============================
" make sure first of all, that the user wants the autosetting
if g:cosco_auto_setter >= 1

    if mapcheck('<CR>') == ''
        imap <CR> <CR><CMD>call cosco#AdaptCode()<CR>
    else
        " refresh the autocommands if the user moves to another buffer
        autocmd BufEnter * call cosco_autocmds#RefreshAutocmds()
    endif
endif

" ================
" 3. Commands 
" ================
" -------------------------
" 3.1 Commandline commands 
" -------------------------
command! CoscoAdaptCode :call cosco_eval#Manual()<CR>
command! CoscoToggleAutoSetter :call cosco_helpers#AutoSetterToggle()

" --------------------
" 3.2 <Plug> Commands 
" --------------------
nnoremap <silent> <nowait> <Plug>(cosco-AdaptCode)
    \ :<C-u>silent! call cosco#AdaptCode()<Bar>
    \ silent! call repeat#set("\<Plug>(cosco-AdaptCode)")<CR>
