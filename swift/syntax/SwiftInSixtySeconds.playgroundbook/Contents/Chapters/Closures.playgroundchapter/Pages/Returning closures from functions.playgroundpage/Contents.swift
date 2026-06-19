/*:
# Returning closures from functions
In the same way that you can pass a closure *to* a function, you can get closures returned *from* a function too.

The syntax for this is a bit confusing a first, because it uses `->` twice: once to specify your function’s return value, and a second time to specify your closure’s return value.

To try this out, we’re going to write a `travel()` function that accepts no parameters, but returns a closure. The closure that gets returned must be called with a string, and will return nothing.

Here’s how that looks in Swift:
*/
//#-editable-code Enter your code here
func travel() -> (String) -> Void {
    return {
        print("I'm going to \($0)")
    }
}
//#-end-editable-code
/*:
We can now call `travel()` to get back that closure, then call it as a function:
*/
//#-editable-code Enter your code here
let result = travel()
result("London")
//#-end-editable-code
/*:
It’s technically allowable – although really not recommended! – to call the return value from `travel()` directly:
*/
//#-editable-code Enter your code here
let result2 = travel()("London")
//#-end-editable-code
