/*:
# Arrays
Arrays are collections of values that are stored as a single value. For example, John, Paul, George, and Ringo are names, but arrays let you group them in a single value called The Beatles.

In code, we write this:
*/
//#-editable-code Enter your code here
let john = "John Lennon"
let paul = "Paul McCartney"
let george = "George Harrison"
let ringo = "Ringo Starr"
    
let beatles = [john, paul, george, ringo]
//#-end-editable-code
/*:
That last line makes the array: it starts and ends with brackets, with each item in the array separated by a comma.

You can read values from an array by writing a number inside brackets. Array positions count from 0, so if you want to read “Paul McCartney” you would write this:
*/
//#-editable-code Enter your code here
beatles[1]
//#-end-editable-code
/*:
Be careful: Swift crashes if you read an item that doesn’t exist. For example, trying to read `beatles[9]` is a bad idea.

**Note:** If you’re using type annotations, arrays are written in brackets: `[String]`, `[Int]`, `[Double]`, and `[Bool]`.*/
