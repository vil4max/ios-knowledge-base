/*:
# Visitor: Conceptual Example

**Visitor** is a behavioral design pattern that allows adding new behaviors to existing class hierarchy without altering any existing code.

[Learn more about Visitor →](https://refactoring.guru/design-patterns/visitor)

* **Complexity:** ★★★
* **Popularity:** ★☆☆
* **Usage examples:** Visitor isn’t a very common pattern because of its complexity and narrow applicability.

- Example: This example illustrates the structure of the **Visitor** design pattern and focuses on the following questions:
   * What classes does it consist of?
   * What roles do these classes play?
   * In what way the elements of the pattern are related?

After learning about the pattern’s structure it’ll be easier for you to grasp [the following example](@next), based on a real-world Swift use case.
 */
/// The Component interface declares an `accept` method that should take the
/// base visitor interface as an argument.
protocol Component {
    func accept(_ visitor: Visitor)
}

/// Each Concrete Component must implement the `accept` method in such a way
/// that it calls the visitor's method corresponding to the component's class.
class ConcreteComponentA: Component {
    /// Note that we're calling `visitConcreteComponentA`, which matches the
    /// current class name. This way we let the visitor know the class of the
    /// component it works with.
    func accept(_ visitor: Visitor) {
        visitor.visitConcreteComponentA(element: self)
    }

    /// Concrete Components may have special methods that don't exist in their
    /// base class or interface. The Visitor is still able to use these methods
    /// since it's aware of the component's concrete class.
    func exclusiveMethodOfConcreteComponentA() -> String {
        return "A"
    }
}

class ConcreteComponentB: Component {
    /// Same here: visitConcreteComponentB => ConcreteComponentB
    func accept(_ visitor: Visitor) {
        visitor.visitConcreteComponentB(element: self)
    }

    func specialMethodOfConcreteComponentB() -> String {
        return "B"
    }
}

/// The Visitor Interface declares a set of visiting methods that correspond to
/// component classes. The signature of a visiting method allows the visitor to
/// identify the exact class of the component that it's dealing with.
protocol Visitor {
    func visitConcreteComponentA(element: ConcreteComponentA)
    func visitConcreteComponentB(element: ConcreteComponentB)
}

/// Concrete Visitors implement several versions of the same algorithm, which
/// can work with all concrete component classes.
///
/// You can experience the biggest benefit of the Visitor pattern when using it
/// with a complex object structure, such as a Composite tree. In this case, it
/// might be helpful to store some intermediate state of the algorithm while
/// executing visitor's methods over various objects of the structure.
class ConcreteVisitor1: Visitor {
    func visitConcreteComponentA(element: ConcreteComponentA) {
        print(element.exclusiveMethodOfConcreteComponentA() + " + ConcreteVisitor1\n")
    }

    func visitConcreteComponentB(element: ConcreteComponentB) {
        print(element.specialMethodOfConcreteComponentB() + " + ConcreteVisitor1\n")
    }
}

class ConcreteVisitor2: Visitor {
    func visitConcreteComponentA(element: ConcreteComponentA) {
        print(element.exclusiveMethodOfConcreteComponentA() + " + ConcreteVisitor2\n")
    }

    func visitConcreteComponentB(element: ConcreteComponentB) {
        print(element.specialMethodOfConcreteComponentB() + " + ConcreteVisitor2\n")
    }
}

/// The client code can run visitor operations over any set of elements without
/// figuring out their concrete classes. The accept operation directs a call to
/// the appropriate operation in the visitor object.
class Client {
    // ...
    static func clientCode(components: [Component], visitor: Visitor) {
        // ...
        components.forEach({ $0.accept(visitor) })
        // ...
    }
    // ...
}

/// Let's see how it all works together.
class VisitorConceptual_TestCase {
    func testVisitorConceptual() {
        let components: [Component] = [ConcreteComponentA(), ConcreteComponentB()]

        print("The client code works with all visitors via the base Visitor interface:\n")
        let visitor1 = ConcreteVisitor1()
        Client.clientCode(components: components, visitor: visitor1)

        print("\nIt allows the same client code to work with different types of visitors:\n")
        let visitor2 = ConcreteVisitor2()
        Client.clientCode(components: components, visitor: visitor2)
    }
}

let testCase = VisitorConceptual_TestCase()
testCase.testVisitorConceptual()
