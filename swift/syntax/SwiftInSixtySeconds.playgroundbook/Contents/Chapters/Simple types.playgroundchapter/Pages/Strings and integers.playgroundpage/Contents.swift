/*:
# Strings and integers
Swift is what’s known as a type-safe language, which means that every variable must be of one specific type. The `str` variable that Xcode created for us holds a string of letters that spell “Hello, playground”, so Swift assigns it the type `String`.

On the other hand, if we want to store someone’s age we might make a variable like this:
*/
//#-editable-code Enter your code here
var age = 38
//#-end-editable-code
/*:
That holds a whole number, so Swift assigns the type `Int` – short for “integer”.

If you have large numbers, Swift lets you use underscores as thousands separators – they don’t change the number, but they do make it easier to read. For example:
*/
//#-editable-code Enter your code here
var population = 8_000_000
//#-end-editable-code
/*:
Strings and integers are different types, and they can’t be mixed. So, while it’s safe to change `str` to “Goodbye”, I can’t make it 38 because that’s an `Int` not a `String`.*/
