/*:
# Flyweight: Conceptual Example

**Flyweight** is a structural design pattern that allows programs to support vast quantities of objects by keeping their memory consumption low.

The pattern achieves it by sharing parts of object state between multiple objects. In other words, the Flyweight saves RAM by caching the same data used by different objects.

[Learn more about Flyweight →](https://refactoring.guru/design-patterns/flyweight)

* **Complexity:** ★★★
* **Popularity:** ☆☆☆
* **Usage examples:** The Flyweight pattern has a single purpose: minimizing memory intake. If your program doesn’t struggle with a shortage of RAM, then you might just ignore this pattern for a while.
* **Identification:** Flyweight can be recognized by a creation method that returns cached objects instead of creating new.

- Example: This example illustrates the structure of the **Flyweight** design pattern and focuses on the following questions:
   * What classes does it consist of?
   * What roles do these classes play?
   * In what way the elements of the pattern are related?

After learning about the pattern’s structure it’ll be easier for you to grasp [the following example](@next), based on a real-world Swift use case.
 */
/// The Flyweight stores a common portion of the state (also called intrinsic
/// state) that belongs to multiple real business entities. The Flyweight
/// accepts the rest of the state (extrinsic state, unique for each entity) via
/// its method parameters.
class Flyweight {
    private let sharedState: [String]

    init(sharedState: [String]) {
        self.sharedState = sharedState
    }

    func operation(uniqueState: [String]) {
        print("Flyweight: Displaying shared (\(sharedState)) and unique (\(uniqueState) state.\n")
    }
}

/// The Flyweight Factory creates and manages the Flyweight objects. It ensures
/// that flyweights are shared correctly. When the client requests a flyweight,
/// the factory either returns an existing instance or creates a new one, if it
/// doesn't exist yet.
class FlyweightFactory {
    private var flyweights: [String: Flyweight]

    init(states: [[String]]) {
        var flyweights = [String: Flyweight]()

        for state in states {
            flyweights[state.key] = Flyweight(sharedState: state)
        }

        self.flyweights = flyweights
    }

    /// Returns an existing Flyweight with a given state or creates a new one.
    func flyweight(for state: [String]) -> Flyweight {
        let key = state.key

        guard let foundFlyweight = flyweights[key] else {

            print("FlyweightFactory: Can't find a flyweight, creating new one.\n")
            let flyweight = Flyweight(sharedState: state)
            flyweights.updateValue(flyweight, forKey: key)
            return flyweight
        }
        print("FlyweightFactory: Reusing existing flyweight.\n")
        return foundFlyweight
    }

    func printFlyweights() {
        print("FlyweightFactory: I have \(flyweights.count) flyweights:\n")
        for item in flyweights {
            print(item.key)
        }
    }
}

extension Array where Element == String {
    /// Returns a Flyweight's string hash for a given state.
    var key: String {
        return self.joined()
    }
}


class FlyweightConceptual_TestCase {
    func testFlyweightConceptual() {
        /// The client code usually creates a bunch of pre-populated flyweights
        /// in the initialization stage of the application.

        let factory = FlyweightFactory(states: [
            ["Chevrolet", "Camaro2018", "pink"],
            ["Mercedes Benz", "C300", "black"],
            ["Mercedes Benz", "C500", "red"],
            ["BMW", "M5", "red"],
            ["BMW", "X6", "white"]
        ])

        factory.printFlyweights()

        /// ...

        addCarToPoliceDatabase(factory,
                "CL234IR",
                "James Doe",
                "BMW",
                "M5",
                "red")

        addCarToPoliceDatabase(factory,
                "CL234IR",
                "James Doe",
                "BMW",
                "X1",
                "red")

        factory.printFlyweights()
    }

    func addCarToPoliceDatabase(
            _ factory: FlyweightFactory,
            _ plates: String,
            _ owner: String,
            _ brand: String,
            _ model: String,
            _ color: String) {

        print("Client: Adding a car to database.\n")

        let flyweight = factory.flyweight(for: [brand, model, color])

        /// The client code either stores or calculates extrinsic state and
        /// passes it to the flyweight's methods.
        flyweight.operation(uniqueState: [plates, owner])
    }
}

let testCase = FlyweightConceptual_TestCase()
testCase.testFlyweightConceptual()
