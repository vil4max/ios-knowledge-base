/*:
# String interpolation
You’ve seen how you can type values for strings directly into your code, but Swift also has a feature called string interpolation – the ability to place variables inside your strings to make them more useful.

You can place any type of variable inside your string – all you have to do is write a backslash, `\`, followed by your variable name in parentheses. For example:
*/
//#-editable-code Enter your code here
var score = 85
var str = "Your score was \(score)"
//#-end-editable-code
/*:
As you can see in the playground output, that sets the `str` variable to be “Your score was 85”.

You can do this as many times as you need, making strings out of strings if you want:
*/
//#-editable-code Enter your code here
var results = "The test results are here: \(str)"
//#-end-editable-code
/*:
As you’ll see later on, string interpolation isn’t just limited to placing variables – you can actually run code inside there.*/
