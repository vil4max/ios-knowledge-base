/*:
# Arithmetic operators
Now you know all the basic types in Swift, we can start to put them together using operators. Operators are those little mathematical symbols like `+` and `-`, and Swift has a huge range of them.

Here are a couple of test variables for us to work with:
*/
//#-editable-code Enter your code here
let firstScore = 12
let secondScore = 4
//#-end-editable-code
/*:
We can add and subtract using `+` and `-`:
*/
//#-editable-code Enter your code here
let total = firstScore + secondScore
let difference = firstScore - secondScore
//#-end-editable-code
/*:
And we can multiply and divide using `*` and `/`:
*/
//#-editable-code Enter your code here
let product = firstScore * secondScore
let divided = firstScore / secondScore
//#-end-editable-code
/*:
Swift has a special operator for calculating remainders after division: `%`. It calculates how many times one number can fit inside another, then sends back the value that’s left over.

For example, we set `secondScore` to 4, so if we say `13 % secondScore` we’ll get back one, because 4 fits into 13 three times with remainder one:
*/
//#-editable-code Enter your code here
let remainder = 13 % secondScore
//#-end-editable-code
