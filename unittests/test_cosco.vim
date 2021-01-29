" =========================================================
" Filename: test_cosco.vim
" Author(s) - (date of last changes): 
"   TornaxO7  - 29.01.2021
"   Luiz Gonzaga dos Santos Filho - 22.07.2017
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

"
" =============================
" Previous line ending with `,`
" =============================

    " --------------------------
    " Next line is also ',' 
    " --------------------------
    function! s:tc.test_prevIsComma_nextIsComma()
        put! = [
            \ 'one,',
            \ 'two',
            \ 'three,'
        \]

        normal! 3G

        " Current line has no specific ending
        call cosco#CommaOrSemiColon()
        call self.assert_equal('two,', getline(line('.') - 1))

        " Previous line ends in `,` (shouldn't add an extra one)
        call cosco#CommaOrSemiColon()
        call self.assert_equal('two,', getline(line('.') - 1))

        " Previous line ends in `;` (should replace it with `,`)
        normal! 2k0f,r;j
        call cosco#CommaOrSemiColon()
        call self.assert_equal('two,', getline(line('.') - 1))
    endfunction

    " -----------------------------------
    " Next line beings with },] or ) 
    " -----------------------------------
    "  Test case influence (in my opinion) too much the code
    "   - TornaxO7
    "function! s:tc.test_prevIsComma_nextIsClosingBlock()
    "    put! = [
    "        \ 'one,',
    "        \ 'two',
    "        \ '}'
    "    \]

    "    normal! 2G

    "    " Current line has no specific ending
    "    call cosco#CommaOrSemiColon()
    "    call self.assert_equal('two', getline('.'))

    "    " Current line ends in `;`
    "    normal! A;
    "    call cosco#CommaOrSemiColon()
    "    call self.assert_equal('two', getline('.'))
    "endfunction

    " ------------------------------
    " Next line has less indent 
    " ------------------------------
    function! s:tc.test_prevIsComma_nextIsLessIndented()
        put! = [
            \ '    one,',
            \ '    two',
            \ 'three;'
        \]

        normal! 2G

        " Current line has no specific ending
        call cosco#CommaOrSemiColon()
        call self.assert_equal('    two;', getline('.'))

        " Current line ends in `,`
        normal! f;r,
        call cosco#CommaOrSemiColon()
        call self.assert_equal('    two;', getline('.'))

        " Current line ends in `;`
        call cosco#CommaOrSemiColon()
        call self.assert_equal('    two;', getline('.'))
    endfunction

    " -----------------------------------
    " Next line has same indentation 
    " -----------------------------------
    function! s:tc.test_prevIsComma_nextIsSameIndentation()
        put! = [
            \ '    one,',
            \ '    two',
            \ '    three;'
        \]

        normal! 2G

        " Current line has no specific ending
        call cosco#CommaOrSemiColon()
        call self.assert_equal('    two,', getline('.'))

        " Current line ends in `,`
        call cosco#CommaOrSemiColon()
        call self.assert_equal('    two,', getline('.'))

        " Current line ends in `;`
        normal! f,r;
        call cosco#CommaOrSemiColon()
        call self.assert_equal('    two,', getline('.'))
    endfunction

"
" =============================
" Previous line ending with `;`
" =============================

    " ---------------------------
    " Next line has also ';' 
    " ---------------------------
    function! s:tc.test_prevSC_nextSC()
            put! = [
                \ 'one;',
                \ 'two',
                \ 'three;'
            \]

            normal! 2G

            " Current line has no specific ending
            call cosco#CommaOrSemiColon()
            call self.assert_equal('two;', getline('.'))

            " Current line ends in `,`
            normal! f;r,
            call cosco#CommaOrSemiColon()
            call self.assert_equal('two;', getline('.'))

            " Current line ends in `;`
            normal! f,r;
            call cosco#CommaOrSemiColon()
            call self.assert_equal('two;', getline('.'))
    endfunction

"
" =============================
" Previous line ending with `{`
" =============================

    " Next line is `,`
    function! s:tc.test_prevIsLeftCurlyBrace_nextIsComma()
    endfunction

    " Next line is `var .* ,`
    function! s:tc.test_prevIsLeftCurlyBrace_nextIsVarComma()
    endfunction

    " Next line is whatever
    function! s:tc.test_prevIsLeftCurlyBrace_nextIsWhatever()
    endfunction

    " Previous line is `var .*`
    function! s:tc.test_prevIsVarLeftCurlyBrace_nextIsRightCurlyBrace()
    endfunction

"
" =============================
" Previous line ending with `[`
" =============================
"

    " Next line is `]`
    function! s:tc.test_prevIsLeftBracket_nextStartsWithRightBracket()
    endfunction

    " Next line is whatever
    function! s:tc.test_prevIsLeftBracket_nextIsWhatever()
    endfunction

"
" =============================
" Previous line ending with `(`
" =============================
"

    " Next line is `)`
    function! s:tc.test_prevIsLeftParens_nextStartsWithRightParens()
    endfunction

    " Next line is whatever
    function! s:tc.test_prevIsLeftParens_nextIsWhatever()
    endfunction

"
" ===========================
" Next line starting with `{`
" ===========================
"

    function! s:tc.test_nextStartsWithRightCurlyBrace()
        put! = [
            \ 'function nextLineBrace()',
            \ '    {',
            \ '        // Absolutely Barbaric',
            \ '    }'
        \]

        normal! gg

        " Current line has no specific ending
        call cosco#CommaOrSemiColon()
        call self.assert_equal('function nextLineBrace()', getline('.'))
    endfunction
