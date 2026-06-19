/*:
# Bridge: Conceptual Example

**Bridge** is a structural design pattern that divides business logic or huge class into separate class hierarchies that can be developed independently.

One of these hierarchies (often called the Abstraction) will get a reference to an object of the second hierarchy (Implementation). The abstraction will be able to delegate some (sometimes, most) of its calls to the implementations object. Since all implementations will have a common interface, they’d be interchangeable inside the abstraction.

[Learn more about Bridge →](https://refactoring.guru/design-patterns/bridge)

* **Complexity:** ★★★
* **Popularity:** ★☆☆
* **Usage examples:** The Bridge pattern is especially useful when dealing with cross-platform apps, supporting multiple types of database servers or working with several API providers of a certain kind (for example, cloud platforms, social networks, etc.)
* **Identification:** Bridge can be recognized by a clear distinction between some controlling entity and several different platforms that it relies on.

- Example: This example illustrates the structure of the **Bridge** design pattern and focuses on the following questions:
   * What classes does it consist of?
   * What roles do these classes play?
   * In what way the elements of the pattern are related?

After learning about the pattern’s structure it’ll be easier for you to grasp [the following example](@next), based on a real-world Swift use case.
 */
/// The Abstraction defines the interface for the "control" part of the two
/// class hierarchies. It maintains a reference to an object of the
/// Implementation hierarchy and delegates all of the real work to this object.
class Abstraction {
    fileprivate var implementation: Implementation

    init(_ implementation: Implementation) {
        self.implementation = implementation
    }

    func operation() -> String {
        let operation = implementation.operationImplementation()
        return "Abstraction: Base operation with:\n" + operation
    }
}

/// You can extend the Abstraction without changing the Implementation classes.
class ExtendedAbstraction: Abstraction {
    override func operation() -> String {
        let operation = implementation.operationImplementation()
        return "ExtendedAbstraction: Extended operation with:\n" + operation
    }
}

/// The Implementation defines the interface for all implementation classes. It
/// doesn't have to match the Abstraction's interface. In fact, the two
/// interfaces can be entirely different. Typically the Implementation interface
/// provides only primitive operations, while the Abstraction defines higher-
/// level operations based on those primitives.
protocol Implementation {
    func operationImplementation() -> String
}

/// Each Concrete Implementation corresponds to a specific platform and
/// implements the Implementation interface using that platform's API.
class ConcreteImplementationA: Implementation {
    func operationImplementation() -> String {
        return "ConcreteImplementationA: Here's the result on the platform A.\n"
    }
}

class ConcreteImplementationB: Implementation {
    func operationImplementation() -> String {
        return "ConcreteImplementationB: Here's the result on the platform B\n"
    }
}

/// Except for the initialization phase, where an Abstraction object gets linked
/// with a specific Implementation object, the client code should only depend on
/// the Abstraction class. This way the client code can support any abstraction-
/// implementation combination.
class Client {
    // ...
    static func someClientCode(abstraction: Abstraction) {
        print(abstraction.operation())
    }
    // ...
}

/// Let's see how it all works together.
class BridgeConceptual_TestCase {
    func testBridgeConceptual() {
        // The client code should be able to work with any pre-configured
        // abstraction-implementation combination.
        let implementation = ConcreteImplementationA()
        Client.someClientCode(abstraction: Abstraction(implementation))

        let concreteImplementation = ConcreteImplementationB()
        Client.someClientCode(abstraction: ExtendedAbstraction(concreteImplementation))
    }
}

let testCase = BridgeConceptual_TestCase()
testCase.testBridgeConceptual()
