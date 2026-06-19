/*:
# Operator overloading
Swift supports operator overloading, which is a fancy way of saying that what an operator does depends on the values you use it with. For example, `+` sums integers like this:
*/
//#-editable-code Enter your code here
let meaningOfLife = 42
let doubleMeaning = 42 + 42
//#-end-editable-code
/*:
But `+` also joins strings, like this:
*/
//#-editable-code Enter your code here
let fakers = "Fakers gonna "
let action = fakers + "fake"
//#-end-editable-code
/*:
You can even use `+` to join arrays, like this:
*/
//#-editable-code Enter your code here
let firstHalf = ["John", "Paul"]
let secondHalf = ["George", "Ringo"]
let beatles = firstHalf + secondHalf
//#-end-editable-code
/*:
Remember, Swift is a type-safe language, which means it won’t let you mix types. For example, you can’t add an integer to a string because it doesn’t make any sense.*/
