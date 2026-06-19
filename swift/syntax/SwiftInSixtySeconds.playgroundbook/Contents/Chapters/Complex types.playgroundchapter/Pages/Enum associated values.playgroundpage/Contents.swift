/*:
# Enum associated values
As well as storing a simple value, enums can also store *associated* values attached to each case. This lets you attach additional information to your enums so they can represent more nuanced data.

For example, we might define an enum that stores various kinds of activities:
*/
//#-editable-code Enter your code here
enum Activity {
    case bored
    case running
    case talking
    case singing
}
//#-end-editable-code
/*:
That let’s us say that someone is talking, but we don’t know what they talking *about*, or we can know that someone is running, but we don’t know where they are running *to*.

Enum associated values let us add those additional details:
*/
//#-editable-code Enter your code here
enum Activity {
    case bored
    case running(destination: String)
    case talking(topic: String)
    case singing(volume: Int)
}
//#-end-editable-code
/*:
Now we can be more precise – we can say that someone is talking about football:
*/
//#-editable-code Enter your code here
let talking = Activity.talking(topic: "football")
//#-end-editable-code
