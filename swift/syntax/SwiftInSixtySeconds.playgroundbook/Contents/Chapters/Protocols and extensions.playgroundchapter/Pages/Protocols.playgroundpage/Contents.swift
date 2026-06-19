/*:
# Protocols
Protocols are a way of describing what properties and methods something must have. You then tell Swift which types use that protocol – a process known as adopting or conforming to a protocol.

For example, we can write a function that accepts something with an `id` property, but we don’t care precisely what type of data is used. We’ll start by creating an `Identifiable` protocol, which will require all conforming types to have an `id` string that can be read (“get”) or written (“set”):
*/
//#-editable-code Enter your code here
protocol Identifiable {
    var id: String { get set }
}
//#-end-editable-code
/*:
We can’t *create* instances of that protocol - it’s a description, not a type by itself. But we *can* create a struct that conforms to it:
*/
//#-editable-code Enter your code here
struct User: Identifiable {
    var id: String
}
//#-end-editable-code
/*:
Finally, we’ll write a `displayID()` function that accepts any `Identifiable` object:
*/
//#-editable-code Enter your code here
func displayID(thing: Identifiable) {
    print("My ID is \(thing.id)")
}
//#-end-editable-code
