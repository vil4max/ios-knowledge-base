/*:
# Creating your own structs
Swift lets you design your own types in two ways, of which the most common are called structures, or just *structs*. Structs can be given their own variables and constants, and their own functions, then created and used however you want.

Let’s start with a simple example: we’re going to create a `Sport` struct that stores its name as a string. Variables inside structs are called *properties*, so this is a struct with one property:
*/
//#-editable-code Enter your code here
struct Sport {
    var name: String
}
//#-end-editable-code
/*:
That defines the type, so now we can create and use an instance of it:
*/
//#-editable-code Enter your code here
var tennis = Sport(name: "Tennis")
print(tennis.name)
//#-end-editable-code
/*:
We made both `name` and `tennis` variable, so we can change them just like regular variables:
*/
//#-editable-code Enter your code here
tennis.name = "Lawn tennis"
//#-end-editable-code
/*:
Properties can have default values just like regular variables, and you can usually rely on Swift’s type inference.*/
