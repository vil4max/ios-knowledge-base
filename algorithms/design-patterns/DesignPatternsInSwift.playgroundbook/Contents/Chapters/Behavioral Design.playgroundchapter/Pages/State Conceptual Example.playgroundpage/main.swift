/*:
# State: Conceptual Example

**State** is a behavioral design pattern that allows an object to change the behavior when its internal state changes.

The pattern extracts state-related behaviors into separate state classes and forces the original object to delegate the work to an instance of these classes, instead of acting on its own.

[Learn more about State →](https://refactoring.guru/design-patterns/state)

* **Complexity:** ★☆☆
* **Popularity:** ★★☆
* **Usage examples:** The State pattern is commonly used in Swift to convert massive `switch`-base state machines into objects.
* **Identification:** State pattern can be recognized by methods that change their behavior depending on the objects’ state, controlled externally.

- Example: This example illustrates the structure of the **State** design pattern and focuses on the following questions:
   * What classes does it consist of?
   * What roles do these classes play?
   * In what way the elements of the pattern are related?

After learning about the pattern’s structure it’ll be easier for you to grasp [the following example](@next), based on a real-world Swift use case.
 */
/// The Context defines the interface of interest to clients. It also maintains
/// a reference to an instance of a State subclass, which represents the current
/// state of the Context.
class Context {
    /// A reference to the current state of the Context.
    private var state: State

    init(_ state: State) {
        self.state = state
        transitionTo(state: state)
    }

    /// The Context allows changing the State object at runtime.
    func transitionTo(state: State) {
        print("Context: Transition to " + String(describing: state))
        self.state = state
        self.state.update(context: self)
    }

    /// The Context delegates part of its behavior to the current State object.
    func request1() {
        state.handle1()
    }

    func request2() {
        state.handle2()
    }
}

/// The base State class declares methods that all Concrete State should
/// implement and also provides a backreference to the Context object,
/// associated with the State. This backreference can be used by States to
/// transition the Context to another State.
protocol State: class {
    func update(context: Context)

    func handle1()
    func handle2()
}

class BaseState: State {
    private(set) weak var context: Context?

    func update(context: Context) {
        self.context = context
    }

    func handle1() {}
    func handle2() {}
}

/// Concrete States implement various behaviors, associated with a state of the
/// Context.
class ConcreteStateA: BaseState {
    override func handle1() {
        print("ConcreteStateA handles request1.")
        print("ConcreteStateA wants to change the state of the context.\n")
        context?.transitionTo(state: ConcreteStateB())
    }

    override func handle2() {
        print("ConcreteStateA handles request2.\n")
    }
}

class ConcreteStateB: BaseState {
    override func handle1() {
        print("ConcreteStateB handles request1.\n")
    }

    override func handle2() {
        print("ConcreteStateB handles request2.")
        print("ConcreteStateB wants to change the state of the context.\n")
        context?.transitionTo(state: ConcreteStateA())
    }
}

/// Let's see how it all works together.
class StateConceptual_TestCase {
    func testStateConceptual() {
        let context = Context(ConcreteStateA())
        context.request1()
        context.request2()
    }
}

let testCase = StateConceptual_TestCase()
testCase.testStateConceptual()
