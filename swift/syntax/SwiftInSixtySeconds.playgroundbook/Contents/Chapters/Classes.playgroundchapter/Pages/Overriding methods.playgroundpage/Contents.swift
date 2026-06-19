/*:
# Overriding methods
Child classes can replace parent methods with their own implementations – a process known as *overriding*. Here’s a trivial `Dog` class with a `makeNoise()` method:
*/
//#-editable-code Enter your code here
class Dog {
    func makeNoise() {
        print("Woof!")
    }
}
//#-end-editable-code
/*:
If we create a new `Poodle` class that inherits from `Dog`, it will inherit the `makeNoise()` method. So, this will print “Woof!”:
*/
//#-editable-code Enter your code here
class Poodle: Dog {
}

let poppy = Poodle()
poppy.makeNoise()
//#-end-editable-code
/*:
Method overriding allows us to change the implementation of `makeNoise()` for the `Poodle` class.

Swift requires us to use `override func` rather than just `func` when overriding a method – it stops you from overriding a method by accident, and you’ll get an error if you try to override something that doesn’t exist on the parent class:
*/
//#-editable-code Enter your code here
class Poodle: Dog {
    override func makeNoise() {
        print("Yip!")
    }
}
//#-end-editable-code
/*:
With that change, `poppy.makeNoise()` will print “Yip!” rather than “Woof!”.*/
