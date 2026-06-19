/*:
# Protocol-oriented programming
Protocol extensions can provide default implementations for our own protocol methods. This makes it easy for types to conform to a protocol, and allows a technique called “protocol-oriented programming” – crafting your code around protocols and protocol extensions.

First, here’s a protocol called `Identifiable` that requires any conforming type to have an `id` property and an `identify()` method:
*/
//#-editable-code Enter your code here
protocol Identifiable {
    var id: String { get set }
    func identify()
}
//#-end-editable-code
/*:
We *could* make every conforming type write their own `identify()` method, but protocol extensions allow us to provide a default:
*/
//#-editable-code Enter your code here
extension Identifiable {
    func identify() {
        print("My ID is \(id).")
    }
}
//#-end-editable-code
/*:
Now when we create a type that conforms to `Identifiable` it gets `identify()` automatically:
*/
//#-editable-code Enter your code here
struct User: Identifiable {
    var id: String
}
    
let twostraws = User(id: "twostraws")
twostraws.identify()
//#-end-editable-code
