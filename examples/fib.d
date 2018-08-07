import std.stdio;

int fib(int n) @safe pure nothrow {
    if (n == 0) {
        return 0;
    }
    if (n == 1) {
        return 1;
    }
    return fib(n - 1) + fib(n - 2);
}

void main() {
    foreach (elem; 0 .. 15) {
        writeln(fib(elem));
    }
    auto someRandomVar = 10;
    auto ignoreThisVariable
    /* the line above has a syntax error, because the line was ignored by this setting:
    let g:cosco_ignore_ft_pattern = {
          \ 'd': '^.*ignoreThisVariable',
    }
    */
}
