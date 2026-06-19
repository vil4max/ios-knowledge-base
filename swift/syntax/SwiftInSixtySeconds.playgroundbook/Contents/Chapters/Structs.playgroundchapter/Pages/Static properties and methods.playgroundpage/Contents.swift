/*:
# Static properties and methods
All the properties and methods we’ve created so far have belonged to individual instances of structs, which means that if we had a `Student` struct we could create several student instances each with their own properties and methods:
*/
//#-editable-code Enter your code here
struct Student {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
    
let ed = Student(name: "Ed")
let taylor = Student(name: "Taylor")
//#-end-editable-code
/*:
You can also ask Swift to share specific properties and methods across all instances of the struct by declaring them as *static*.

To try this out, we’re going to add a static property to the `Student` struct to store how many students are in the class. Each time we create a new student, we’ll add one to it:
*/
//#-editable-code Enter your code here
struct Student {
    static var classSize = 0
    var name: String
    
    init(name: String) {
        self.name = name
        Student.classSize += 1
    }
}
//#-end-editable-code
/*:
Because the `classSize` struct belongs to the struct itself rather than instances of the struct, we need to read it using `Student.classSize`:
*/
//#-editable-code Enter your code here
print(Student.classSize)
//#-end-editable-code
