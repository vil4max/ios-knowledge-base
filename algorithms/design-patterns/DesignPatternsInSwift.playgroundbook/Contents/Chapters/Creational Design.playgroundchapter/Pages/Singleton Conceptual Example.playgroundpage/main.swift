/*:
# Singleton: Conceptual Example

**Singleton** is a creational design pattern, which ensures that only one object of its kind exists and provides a single point of access to it for any other code.

Singleton has almost the same pros and cons as global variables. Although they’re super-handy, they break the modularity of your code.

You can’t just use a class that depends on a Singleton in some other context, without carrying over the Singleton to the other context. Most of the time, this limitation comes up during the creation of unit tests.

[Learn more about Singleton →](https://refactoring.guru/design-patterns/singleton)

* **Complexity:** ★☆☆
* **Popularity:** ★★☆
* **Usage examples:** A lot of developers consider the Singleton pattern an antipattern. That’s why its usage is on the decline in Swift code.
* **Identification:** Singleton can be recognized by a static creation method, which returns the same cached object.

- Example: This example illustrates the structure of the **Singleton** design pattern and focuses on the following questions:
   * What classes does it consist of?
   * What roles do these classes play?
   * In what way the elements of the pattern are related?

After learning about the pattern’s structure it’ll be easier for you to grasp [the following example](@next), based on a real-world Swift use case.
 */
import Foundation

/// The Singleton class defines the `shared` field that lets clients access the
/// unique singleton instance.
class Singleton {
    /// The static field that controls the access to the singleton instance.
    ///
    /// This implementation let you extend the Singleton class while keeping
    /// just one instance of each subclass around.
    static var shared: Singleton = {
        let instance = Singleton()
        // ... configure the instance
        // ...
        return instance
    }()

    /// The Singleton's initializer should always be private to prevent direct
    /// construction calls with the `new` operator.
    private init() {}

    /// Finally, any singleton should define some business logic, which can be
    /// executed on its instance.
    func someBusinessLogic() -> String {
        // ...
        return "Result of the 'someBusinessLogic' call"
    }
}

/// Singletons should not be cloneable.
extension Singleton: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}

/// The client code.
class Client {
    // ...
    static func someClientCode() {
        let instance1 = Singleton.shared
        let instance2 = Singleton.shared

        if (instance1 === instance2) {
            print("Singleton works, both variables contain the same instance.")
        } else {
            print("Singleton failed, variables contain different instances.")
        }
    }
    // ...
}

/// Let's see how it all works together.
class SingletonConceptual_TestCase {
    func testSingletonConceptual() {
        Client.someClientCode()
    }
}

let testCase = SingletonConceptual_TestCase()
testCase.testSingletonConceptual()
