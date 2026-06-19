/*:
# Accepting parameters
Functions become more powerful when they can be customized each time you run them. Swift lets you send values to a function that can then be used inside the function to change the way it behaves. We’ve used this already – we’ve been sending strings and integers to the `print()` function, like this:
*/
//#-editable-code Enter your code here
print("Hello, world!")
//#-end-editable-code
/*:
Values sent into functions this way are called *parameters*.

To make your own functions accept parameters, give each parameter a name, then a colon, then tell Swift the type of data it must be. All this goes inside the parentheses after your function name.

For example, we can write a function to print the square of any number:
*/
//#-editable-code Enter your code here
func square(number: Int) {
    print(number * number)
}
//#-end-editable-code
/*:
That tells Swift we expect to receive an `Int`, and it should be called `number`. This name is used both inside the function when you want to refer to the parameter, but also when you run the function, like this:
*/
//#-editable-code Enter your code here
square(number: 8)
//#-end-editable-code
