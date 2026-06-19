/*:
# Copying objects
The third difference between classes and structs is how they are copied. When you copy a struct, both the original and the copy are different things – changing one won’t change the other. When you copy a *class*, both the original and the copy point to the *same* thing, so changing one *does* change the other.

For example, here’s a simple `Singer` class that has a `name` property with a default value:
*/
//#-editable-code Enter your code here
class Singer {
    var name = "Taylor Swift"
}
//#-end-editable-code
/*:
If we create an instance of that class and prints its name, we’ll get “Taylor Swift”:
*/
//#-editable-code Enter your code here
var singer = Singer()
print(singer.name)
//#-end-editable-code
/*:
Now let’s  create a second variable from the first one and change its name:
*/
//#-editable-code Enter your code here
var singerCopy = singer
singerCopy.name = "Justin Bieber"
//#-end-editable-code
/*:
Because of the way classes work, both `singer` and `singerCopy` point to the same object in memory, so when we print the singer name again we’ll see “Justin Bieber”:
*/
//#-editable-code Enter your code here
print(singer.name)
//#-end-editable-code
/*:
On the other hand, if `Singer` were a struct then we would get “Taylor Swift” printed a second time:
*/
//#-editable-code Enter your code here
struct Singer {
    var name = "Taylor Swift"
}
//#-end-editable-code
