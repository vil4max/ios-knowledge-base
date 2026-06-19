/*:
# The ternary operator
Swift has a rarely used operator called the ternary operator. It works with three values at once, which is where its name comes from: it checks a condition specified in the first value, and if it’s true returns the second value, but if its false returns the third value.

The ternary operator is a condition plus true or false blocks all in one, split up by a question mark and a colon, all of which which makes it rather hard to read. Here’s an example:
*/
//#-editable-code Enter your code here
let firstCard = 11
let secondCard = 10
print(firstCard == secondCard ? "Cards are the same" : "Cards are different")
//#-end-editable-code
/*:
That checks whether the two cards are the same, then prints “Cards are the same” if the condition is true, or “Cards are different” if it’s false. We could write the same code using a regular condition:
*/
//#-editable-code Enter your code here
if firstCard == secondCard {
    print("Cards are the same")
} else {
    print("Cards are different")
}
//#-end-editable-code
