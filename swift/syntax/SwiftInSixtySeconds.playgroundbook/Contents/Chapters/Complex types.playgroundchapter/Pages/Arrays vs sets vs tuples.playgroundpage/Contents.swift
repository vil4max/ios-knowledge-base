/*:
# Arrays vs sets vs tuples
Arrays, sets, and tuples can seem similar at first, but they have distinct uses. To help you know which to use, here are some rules.

If you need a specific, fixed collection of related values where each item has a precise position or name, you should use a tuple:
*/
//#-editable-code Enter your code here
let address = (house: 555, street: "Taylor Swift Avenue", city: "Nashville")
//#-end-editable-code
/*:
If you need a collection of values that must be unique or you need to be able to check whether a specific item is in there extremely quickly, you should use a set:
*/
//#-editable-code Enter your code here
let set = Set(["aardvark", "astronaut", "azalea"])
//#-end-editable-code
/*:
If you need a collection of values that can contain duplicates, or the order of your items matters, you should use an array:
*/
//#-editable-code Enter your code here
let pythons = ["Eric", "Graham", "John", "Michael", "Terry", "Terry"]
//#-end-editable-code
/*:
Arrays are by far the most common of the three types.*/
