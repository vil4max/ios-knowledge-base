/*:
# Exiting multiple loops
If you put a loop inside a loop it’s called a *nested* loop, and it’s not uncommon to want to break out of both the inner loop and the outer loop at the same time.

As an example, we could write some code to calculate the times tables from 1 through 10 like this:
*/
//#-editable-code Enter your code here
for i in 1...10 {
    for j in 1...10 {
        let product = i * j
        print ("\(i) * \(j) is \(product)")
    }
}
//#-end-editable-code
/*:
If we wanted to exit part-way through we need to do two things. First, we give the outside loop a label, like this:
*/
//#-editable-code Enter your code here
outerLoop: for i in 1...10 {
    for j in 1...10 {
        let product = i * j
        print ("\(i) * \(j) is \(product)")
    }
}
//#-end-editable-code
/*:
Second, add our condition inside the inner loop, then use `break outerLoop` to exit both loops at the same time:
    
*/
//#-editable-code Enter your code here
outerLoop: for i in 1...10 {
    for j in 1...10 {
        let product = i * j
        print ("\(i) * \(j) is \(product)")
    
        if product == 50 {
            print("It's a bullseye!")
            break outerLoop
        }
    }
}
//#-end-editable-code
/*:
With a regular `break`, only the inner loop would be exited – the outer loop would continue where it left off.*/
