/*:
# Strategy: Conceptual Example

**Strategy** is a behavioral design pattern that turns a set of behaviors into objects and makes them interchangeable inside original context object.

The original object, called context, holds a reference to a strategy object. The context delegates executing the behavior to the linked strategy object. In order to change the way the context performs its work, other objects may replace the currently linked strategy object with another one.

[Learn more about Strategy →](https://refactoring.guru/design-patterns/strategy)

* **Complexity:** ★☆☆
* **Popularity:** ★★★
* **Usage examples:** The Strategy pattern is very common in Swift code. It’s often used in various frameworks to provide users a way to change the behavior of a class without extending it.
* **Identification:** Strategy pattern can be recognized by a method that lets a nested object do the actual work, as well as a setter that allows replacing that object with a different one.

- Example: This example illustrates the structure of the **Strategy** design pattern and focuses on the following questions:
   * What classes does it consist of?
   * What roles do these classes play?
   * In what way the elements of the pattern are related?

After learning about the pattern’s structure it’ll be easier for you to grasp [the following example](@next), based on a real-world Swift use case.
 */
/// The Context defines the interface of interest to clients.
class Context {
    /// The Context maintains a reference to one of the Strategy objects. The
    /// Context does not know the concrete class of a strategy. It should work
    /// with all strategies via the Strategy interface.
    private var strategy: Strategy

    /// Usually, the Context accepts a strategy through the constructor, but
    /// also provides a setter to change it at runtime.
    init(strategy: Strategy) {
        self.strategy = strategy
    }

    /// Usually, the Context allows replacing a Strategy object at runtime.
    func update(strategy: Strategy) {
        self.strategy = strategy
    }

    /// The Context delegates some work to the Strategy object instead of
    /// implementing multiple versions of the algorithm on its own.
    func doSomeBusinessLogic() {
        print("Context: Sorting data using the strategy (not sure how it'll do it)\n")

        let result = strategy.doAlgorithm(["a", "b", "c", "d", "e"])
        print(result.joined(separator: ","))
    }
}

/// The Strategy interface declares operations common to all supported versions
/// of some algorithm.
///
/// The Context uses this interface to call the algorithm defined by Concrete
/// Strategies.
protocol Strategy {
    func doAlgorithm<T: Comparable>(_ data: [T]) -> [T]
}

/// Concrete Strategies implement the algorithm while following the base
/// Strategy interface. The interface makes them interchangeable in the Context.
class ConcreteStrategyA: Strategy {
    func doAlgorithm<T: Comparable>(_ data: [T]) -> [T] {
        return data.sorted()
    }
}

class ConcreteStrategyB: Strategy {
    func doAlgorithm<T: Comparable>(_ data: [T]) -> [T] {
        return data.sorted(by: >)
    }
}

/// Let's see how it all works together.
class StrategyConceptual_TestCase {
    func testStrategyConceptual() {
        /// The client code picks a concrete strategy and passes it to the
        /// context. The client should be aware of the differences between
        /// strategies in order to make the right choice.

        let context = Context(strategy: ConcreteStrategyA())
        print("Client: Strategy is set to normal sorting.\n")
        context.doSomeBusinessLogic()

        print("\nClient: Strategy is set to reverse sorting.\n")
        context.update(strategy: ConcreteStrategyB())
        context.doSomeBusinessLogic()
    }
}

let testCase = StrategyConceptual_TestCase()
testCase.testStrategyConceptual()
