/*:
# Dictionary default values
If you try to read a value from a dictionary using a key that doesn’t exist, Swift will send you back `nil` – nothing at all. While this might be what you want, there’s an alternative: we can provide the dictionary with a default value to use if we request a missing key.

To demonstrate this, let’s create a dictionary of favorite ice creams for two people:
*/
//#-editable-code Enter your code here
let favoriteIceCream = [
    "Paul": "Chocolate",
    "Sophie": "Vanilla"
]
//#-end-editable-code
/*:
We can read Paul’s favorite ice cream like this:
*/
//#-editable-code Enter your code here
favoriteIceCream["Paul"]
//#-end-editable-code
/*:
But if we tried reading the favorite ice cream for Charlotte, we’d get back nil, meaning that Swift doesn’t have a value for that key:
*/
//#-editable-code Enter your code here
favoriteIceCream["Charlotte"]
//#-end-editable-code
/*:
We can fix this by giving the dictionary a default value of “Unknown”, so that when no ice cream is found for Charlotte we get back “Unknown” rather than nil:
*/
//#-editable-code Enter your code here
favoriteIceCream["Charlotte", default: "Unknown"]
//#-end-editable-code
