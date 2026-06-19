/*:
# Mediator: Conceptual Example

**Mediator** is a behavioral design pattern that reduces coupling between components of a program by making them communicate indirectly, through a special mediator object.

The Mediator makes it easy to modify, extend and reuse individual components because they’re no longer dependent on the dozens of other classes.

[Learn more about Mediator →](https://refactoring.guru/design-patterns/mediator)

* **Complexity:** ★★☆
* **Popularity:** ☆☆☆
* **Usage examples:** The most popular usage of the Mediator pattern in Swift code is facilitating communications between GUI components of an app. The synonym of the Mediator is the Controller part of MVC pattern.

- Example: This example illustrates the structure of the **Mediator** design pattern and focuses on the following questions:
   * What classes does it consist of?
   * What roles do these classes play?
   * In what way the elements of the pattern are related?

After learning about the pattern’s structure it’ll be easier for you to grasp [the following example](@next), based on a real-world Swift use case.
 */
/// The Mediator interface declares a method used by components to notify the
/// mediator about various events. The Mediator may react to these events and
/// pass the execution to other components.
protocol Mediator: AnyObject {
    func notify(sender: BaseComponent, event: String)
}

/// Concrete Mediators implement cooperative behavior by coordinating several
/// components.
class ConcreteMediator: Mediator {
    private var component1: Component1
    private var component2: Component2

    init(_ component1: Component1, _ component2: Component2) {
        self.component1 = component1
        self.component2 = component2

        component1.update(mediator: self)
        component2.update(mediator: self)
    }

    func notify(sender: BaseComponent, event: String) {
        if event == "A" {
            print("Mediator reacts on A and triggers following operations:")
            self.component2.doC()
        }
        else if (event == "D") {
            print("Mediator reacts on D and triggers following operations:")
            self.component1.doB()
            self.component2.doC()
        }
    }
}

/// The Base Component provides the basic functionality of storing a mediator's
/// instance inside component objects.
class BaseComponent {
    fileprivate weak var mediator: Mediator?

    init(mediator: Mediator? = nil) {
        self.mediator = mediator
    }

    func update(mediator: Mediator) {
        self.mediator = mediator
    }
}

/// Concrete Components implement various functionality. They don't depend on
/// other components. They also don't depend on any concrete mediator classes.
class Component1: BaseComponent {
    func doA() {
        print("Component 1 does A.")
        mediator?.notify(sender: self, event: "A")
    }

    func doB() {
        print("Component 1 does B.\n")
        mediator?.notify(sender: self, event: "B")
    }
}

class Component2: BaseComponent {
    func doC() {
        print("Component 2 does C.")
        mediator?.notify(sender: self, event: "C")
    }

    func doD() {
        print("Component 2 does D.")
        mediator?.notify(sender: self, event: "D")
    }
}

/// Let's see how it all works together.
class MediatorConceptual_TestCase {
    func testMediatorConceptual() {
        let component1 = Component1()
        let component2 = Component2()

        let mediator = ConcreteMediator(component1, component2)
        print("Client triggers operation A.")
        component1.doA()

        print("\nClient triggers operation D.")
        component2.doD()
    }
}

let testCase = MediatorConceptual_TestCase()
testCase.testMediatorConceptual()
