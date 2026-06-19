/*:
# Dictionaries
Dictionaries are collections of values just like arrays, but rather than storing things with an integer position you can access them using anything you want.

The most common way of storing dictionary data is using strings. For example, we could create a dictionary that stores the height of singers using their name:
*/
//#-editable-code Enter your code here
let heights = [
    "Taylor Swift": 1.78,
    "Ed Sheeran": 1.73
]
//#-end-editable-code
/*:
Just like arrays, dictionaries start and end with brackets and each item is separated with a comma. However, we also use a colon to separate the value you want to store (e.g. 1.78) from the identifier you want to store it under (e.g. “Taylor Swift”).

These identifiers are called *keys*, and you can use them to read data back out of the dictionary:
*/
//#-editable-code Enter your code here
heights["Taylor Swift"]
//#-end-editable-code
/*:
**Note:** When using type annotations, dictionaries are written in brackets with a colon between your identifier and value types. For example, `[String: Double]` and `[String: String]`.*/
