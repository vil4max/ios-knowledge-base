/*:
# Writing throwing functions
Sometimes functions fail because they have bad input, or because something went wrong internally. Swift lets us throw errors from functions by marking them as `throws` before their return type, then using the `throw` keyword when something goes wrong.

First we need to define an `enum` that describes the errors we can throw. These must always be based on Swift’s existing `Error` type. We’re going to write a function that checks whether a password is good, so we’ll throw an error if the user tries an obvious password:
*/
//#-editable-code Enter your code here
enum PasswordError: Error {
    case obvious
}
//#-end-editable-code
/*:
Now we’ll write a `checkPassword()` function that will throw that error if something goes wrong. This means using the `throws` keyword before the function’s return value, then using `throw PasswordError.obvious` if their password is “password”.

Here’s that in Swift:
*/
//#-editable-code Enter your code here
func checkPassword(_ password: String) throws -> Bool {
    if password == "password" {
        throw PasswordError.obvious
    }
    
    return true
}
//#-end-editable-code
