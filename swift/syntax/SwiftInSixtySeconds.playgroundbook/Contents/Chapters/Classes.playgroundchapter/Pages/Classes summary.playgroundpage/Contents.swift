/*:
# Classes summary
You’ve made it to the end of the eighth part of this series, so let’s summarize:

1. Classes and structs are similar, in that they can both let you create your own types with properties and methods.
2. One class can inherit from another, and it gains all the properties and methods of the parent class. It’s common to talk about class hierarchies – one class based on another, which itself is based on another.
3. You can mark a class with the `final` keyword, which stops other classes from inheriting from it.
4. Method overriding lets a child class replace a method in its parent class with a new implementation.
5. When two variables point at the same class instance, they both point at the same piece of memory – changing one changes the other.
6. Classes can have a deinitializer, which is code that gets run when an instance of the class is destroyed.
7. Classes don’t enforce constants as strongly as structs – if a property is declared as a variable, it can be changed regardless of how the class instance was created.*/
