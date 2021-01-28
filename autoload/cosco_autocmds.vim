" =========================================================
" Filename: cosco_autocmds.vim
" Author: TornaxO7
" Last changes: 28.01.21
" Version: 1.0
" Usage: 
"     Here is the function which sets up all autocmds
"     which are needed for the cosco plugin. In general
"     the autocmds are used to do the autoplacing of the
"     commas and secmicolons.
" =========================================================

function cosco_autocmds#RefreshAutocmds()
  " set for each event in the g:cosco_auto_comma_or_semicolon_events
  " the function to add a semicolon or a comma
  augroup auto_comma_or_semicolon
      autocmd!
  
      if g:cosco_auto_comma_or_semicolon >= 1
  
          " 0 => Current filetype is not in the whitelist
          " 1 => Current filetype is in the whitelist
          let b:ft_is_in_whitelist = 0
  
          " look if the current filetype is in the whitelist
          for b:enabled_ft in g:cosco_whitelist
              if b:enabled_ft == &ft
                  let b:ft_is_in_whitelist = 1
                  break
              endif
          endfor
  
          if b:ft_is_in_whitelist
              " enable for each event the auto comma/semicolon placer
              for event in g:cosco_auto_comma_or_semicolon_events
                  execute "autocmd " .event. " <buffer> call cosco#CommaOrSemiColon()"
              endfor
          endif
      endif
  augroup END
endfunction
