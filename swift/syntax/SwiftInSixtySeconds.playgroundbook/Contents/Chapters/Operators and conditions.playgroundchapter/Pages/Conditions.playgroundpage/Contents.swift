/*:
# Conditions
Now you know some operators you can write conditions using `if` statements. You give Swift a condition, and if that condition is true it will run code of your choosing.

To try this out, I want to use a Swift function called `print()`: you run it with some text, and it will be printed out.

We can use conditions to check for a winning Blackjack hand:
*/
//#-editable-code Enter your code here
let firstCard = 11
let secondCard = 10
    
if firstCard + secondCard == 21 {
    print("Blackjack!")
}
//#-end-editable-code
/*:
The code inside the braces – `{` and `}` – will be printed if the condition is true. If you want you can provide alternative code to run if the condition is *false*, using `else`:
*/
//#-editable-code Enter your code here
if firstCard + secondCard == 21 {
    print("Blackjack!")
} else {
    print("Regular cards")
}
//#-end-editable-code
/*:
You can also chain conditions together using `else if`:
*/
//#-editable-code Enter your code here
if firstCard + secondCard == 2 {
    print("Aces – lucky!")
} else if firstCard + secondCard == 21 {
    print("Blackjack!")
} else {
    print("Regular cards")
}
//#-end-editable-code
