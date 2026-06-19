/*:
# Prototype: Conceptual Example

**Prototype** is a creational design pattern that allows cloning objects, even complex ones, without coupling to their specific classes.

All prototype classes should have a common interface that makes it possible to copy objects even if their concrete classes are unknown. Prototype objects can produce full copies since objects of the same class can access each other’s private fields.

[Learn more about Prototype →](https://refactoring.guru/design-patterns/prototype)

* **Complexity:** ★☆☆
* **Popularity:** ★★☆
* **Usage examples:** The Prototype pattern is available in Swift out of the box with a `NSCopying` interface.
* **Identification:** The prototype can be easily recognized by a `clone` or `copy` methods, etc.

- Example: This example illustrates the structure of the **Prototype** design pattern and focuses on the following questions:
   * What classes does it consist of?
   * What roles do these classes play?
   * In what way the elements of the pattern are related?

After learning about the pattern’s structure it’ll be easier for you to grasp [the following example](@next), based on a real-world Swift use case.
 */
import Foundation

/// Swift has built-in cloning support. To add cloning support to your class,
/// you need to implement the NSCopying protocol in that class and provide the
/// implementation for the `copy` method.
class BaseClass: NSCopying, Equatable {
    private var intValue = 1
    private var stringValue = "Value"

    required init(intValue: Int = 1, stringValue: String = "Value") {

        self.intValue = intValue
        self.stringValue = stringValue
    }

    /// MARK: - NSCopying
    func copy(with zone: NSZone? = nil) -> Any {
        let prototype = type(of: self).init()
        prototype.intValue = intValue
        prototype.stringValue = stringValue
        print("Values defined in BaseClass have been cloned!")
        return prototype
    }

    /// MARK: - Equatable
    static func == (lhs: BaseClass, rhs: BaseClass) -> Bool {
        return lhs.intValue == rhs.intValue && lhs.stringValue == rhs.stringValue
    }
}

/// Subclasses can override the base `copy` method to copy their own data into
/// the resulting object. But you should always call the base method first.
class SubClass: BaseClass {
    private var boolValue = true

    func copy() -> Any {
        return copy(with: nil)
    }

    override func copy(with zone: NSZone?) -> Any {
        guard let prototype = super.copy(with: zone) as? SubClass else {
            return SubClass() // oops
        }
        prototype.boolValue = boolValue
        print("Values defined in SubClass have been cloned!")
        return prototype
    }
}

/// The client code.
class Client {
    // ...
    static func someClientCode() {
        let original = SubClass(intValue: 2, stringValue: "Value2")

        guard let copy = original.copy() as? SubClass else {
            print("Cannot copy")
            return
        }

        /// See implementation of `Equatable` protocol for more details.
        guard copy == original else {
            print("Copy is not equal to Original")
            return
        }

        print("The original object is equal to the copied object!")
    }
    // ...
}

/// Let's see how it all works together.
class PrototypeConceptual_TestCase {
    func testPrototypeConceptual() {
        Client.someClientCode()
    }
}

let testCase = PrototypeConceptual_TestCase()
testCase.testPrototypeConceptual()
