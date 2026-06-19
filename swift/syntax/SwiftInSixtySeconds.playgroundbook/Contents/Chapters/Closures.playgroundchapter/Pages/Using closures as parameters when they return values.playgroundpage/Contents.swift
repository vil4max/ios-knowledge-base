/*:
# Using closures as parameters when they return values
We’ve been using `() -> Void` to mean “accepts no parameters and returns nothing”, but you can replace that `Void` with any type of data to force the closure to return a value.

To demonstrate this, we can write a `travel()` function that accepts a closure as its only parameter, and that closure in turn accepts a string and returns a string:
*/
//#-editable-code Enter your code here
func travel(action: (String) -> String) {
    print("I'm getting ready to go.")
    let description = action("London")
    print(description)
    print("I arrived!")
}
//#-end-editable-code
/*:
Now when we call `travel()` using trailing closure syntax, our closure code is required to accept a string and return a string:
*/
//#-editable-code Enter your code here
travel { (place: String) -> String in
    return "I'm going to \(place) in my car"
}
//#-end-editable-code
