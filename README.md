cosco.vim
=========

**Co**mma and **s**emi-**co**lon insertion bliss for vim.

## What Cosco does:

Appends, substitutes or removes a comma or a semi-colon to the end of your line, based on its context.

It:

* Takes into consideration previous and next lines endings, as well line indentations.
* Ignores blank lines.
* Will maintain your cursor's original position.

The best way to describe it is with examples.

## Examples

Examples (as well this plugin) were created with javascript in mind (but the plugin works for any kind of file).

**Important:** For the examples below, consider:

* The cursor is in the middle line (in any column).
* You can have any amount of blank lines padding your cursor line.
* The `?` symbol means that it can be anything: a `,`, a `;` or blank;
    * If `?` is either `;` or `,`, Cosco will **substitute** it. Otherwise, it will **append to** it;
* The character you should pay attention for in the surrounding lines are also highlighted like this: `.`

Before   | After
------   | -----
one`;`   | one;
two`?`   | two;
three`;` | three;

Before   | After
------   | -----
one`,`   | one,
two`?`   | two,
three`,` | three,

Many, many, many more examples to come.

## Installation

1. Add `lfilho/cosco.vim` to your Vundle, NeoBundle, pathogen, or manually copy the files... You know the deal.
2. Run your Vundle/NeoBundle/pathogen process of updating / installing new bundles...
3. Use it (see next section how)
4. Profit!

## Usage

Cosco command won't override any mappings you might already have.
It will only provide you a new command `CommaOrSemiColon` that you can use on its or with a mapping (both `normal` or `insert` modes!).

### Using it via command

```VimL
:CommaOrSemiColon
```

### Using it via mappings

Example mapping they key combo `,;` to the command, in both `normal` and `insert` modes:

```VimL
autocmd FileType c,cpp,css,java,javascript,perl,php,jade nmap <silent> ,; :execute "CommaOrSemiColon"<CR>
autocmd FileType c,cpp,css,java,javascript,perl,php,jade inoremap <silent> ,; <ESC>:execute "CommaOrSemiColon"<CR>a
```

## Tests

Tests are done with [vim-unittest](https://github.com/h1mesuke/vim-unittest).

## Known caveats

```javascript
){
    'use strict';

    var foo = 2,
        bar = null;
```

Will change the `use strict` line ending to a comma (it thinks we are inside a hash declaration). Can't really address this issue without a `var` (specific to javascript) check. Might be resolved if we develop a language extension to this plugin.

## TODO and wish list

* Create a language extension mechanism, so we can override/extend the rules for language-specific syntaxes.
* Write plugin's vim documentation
* Write all the examples possible
* Improve test coverage
* Record a video with "real world" usage
