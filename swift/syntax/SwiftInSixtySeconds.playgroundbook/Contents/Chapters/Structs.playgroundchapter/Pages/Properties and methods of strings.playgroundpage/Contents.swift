/*:
# Properties and methods of strings
We’ve used lots of strings so far, and it turns out they are structs – they have their own methods and properties we can use to query and manipulate the string.

First, let’s create a test string:
*/
//#-editable-code Enter your code here
let string = "Do or do not, there is no try."
//#-end-editable-code
/*:
You can read the number of characters in a string using its `count` property:
*/
//#-editable-code Enter your code here
print(string.count)
//#-end-editable-code
/*:
They have a `hasPrefix()` method that returns true if the string starts with specific letters:
*/
//#-editable-code Enter your code here
print(string.hasPrefix("Do"))
//#-end-editable-code
/*:
You can uppercase a string by calling its `uppercased()` method:
*/
//#-editable-code Enter your code here
print(string.uppercased())
//#-end-editable-code
/*:
And you can even have Swift sort the letters of the string into an array:
*/
//#-editable-code Enter your code here
print(string.sorted())
//#-end-editable-code
/*:
Strings have lots more properties and methods – try typing `string.` to bring up Xcode’s code completion options.*/
