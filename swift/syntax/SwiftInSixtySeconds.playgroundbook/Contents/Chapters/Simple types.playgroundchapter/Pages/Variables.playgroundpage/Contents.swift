/*:
# Variables
When you launch Xcode it will ask you what you want to do, and I’d like you to choose “Get Started with a Playground” – this is a sandbox where you can type Swift code and see immediate results.

The default is a blank playground for iOS, which is fine, so click Next then Create to save it on your desktop.

In this video I want to introduce you to variables, which are places where you can store program data. They are called variables because they can *vary* – you can change their values freely.

Playgrounds start with a line of code that creates a variable for us:
*/
//#-editable-code Enter your code here
var str = "Hello, playground"
//#-end-editable-code
/*:
That creates a new variable called `str`, giving it the value “Hello, playground”. On the right of the playground you can see “Hello, playground” in the output area – that’s Xcode showing us the value was set.

Because `str` is a variable we can change it:
*/
//#-editable-code Enter your code here
str = "Goodbye"
//#-end-editable-code
/*:
We don’t need `var` the second time because the variable has already been created – we’re just changing it.*/
