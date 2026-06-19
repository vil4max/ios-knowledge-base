/*:
# Writing functions
Functions let us re-use code, which means we can write a function to do something interesting then run that function from lots of places. Repeating code is generally a bad idea, and functions help us avoid doing that.

To start with, we’re going to write a function that prints help information for users of our app. We might need this anywhere in our app, so having it as a function is a good idea.

Swift functions start with the `func` keyword, then your function name, then open and close parentheses. All the body of your function – the code that should be run when the function is requested – is placed inside braces.

Let’s write the `printHelp()` function now:
*/
//#-editable-code Enter your code here
func printHelp() {
    let message = """
Welcome to MyApp!
    
Run this app inside a directory of images and
MyApp will resize them all into thumbnails
"""
    
    print(message)
}
//#-end-editable-code
/*:
We can now run that using `printHelp()` by itself:
*/
//#-editable-code Enter your code here
printHelp()
//#-end-editable-code
/*:
Running a function is often referred to as *calling* a function.*/
