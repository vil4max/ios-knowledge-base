/*:
# Returning values from a closure
Closures can also return values, and they are written similarly to parameters: you write them inside your closure, directly before the `in` keyword.

To demonstrate this, we’re going to take our `driving()` closure and make it return its value rather than print it directly. Here’s the original:
*/
//#-editable-code Enter your code here
let driving = { (place: String) in
    print("I'm going to \(place) in my car")
}
//#-end-editable-code
/*:
We want a closure that returns a string rather than printing the message directly, so we need to use `-> String` before `in`, then use `return` just like a normal function:
*/
//#-editable-code Enter your code here
let drivingWithReturn = { (place: String) -> String in
    return "I'm going to \(place) in my car"
}
//#-end-editable-code
/*:
We can now run that closure and print its return value:
*/
//#-editable-code Enter your code here
let message = drivingWithReturn("London")
print(message)
//#-end-editable-code
