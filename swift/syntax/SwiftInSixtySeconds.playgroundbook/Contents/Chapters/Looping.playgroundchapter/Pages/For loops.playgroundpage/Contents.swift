/*:
# For loops
Swift has a few ways of writing loops, but their underlying mechanism is the same: run some code repeatedly until a condition evaluates as false.

The most common loop in Swift is a `for` loop: it will loop over arrays and ranges, and each time the loop goes around it will pull out one item and assign to a constant.

For example, here’s a range of numbers:
*/
//#-editable-code Enter your code here
let count = 1...10
//#-end-editable-code
/*:
We can use a `for` loop to print each item like this:
*/
//#-editable-code Enter your code here
for number in count {
    print("Number is \(number)")
}
//#-end-editable-code
/*:
We can do the same with arrays:
*/
//#-editable-code Enter your code here
let albums = ["Red", "1989", "Reputation"]
    
for album in albums {
    print("\(album) is on Apple Music")
}
//#-end-editable-code
/*:
If you don’t use the constant that `for` loops give you, you should use an underscore instead so that Swift doesn’t create needless values:
*/
//#-editable-code Enter your code here
print("Players gonna ")
    
for _ in 1...5 {
    print("play")
}
//#-end-editable-code
