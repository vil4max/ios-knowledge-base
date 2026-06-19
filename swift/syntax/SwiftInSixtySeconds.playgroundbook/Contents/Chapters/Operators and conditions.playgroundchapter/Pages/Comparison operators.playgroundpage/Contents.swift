/*:
# Comparison operators
Swift has several operators that perform comparison, and these work more or less like you would expect in mathematics.

Let’s start with a couple of example variables so we have something to work with:
*/
//#-editable-code Enter your code here
let firstScore = 6
let secondScore = 4
//#-end-editable-code
/*:
There are two operators that check for equality: `==` checks two values are the same, and `!=` (pronounced “not equals”) checks two values are *not* the same:
*/
//#-editable-code Enter your code here
firstScore == secondScore
firstScore != secondScore
//#-end-editable-code
/*:
There are four operators for comparing whether one value is greater than, less than, or equal to another. These are just like in mathematics:
*/
//#-editable-code Enter your code here
firstScore < secondScore
firstScore >= secondScore
//#-end-editable-code
/*:
Each of these also work with strings, because strings have a natural alphabetical order:
*/
//#-editable-code Enter your code here
"Taylor" <= "Swift"
//#-end-editable-code
