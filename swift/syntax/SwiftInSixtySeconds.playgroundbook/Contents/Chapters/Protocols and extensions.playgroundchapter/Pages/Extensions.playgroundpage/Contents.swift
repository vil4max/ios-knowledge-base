/*:
# Extensions
Extensions allow you to add methods to existing types, to make them do things they weren’t originally designed to do. 

For example, we could add an extension to the `Int` type so that it has a `squared()` method that returns the current number multiplied by itself:
*/
//#-editable-code Enter your code here
extension Int {
    func squared() -> Int {
        return self * self
    }
}
//#-end-editable-code
/*:
To try that out, just create an integer and you’ll see it now has a `squared()` method:
*/
//#-editable-code Enter your code here
let number = 8
number.squared()
//#-end-editable-code
/*:
Swift doesn’t let you add stored properties in extensions, so you must use computed properties instead. For example, we could add a new `isEven` computed property to integers that returns true if it holds an even number:
*/
//#-editable-code Enter your code here
extension Int {
    var isEven: Bool {
        return self % 2 == 0
    }
}
//#-end-editable-code
