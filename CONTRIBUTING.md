        ______   ____    _____   ______   ____     _    __    ____    __  ___
       / ____/  / __ \  / ___/  / ____/  / __ \   | |  / /   /  _/   /  |/  /
      / /      / / / /  \__ \  / /      / / / /   | | / /    / /    / /|_/ /
     / /___   / /_/ /  ___/ / / /___   / /_/ /  _ | |/ /   _/ /    / /  / /
     \____/   \____/  /____/  \____/   \____/  (_)|___/   /___/   /_/  /_/

(ASCII art created with [figlet](https://github.com/cmatsuoka/figlet))

# Contributing

Thank you for considering to contribute to this project!
This README should help you to understand the structure of this project and what
you have to be aware of when contributing to this project!

# Table of contents

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Most important notes](#most-important-notes)
- [Plugin explanation](#plugin-explanation)
  - [File structure](#file-structure)
  - [Main file](#main-file)
  - [Autoload files](#autoload-files)
    - [cosco_autocmds.vim](#cosco_autocmdsvim)
    - [cosco_eval.vim](#cosco_evalvim)
  - [cosco_helpers.vim](#cosco_helpersvim)
  - [cosco_setter.vim](#cosco_settervim)
  - [cosco.vim](#coscovim)
- [Help pages](#help-pages)
- [Unittests](#unittests)
- [Debugging](#debugging)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Most important notes

So the important information first. If you want to contribute, please be aware
of these things:

- Explain what your code does by adding some comments. That'd be helpful for
  future changes!
- Make sure that your changes passes the unittests.

# Plugin explanation

## File structure

`cosco` has the following file structure (the "uneccessary" files aren't listed
here):

```
cosco
├── autoload
│   ├── cosco_autocmds.vim
│   ├── cosco_eval.vim
│   ├── cosco_helpers.vim
│   ├── cosco_setter.vim
│   └── cosco.vim
├── doc
│   └── cosco.txt
├── plugin
│   └── cosco.vim
└── unittests
    └── test_cosco.vim
```

## Main file

Let's start with the main file: `cosco/plugin/cosco.vim`. This file is loaded in
the beginning and sets the following up:

- the variables
- the autocommands
- the commands, which the user can use

You can take a look into it, most of it should be self-explained. The most
important part in this file, is this one:

```vim
" ====================
" 2. Autocommands
" ====================
" refresh the autocommands if the user moves to another buffer
autocmd BufEnter * call cosco_autocmds#RefreshAutocmds()
```

Ok, so it calls `cosco_autocmds#RefreshAutocmds()` everytime, when we're
entering a buffer. But where is this function?

That's the part were we are moving on to the autoload files.

## Autoload files

Little Reminder: The autoload directory consists of these files:

```
autoload
├── cosco_autocmds.vim
├── cosco_eval.vim
├── cosco_helpers.vim
├── cosco_setter.vim
└── cosco.vim
```

Here the usages of the files:

### cosco_autocmds.vim

The `cosco_autocmds#RefreshAutocmds()` is inside there. This enables for all
events, declared in the `g:cosco_auto_comma_or_semicolon_events` list, the
auto-semicolon-and-comma setter.

### cosco_eval.vim

This file is called "cosco_eval" because it "evaluates" the current "situation".
There are the conditions or "control" statements where `cosco` decides,
if a semicolon/comma/double points should be added/removed or not even placed.
In general, they mostly inform themselfs about the current situation by looking
one line over the current cursor (after hitting the return key).

Why does it look over the line where the cursor is?
Here are the reasons:

1. We can write code like a normal text, if we want to move to the next line,
   than we just need to press the return key.
2. `cosco` can be sure, that the line over the cursor is mostly finished and
   its state won't change, so it can decide better, what to do.

Here are the functions in this file:

- `cosco_eval#ShouldNotSkip()`

  This function looks, if it can skip the previous
  line (the line over the cursor) for example, because there's already a
  semicolon or a comma.

- `cosco_eval#ShouldAdd()`

  This goes through some conditions to look, if it
  should place a semicolon/comma or a double point to the previous line.

- `cosco_eval#ShouldRemove()`

  It looks if it should remove a semicolon/comma or double point in the
  previous line.

- `cosco_eval#Specials()`

  Here should be all conditions, which are specifique for a filetype. For
  example in C, you can create some macros. Javascript doesn't have macros, so
  we just need to look in a C file, if the line starts with a `#`. This is
  handled there.

- `cosco_setter#Manual()`
  A function which can be called by a command/mapping which decides in the
  current line what to do. It was the previous main function `cosco` which
  wasn't really ready for autosetting the commas, semicolons and double
  points. But it works very well for manual callings!

Ok fine, we know which functions cosco uses, but how do they work together?
In order to understand it, we'll have to take a look into the main part of the
`cosco#CommaOrSemiColon()` function:

```vim
" =============================
" Evaluating the situation
" =============================
let b:cosco_ret_value = cosco_eval#Specials()

" if the special cases couldn't find anything
" => Go through the general conditions
if b:cosco_ret_value == -1

    if cosco_eval#ShouldNotSkip()

        " b:cosco_ret_value has to be set from this function
        " since we don't now yet, what we have to add
        let b:cosco_ret_value = cosco_eval#ShouldAdd()

    elseif cosco_eval#ShouldRemove()
        call cosco_setter#RemoveCommaOrSemicolon(b:pln)
    endif
endif
```

So `cosco` looks first of all, if it can already decide what to do according to
the special conditions. If that case doesn't happen, it'll look if it can skip
the previous line, if it's false then we've to add a character (`,`/`;`/`:`) to
the end of the previous line. `b:cosco_ret_value` will have the information what
to add. But if we could skip the previous line, it'll look first, if it has to
remove a wrong setted semicolon/comma or double point. If you want to know such
a case, where a semicolon is removed, take a look into the
`cosco_setter#RemoveCommaOrSemicolon()` function. There's an example explained.
The reason why we have five functions is, that it's easier to group the
conditions in these functions than using only one function and put everything in
there.

<!--

TODO: Don't know if this should be explained in detail or not.

Probably you're wondering now, why we just don't use one function which consists
of all conditions? Well the problem is, that some conditions depends on each
other for different cases and this would lead to a very big function with many
conditions which let's the overview of the function suffer. For example one
common condition in the `ShouldNotSkip()` function is looking if there's already
a semicolon or a comma in the previous line. If there's one, skip the line. But
what happens in this case?
```c
int fun1();
{
    | <-- Cursor
}
```
`cosco` would've placed this semicolon after the `fun1()` if the programmer
would create a function like that! So we'd need to put a condition which tests,
if the next line starts with an open curly bracket. We'd put that probably over
the semicolon-comma-check condition. But if we write something like that then:
```c
    short var1;
    unsigned short rofl[] = {
```
-->

To sum it up, here's a situation and a live demo, how `cosco` sets the stuff
automatically.

```c
    unsigned short rofl|
                       ^
                    Cursor
```

![demonstration](./screenshots/unsigned_short_rofl_demo.gif)

You can go through each condition and look, how it's filtering the situation. It
might be hard to undertand at some points but I hope, that the comments explain
each condition well. Feel free to ask, if you don't understand something!

Please consider that these functions _don't_ set or remove anything (except the
`cosco_eval#Manual()` function)! They are just looking at the previous, next and
current line and return the given value back what to do. For more
information, take a look into the files.

## cosco_helpers.vim

This file has "only" some extra functions which are useful for the `cosco`
plugin. You can take a look into it what it has but they aren't that important.

## cosco_setter.vim

This file contains four functions, which manipulate the text inside vim. Each
of them takes one argument: The line number which has to be changed. In general
it's the line number of the over the cursor, since our cursor is mostly already
one line below.

So the four functions are:

- `cosco_setter#MakeSemicolon` => Add a semicolon (`;`)
- `cosco_setter#MakeComma` => Add a comma (`,`)
- `cosco_setter#MakeDoublePoints` => Add a pair of points (`:`)
- `cosco_setter#RemoveEndCharacter` => Remove a comma or the semicolon if
  there's one at the end of the line

## cosco.vim

This file contains the main-function of this plugin: `cosco#AdaptCode()`
This function does the following:

1. Load the _next_, _previous_ and the _current_ line.
2. Look, if the `cosco_eval#Specials()` function can provide a decision. If yes,
   move on to the 4. point. If not, go on to 3.
3. Look what you've to do with the previous line.
4. Now add a comma/semicolon/double point, remove it or skip the previous line.

For more information, take a look into the file.

# Help pages

Inside of the `doc/cosco.txt` there's the help page if you enter `:h cosco`.
Nothing more to say here I guess.

# Unittests

Please make sure that your changes passes the unittests when you're
contributing.

In order to run the unittests, you need to install
[this](https://github.com/h1mesuke/vim-unittest) plugin. After that you can
open the `test_cosco` file and run `:UnitTest` to run the tests.

# Debugging

You can set the `g:cosco_debugging` to 1:

```vim
let g:cosco_debugging = 1
```

which will print under your statusbar a little string like in the GIF above:

```
[Curly Bracket] Opened
```

This could help you while debugging stuff.

## Last words

Hopefully you've got a overall understanding of this plugin now! If you have
some questions, just open an issue and we'll try to help you!
