/*:
# Repeat loops
The third way of writing loops is not commonly used, but it’s so simple to learn we might as well cover it: it’s called the `repeat` loop, and it’s identical to a `while` loop except the condition to check comes at the end.

So, we could rewrite our hide and seek example like this:
*/
//#-editable-code Enter your code here
var number = 1
    
repeat {
    print(number)
    number += 1
} while number <= 20
    
print("Ready or not, here I come!")
//#-end-editable-code
/*:
Because the condition comes at the *end* of the `repeat` loop the code inside the loop will always be executed at least once, whereas `while` loops check their condition before their first run.

For example, this `print()` function will never be run, because `false` is always false:
*/
//#-editable-code Enter your code here
while false {
    print("This is false")
}
//#-end-editable-code
/*:
Xcode will even warn us that the `print()` line will never be executed.

On the other hand, this `print()` function will be run once, because `repeat` only fails the condition after the loop runs:
*/
//#-editable-code Enter your code here
repeat {
    print("This is false")
} while false
//#-end-editable-code
