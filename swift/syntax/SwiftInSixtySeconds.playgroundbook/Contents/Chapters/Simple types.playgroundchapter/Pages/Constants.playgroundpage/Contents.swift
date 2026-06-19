/*:
# Constants
I already said that variables have that name because their values can change over time, and that is often useful. However, very often you want to set a value once and never change it, and so we have an alternative to the `var` keyword called `let`.

The `let` keyword creates *constants*, which are values that can be set once and never again. For example:
*/
//#-editable-code Enter your code here
let taylor = "swift"
//#-end-editable-code
/*:
If you try to change that, Xcode will refuse to run your code. It’s a form of safety: when you use constants you can no longer change something by accident.

When you write your own Swift code, you should always use `let` unless you specifically want to change a value. In fact, Xcode will warn you if you use `var` then *don’t* change the variable.*/
