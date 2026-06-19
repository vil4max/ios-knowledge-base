/*:
# Shorthand parameter names
We just made a `travel()` function. It accepts one parameter, which is a closure that itself accepts one parameter and returns a string. That closure is then run between two calls to `print()`.

Here’s that in code:
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
We can call `travel()` using something like this:
*/
//#-editable-code Enter your code here
travel { (place: String) -> String in
    return "I'm going to \(place) in my car"
}
//#-end-editable-code
/*:
However, Swift *knows* the parameter to that closure must be a string, so we can remove it:
*/
//#-editable-code Enter your code here
travel { place -> String in
    return "I'm going to \(place) in my car"
}
//#-end-editable-code
/*:
It also knows the closure must return a string, so we can remove that:
*/
//#-editable-code Enter your code here
travel { place in
    return "I'm going to \(place) in my car"
}
//#-end-editable-code
/*:
As the closure only has one line of code that must be the one that returns the value, so Swift lets us remove the `return` keyword too:
*/
//#-editable-code Enter your code here
travel { place in
    "I'm going to \(place) in my car"
}
//#-end-editable-code
/*:
Swift has a shorthand syntax that lets you go even shorter. Rather than writing `place in` we can let Swift provide automatic names for the closure’s parameters. These are named with a dollar sign, then a number counting from 0.
*/
//#-editable-code Enter your code here
travel {
    "I'm going to \($0) in my car"
}
//#-end-editable-code
