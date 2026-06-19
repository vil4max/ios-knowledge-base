/*:
# Enumerations
Enumerations – usually called just *enums* – are a way of defining groups of related values in a way that makes them easier to use.

For example, if you wanted to write some code to represent the success or failure of some work you were doing, you could represent that as strings:
*/
//#-editable-code Enter your code here
let result = "failure"
//#-end-editable-code
/*:
But what happens if someone accidentally uses different naming?
*/
//#-editable-code Enter your code here
let result2 = "failed"
let result3 = "fail"
//#-end-editable-code
/*:
All those three are different strings, so they mean different things.

With enums we can define a `Result` type that can be either `success` or `failure`, like this:
*/
//#-editable-code Enter your code here
enum Result {
    case success
    case failure
}
//#-end-editable-code
/*:
And now when we use it we must choose one of those two values:
*/
//#-editable-code Enter your code here
let result4 = Result.failure
//#-end-editable-code
/*:
This stops you from accidentally using different strings each time.*/
