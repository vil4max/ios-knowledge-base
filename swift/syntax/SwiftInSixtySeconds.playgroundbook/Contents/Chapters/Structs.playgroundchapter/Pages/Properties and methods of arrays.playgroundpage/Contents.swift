/*:
# Properties and methods of arrays
Arrays are also structs, which means they too have their own methods and properties we can use to query and manipulate the array.

Here’s a simple array to get us started:
*/
//#-editable-code Enter your code here
var toys = ["Woody"]
//#-end-editable-code
/*:
You can read the number of items in an array using its `count` property:
*/
//#-editable-code Enter your code here
print(toys.count)
//#-end-editable-code
/*:
If you want to add a new item, use the `append()` method like this:
*/
//#-editable-code Enter your code here
toys.append("Buzz")
//#-end-editable-code
/*:
You can locate any item inside an array using its `index()` method, like this:
*/
//#-editable-code Enter your code here
toys.index(of: "Buzz")
//#-end-editable-code
/*:
That will return 1 because arrays count from 0.

Just like with strings, you can have Swift sort the items of the array alphabetically:
*/
//#-editable-code Enter your code here
print(toys.sorted())
//#-end-editable-code
/*:
Finally, if you want to remove an item, use the `remove()` method like this:
*/
//#-editable-code Enter your code here
toys.remove(at: 0)
//#-end-editable-code
/*:
Arrays have lots more properties and methods – try typing `toys.` to bring up Xcode’s code completion options.*/
