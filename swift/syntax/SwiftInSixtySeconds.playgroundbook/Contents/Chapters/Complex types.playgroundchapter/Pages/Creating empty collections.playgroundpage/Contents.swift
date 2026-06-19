/*:
# Creating empty collections
Arrays, sets, and dictionaries are called *collections*, because they collect values together in one place.

If you want to create an *empty* collection just write its type followed by opening and closing parentheses. For example, we can create an empty dictionary with strings for keys and values like this:
*/
//#-editable-code Enter your code here
var teams = [String: String]()
//#-end-editable-code
/*:
We can then add entries later on, like this:
*/
//#-editable-code Enter your code here
teams["Paul"] = "Red"
//#-end-editable-code
/*:
Similarly, you can create an empty array to store integers like this:
*/
//#-editable-code Enter your code here
var results = [Int]()
//#-end-editable-code
/*:
The  exception is creating an empty set, which is done differently:
*/
//#-editable-code Enter your code here
var words = Set<String>()
var numbers = Set<Int>()
//#-end-editable-code
/*:
This is because Swift has special syntax only for dictionaries and arrays; other types must use angle bracket syntax like sets.

If you wanted, you could create arrays and dictionaries with similar syntax:
*/
//#-editable-code Enter your code here
var scores = Dictionary<String, Int>()
var results = Array<Int>()
//#-end-editable-code
