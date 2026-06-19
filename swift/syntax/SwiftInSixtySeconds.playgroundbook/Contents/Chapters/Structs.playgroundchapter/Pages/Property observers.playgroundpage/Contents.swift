/*:
# Property observers
Property observers let you run code before or after any property changes. To demonstrate this, we’ll write a `Progress` struct that tracks a task and a completion percentage:
*/
//#-editable-code Enter your code here
struct Progress {
    var task: String
    var amount: Int
}
//#-end-editable-code
/*:
We can now create an instance of that struct and adjust its progress over time:
*/
//#-editable-code Enter your code here
var progress = Progress(task: "Loading data", amount: 0)
progress.amount = 30
progress.amount = 80
progress.amount = 100
//#-end-editable-code
/*:
What we *want* to happen is for Swift to print a message every time `amount` changes, and we can use a `didSet` property observer for that. This will run some code every time `amount` changes:
*/
//#-editable-code Enter your code here
struct Progress {
    var task: String
    var amount: Int {
        didSet {
            print("\(task) is now \(amount)% complete")
        }
    }
}
//#-end-editable-code
/*:
You can also use `willSet` to take action *before* a property changes, but that is rarely used.*/
