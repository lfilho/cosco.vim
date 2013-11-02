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

## Demo / Examples

Examples (as well this plugin) were created with javascript in mind (but the plugin works for any kind of file).

[![Click to watch the video](http://img.youtube.com/vi/xCSjdqf8sOY/0.jpg)](http://www.youtube.com/watch?v=xCSjdqf8sOY)

*(Click the image to watch the video)*

## Installation

1. Add `lfilho/cosco.vim` to your [Vundle](https://github.com/gmarik/vundle), [NeoBundle](https://github.com/Shougo/neobundle.vim), [pathogen](https://github.com/tpope/vim-pathogen), or [manually copy the files](http://superuser.com/a/404820)... You know the deal.
2. Run your Vundle/NeoBundle/pathogen process of updating / installing new bundles... (Links above should help you)
3. [Use it](#usage)
4. Profit!

## Usage

Cosco command won't override any mappings or commands you might already have. You have to add them yourself. (Good vim plugin writing practice!).
Here you can find two examples on how to do this. Put them on your `.vimrc`

### Using it via command

```VimL
command! CommaOrSemiColon call cosco#commaOrSemiColon()
```

and then you can just issue `:CommaOrSemiColon`.

### Using it via mappings

Example mapping the key combo `,;` for both `normal` and `insert` modes:

```VimL
autocmd FileType javascript,css,YOUR_LANG nmap <silent> ,; :call cosco#commaOrSemiColon()<CR>
autocmd FileType javascript,css,YOUR_LANG inoremap <silent> ,; <ESC>:call cosco#commaOrSemiColon()"<CR>a
```

and then you can just type `,;`.

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

* Write plugin's vim documentation
* Write all the examples possible
* Improve test coverage
* Write mappings examples using autocommand grouping
