/*:
# Protocol extensions
Protocols let you describe what methods something should have, but don’t provide the code inside. Extensions let you provide the code inside your methods, but only affect one data type – you can’t add the method to lots of types at the same time.

Protocol extensions solve both those problems: they are like regular extensions, except rather than extending a specific type like `Int` you extend a whole protocol so that all conforming types get your changes.

For example, here is an array and a set containing some names:
*/
//#-editable-code Enter your code here
let pythons = ["Eric", "Graham", "John", "Michael", "Terry", "Terry"]
let beatles = Set(["John", "Paul", "George", "Ringo"])
//#-end-editable-code
/*:
Swift’s arrays and sets both conform to a protocol called `Collection`, so we can write an extension to that protocol to add a `summarize()` method to print the collection neatly
*/
//#-editable-code Enter your code here
extension Collection {
    func summarize() {
        print("There are \(count) of us:")
    
        for name in self {
            print(name)
        }
    }
}
//#-end-editable-code
/*:
Both `Array` and `Set` will now have that method, so we can try it out:
*/
//#-editable-code Enter your code here
pythons.summarize()
beatles.summarize()
//#-end-editable-code
