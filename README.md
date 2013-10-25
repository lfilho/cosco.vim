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

  TODO

## Modes

  TODO

## Mappings

  TODO

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
   * Use a test framework (avoid regression bugs!!)
   * Maybe create a `examples/` folder to make testing easier?
