"
" To run the tests in this file, install:
"     https://github.com/h1mesuke/vim-unittest
" and then run :UnitTest
"

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
"

    " Next line is also `,`
    function! s:tc.test_prevIsComma_nextIsComma()
        put! = [
            \ 'one,',
            \ 'two',
            \ 'three,'
        \]

        normal! 2G

        " Current line has no specific ending
        exec "CommaOrSemiColon"
        call self.assert_equal('two,', getline('.'))

        " Current line ends in `,` (shouldn't add an extra one)
        exec "CommaOrSemiColon"
        call self.assert_equal('two,', getline('.'))

        " Current line ends in `;` (should replace it with `,`)
        normal! 0f,r;
        exec "CommaOrSemiColon"
        call self.assert_equal('two,', getline('.'))
    endfunction

    " Next begins with }, ] or )
    function! s:tc.test_prevIsComma_nextIsClosingBlock()
        put! = [
            \ 'one,',
            \ 'two',
            \ '}'
        \]

        normal! 2G

        " Current line has no specific ending
        exec "CommaOrSemiColon"
        call self.assert_equal('two', getline('.'))

        " Current line ends in `,`
        normal! A,
        exec "CommaOrSemiColon"
        call self.assert_equal('two', getline('.'))

        " Current line ends in `;`
        normal! A;
        exec "CommaOrSemiColon"
        call self.assert_equal('two', getline('.'))
    endfunction

    " Next line is less indent:
    function! s:tc.test_prevIsComma_nextIsLessIndented()
        put! = [
            \ '    one,',
            \ '    two',
            \ 'three;'
        \]

        normal! 2G

        " Current line has no specific ending
        exec "CommaOrSemiColon"
        call self.assert_equal('    two;', getline('.'))

        " Current line ends in `,`
        normal! f;r,
        exec "CommaOrSemiColon"
        call self.assert_equal('    two;', getline('.'))

        " Current line ends in `;`
        exec "CommaOrSemiColon"
        call self.assert_equal('    two;', getline('.'))
    endfunction

    " Next line is same indentation:
    function! s:tc.test_prevIsComma_nextIsSameIndentation()
        put! = [
            \ '    one,',
            \ '    two',
            \ '    three;'
        \]

        normal! 2G

        " Current line has no specific ending
        exec "CommaOrSemiColon"
        call self.assert_equal('    two,', getline('.'))

        " Current line ends in `,`
        exec "CommaOrSemiColon"
        call self.assert_equal('    two,', getline('.'))

        " Current line ends in `;`
        normal! f,r;
        exec "CommaOrSemiColon"
        call self.assert_equal('    two,', getline('.'))
    endfunction

"
" =============================
" Previous line ending with `;`
" =============================
"
    " Next line is also `;`
    function! s:tc.test_prevSC_nextSC()
            put! = [
                \ 'one;',
                \ 'two',
                \ 'three;'
            \]

            normal! 2G

            " Current line has no specific ending
            exec "CommaOrSemiColon"
            call self.assert_equal('two;', getline('.'))

            " Current line ends in `,`
            normal! f;r,
            exec "CommaOrSemiColon"
            call self.assert_equal('two;', getline('.'))

            " Current line ends in `;`
            normal! f,r;
            exec "CommaOrSemiColon"
            call self.assert_equal('two;', getline('.'))
    endfunction

"
" =============================
" Previous line ending with `{`
" =============================
"

    " Next line is `,`
    function! s:tc.test_prevIsLeftCurlyBrace_nextIsComma()
    endfunction

    " Next line is whatever
    function! s:tc.test_prevIsLeftCurlyBrace_nextIsWhatever()
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
