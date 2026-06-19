/*:
# Lazy properties
As a performance optimization, Swift lets you create some properties only when they are needed. As an example, consider this `FamilyTree` struct – it doesn’t do much, but in theory creating a family tree for someone takes a long time:
*/
//#-editable-code Enter your code here
struct FamilyTree {
    init() {
        print("Creating family tree!")
    }
}
//#-end-editable-code
/*:
We might use that `FamilyTree` struct as a property inside a `Person` struct, like this:
*/
//#-editable-code Enter your code here
struct Person {
    var name: String
    var familyTree = FamilyTree()
    
    init(name: String) {
        self.name = name
    }
}
    
var ed = Person(name: "Ed")
//#-end-editable-code
/*:
But what if we didn’t always need the family tree for a particular person? If we add the `lazy` keyword to the `familyTree` property, then Swift will only create the `FamilyTree` struct when it’s first accessed:
*/
//#-editable-code Enter your code here
lazy var familyTree = FamilyTree()
//#-end-editable-code
/*:
So, if you want to see the “Creating family tree!” message, you need to access the property at least once:
*/
//#-editable-code Enter your code here
ed.familyTree
//#-end-editable-code
