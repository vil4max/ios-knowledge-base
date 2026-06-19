/*:
# Template Method: Conceptual Example

**Template Method** is a behavioral design pattern that allows you to defines a skeleton of an algorithm in a base class and let subclasses override the steps without changing the overall algorithm’s structure.

[Learn more about Template Method →](https://refactoring.guru/design-patterns/template-method)

* **Complexity:** ★☆☆
* **Popularity:** ★★☆
* **Usage examples:** The Template Method pattern is quite common in Swift frameworks. Developers often use it to provide framework users with a simple means of extending standard functionality using inheritance.
* **Identification:** Template Method can be recognized if you see a method in base class that calls a bunch of other methods that are either abstract or empty.

- Example: This example illustrates the structure of the **Template Method** design pattern and focuses on the following questions:
   * What classes does it consist of?
   * What roles do these classes play?
   * In what way the elements of the pattern are related?

After learning about the pattern’s structure it’ll be easier for you to grasp [the following example](@next), based on a real-world Swift use case.
 */
/// The Abstract Protocol and its extension defines a template method that
/// contains a skeleton of some algorithm, composed of calls to (usually)
/// abstract primitive operations.
///
/// Concrete subclasses should implement these operations, but leave the
/// template method itself intact.
protocol AbstractProtocol {
    /// The template method defines the skeleton of an algorithm.
    func templateMethod()

    /// These operations already have implementations.
    func baseOperation1()

    func baseOperation2()

    func baseOperation3()

    /// These operations have to be implemented in subclasses.
    func requiredOperations1()
    func requiredOperation2()

    /// These are "hooks." Subclasses may override them, but it's not mandatory
    /// since the hooks already have default (but empty) implementation. Hooks
    /// provide additional extension points in some crucial places of the
    /// algorithm.
    func hook1()
    func hook2()
}

extension AbstractProtocol {
    func templateMethod() {
        baseOperation1()
        requiredOperations1()
        baseOperation2()
        hook1()
        requiredOperation2()
        baseOperation3()
        hook2()
    }

    /// These operations already have implementations.
    func baseOperation1() {
        print("AbstractProtocol says: I am doing the bulk of the work\n")
    }

    func baseOperation2() {
        print("AbstractProtocol says: But I let subclasses override some operations\n")
    }

    func baseOperation3() {
        print("AbstractProtocol says: But I am doing the bulk of the work anyway\n")
    }

    func hook1() {}
    func hook2() {}
}

/// Concrete classes have to implement all abstract operations of the base
/// class. They can also override some operations with a default implementation.
class ConcreteClass1: AbstractProtocol {
    func requiredOperations1() {
        print("ConcreteClass1 says: Implemented Operation1\n")
    }

    func requiredOperation2() {
        print("ConcreteClass1 says: Implemented Operation2\n")
    }

    func hook2() {
        print("ConcreteClass1 says: Overridden Hook2\n")
    }
}

/// Usually, concrete classes override only a fraction of base class'
/// operations.
class ConcreteClass2: AbstractProtocol {
    func requiredOperations1() {
        print("ConcreteClass2 says: Implemented Operation1\n")
    }

    func requiredOperation2() {
        print("ConcreteClass2 says: Implemented Operation2\n")
    }

    func hook1() {
        print("ConcreteClass2 says: Overridden Hook1\n")
    }
}

/// The client code calls the template method to execute the algorithm. Client
/// code does not have to know the concrete class of an object it works with, as
/// long as it works with objects through the interface of their base class.
class Client {
    // ...
    static func clientCode(use object: AbstractProtocol) {
        // ...
        object.templateMethod()
        // ...
    }
    // ...
}

/// Let's see how it all works together.
class TemplateMethodConceptual_TestCase {
    func testTemplateMethodConceptual() {
        print("Same client code can work with different subclasses:\n")
        Client.clientCode(use: ConcreteClass1())

        print("\nSame client code can work with different subclasses:\n")
        Client.clientCode(use: ConcreteClass2())
    }
}

let testCase = TemplateMethodConceptual_TestCase()
testCase.testTemplateMethodConceptual()
