/*:
# Type annotations
Swift assigns each variable and constant a type based on what value it’s given when it’s created. So, when you write code like this Swift can see it holds a string:
*/
//#-editable-code Enter your code here
let str = "Hello, playground"
//#-end-editable-code
/*:
That will make `str` a string, so you can’t try to assign it an integer or a boolean later on. This is called *type inference*: Swift is able to infer the type of something based on how you created it.

If you want you can be explicit about the type of your data rather than relying on Swift’s type inference, like this:
*/
//#-editable-code Enter your code here
let album: String = "Reputation"
let year: Int = 1989
let height: Double = 1.78
let taylorRocks: Bool = true
//#-end-editable-code
/*:
Notice that booleans have the short type name `Bool`, in the same way that integers have the short type name `Int`.*/
