/*:
# Omitting parameter labels
You might have noticed that we don’t actually send any parameter names when we call `print()` – we say `print("Hello")` rather than `print(message: "Hello")`.

You can get this same behavior in your own functions by using an underscore, `_`, for your external parameter name, like this:
*/
//#-editable-code Enter your code here
func greet(_ person: String) {
    print("Hello, \(person)!")
}
//#-end-editable-code
/*:
You can now call `greet()` without having to use the `person` parameter name:
*/
//#-editable-code Enter your code here
greet("Taylor")
//#-end-editable-code
/*:
This can make some code more natural to read, but generally it’s better to give your parameters external names to avoid confusion. For example, if I say `setAlarm(5)` it’s hard to tell what that means – does it set an alarm for five o’clock, set an alarm for five hours from now, or activate pre-configured alarm number 5?*/
