define([
    'src/my/module1',
    'src/my/module2',
    'src/my/module3'
], function(
    Module1,
    Module2,
    Module3
){

    var testOne,
        testTwo,
        testThree = 3;

    return {
        method: function () {
            this.testFour = 1;
            this.testFive = 2
            testSix = 2;
            anotherMethod(function() { /*just wrote here*/ })
        },

        testSeven: 'foo',

        testEight: {
            foo: 'bar',
            bar: 'foo'
            foo: 'bar',
        },

        testNine: [
            1,
            2
            3
        ],

        testTen: null,
    }

    // Commented line
    // (shouldn't be changed if g:cosco_ignore_comment_lines is set to 1)
});
