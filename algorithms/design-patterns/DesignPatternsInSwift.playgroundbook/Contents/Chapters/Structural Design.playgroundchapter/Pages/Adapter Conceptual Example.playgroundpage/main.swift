/*:
# Adapter: Conceptual Example

**Adapter** is a structural design pattern, which allows incompatible objects to collaborate.

The Adapter acts as a wrapper between two objects. It catches calls for one object and transforms them to format and interface recognizable by the second object.

[Learn more about Adapter →](https://refactoring.guru/design-patterns/adapter)

* **Complexity:** ★☆☆
* **Popularity:** ★★★
* **Usage examples:** The Adapter pattern is pretty common in Swift code. It’s very often used in systems based on some legacy code. In such cases, Adapters make legacy code work with modern classes.
* **Identification:** Adapter is recognizable by a constructor which takes an instance of a different abstract/interface type. When adapter receives a call to any of its methods, it translates parameters to appropriate format and then directs the call to one or several methods of the wrapped object.

- Example: This example illustrates the structure of the **Adapter** design pattern and focuses on the following questions:
   * What classes does it consist of?
   * What roles do these classes play?
   * In what way the elements of the pattern are related?

After learning about the pattern’s structure it’ll be easier for you to grasp [the following example](@next), based on a real-world Swift use case.
 */
/// The Target defines the domain-specific interface used by the client code.
class Target {
    func request() -> String {
        return "Target: The default target's behavior."
    }
}

/// The Adaptee contains some useful behavior, but its interface is incompatible
/// with the existing client code. The Adaptee needs some adaptation before the
/// client code can use it.
class Adaptee {
    public func specificRequest() -> String {
        return ".eetpadA eht fo roivaheb laicepS"
    }
}

/// The Adapter makes the Adaptee's interface compatible with the Target's
/// interface.
class Adapter: Target {
    private var adaptee: Adaptee

    init(_ adaptee: Adaptee) {
        self.adaptee = adaptee
    }

    override func request() -> String {
        return "Adapter: (TRANSLATED) " + adaptee.specificRequest().reversed()
    }
}

/// The client code supports all classes that follow the Target interface.
class Client {
    // ...
    static func someClientCode(target: Target) {
        print(target.request())
    }
    // ...
}

/// Let's see how it all works together.
class AdapterConceptual_TestCase {
    func testAdapterConceptual() {
        print("Client: I can work just fine with the Target objects:")
        Client.someClientCode(target: Target())

        let adaptee = Adaptee()
        print("Client: The Adaptee class has a weird interface. See, I don't understand it:")
        print("Adaptee: " + adaptee.specificRequest())

        print("Client: But I can work with it via the Adapter:")
        Client.someClientCode(target: Adapter(adaptee))
    }
}

let testCase = AdapterConceptual_TestCase()
testCase.testAdapterConceptual()
