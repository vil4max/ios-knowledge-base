/*:
# Tuples
Tuples allow you store several values together in a single value. That might sound like arrays, but tuples are different:

1. You can’t add or remove items from a tuple; they are fixed in size.
2. You can’t change the type of items in a tuple; they always have the same types they were created with.
3. You can access items in a tuple using numerical positions or by naming them, but Swift won’t let you read numbers or names that don’t exist.

Tuples are created by placing multiple items into parentheses, like this:
*/
//#-editable-code Enter your code here
var name = (first: "Taylor", last: "Swift")
//#-end-editable-code
/*:
You then access items using numerical positions starting from 0:
*/
//#-editable-code Enter your code here
name.0
//#-end-editable-code
/*:
Or you can access items using their names:
*/
//#-editable-code Enter your code here
name.first
//#-end-editable-code
/*:
Remember, you can change the values inside a tuple after you create it, but not the *types* of values. So, if you tried to change `name` to be `(first: "Justin", age: 25)` you would get an error.*/
