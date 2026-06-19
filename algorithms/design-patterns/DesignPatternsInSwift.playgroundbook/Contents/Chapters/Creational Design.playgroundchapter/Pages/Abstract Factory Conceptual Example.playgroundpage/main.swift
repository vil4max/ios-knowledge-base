/*:
# Abstract Factory: Conceptual Example

**Abstract Factory** is a creational design pattern, which solves the problem of creating entire product families without specifying their concrete classes.

Abstract Factory defines an interface for creating all distinct products but leaves the actual product creation to concrete factory classes. Each factory type corresponds to a certain product variety.

The client code calls the creation methods of a factory object instead of creating products directly with a constructor call (`new` operator). Since a factory corresponds to a single product variant, all its products will be compatible.

Client code works with factories and products only through their abstract interfaces. This lets the client code work with any product variants, created by the factory object. You just create a new concrete factory class and pass it to the client code.

[Learn more about Abstract Factory →](https://refactoring.guru/design-patterns/abstract-factory)

* **Complexity:** ★★☆
* **Popularity:** ★★★
* **Usage examples:** The Abstract Factory pattern is pretty common in Swift code. Many frameworks and libraries use it to provide a way to extend and customize their standard components.
* **Identification:** The pattern is easy to recognize by methods, which return a factory object. Then, the factory is used for creating specific sub-components.

- Example: This example illustrates the structure of the **Abstract Factory** design pattern and focuses on the following questions:
   * What classes does it consist of?
   * What roles do these classes play?
   * In what way the elements of the pattern are related?

After learning about the pattern’s structure it’ll be easier for you to grasp [the following example](@next), based on a real-world Swift use case.
 */
/// The Abstract Factory protocol declares a set of methods that return
/// different abstract products. These products are called a family and are
/// related by a high-level theme or concept. Products of one family are usually
/// able to collaborate among themselves. A family of products may have several
/// variants, but the products of one variant are incompatible with products of
/// another.
protocol AbstractFactory {
    func createProductA() -> AbstractProductA
    func createProductB() -> AbstractProductB
}

/// Concrete Factories produce a family of products that belong to a single
/// variant. The factory guarantees that resulting products are compatible. Note
/// that signatures of the Concrete Factory's methods return an abstract
/// product, while inside the method a concrete product is instantiated.
class ConcreteFactory1: AbstractFactory {
    func createProductA() -> AbstractProductA {
        return ConcreteProductA1()
    }

    func createProductB() -> AbstractProductB {
        return ConcreteProductB1()
    }
}

/// Each Concrete Factory has a corresponding product variant.
class ConcreteFactory2: AbstractFactory {
    func createProductA() -> AbstractProductA {
        return ConcreteProductA2()
    }

    func createProductB() -> AbstractProductB {
        return ConcreteProductB2()
    }
}

/// Each distinct product of a product family should have a base protocol. All
/// variants of the product must implement this protocol.
protocol AbstractProductA {
    func usefulFunctionA() -> String
}

/// Concrete Products are created by corresponding Concrete Factories.
class ConcreteProductA1: AbstractProductA {
    func usefulFunctionA() -> String {
        return "The result of the product A1."
    }
}

class ConcreteProductA2: AbstractProductA {
    func usefulFunctionA() -> String {
        return "The result of the product A2."
    }
}

/// The base protocol of another product. All products can interact with each
/// other, but proper interaction is possible only between products of the same
/// concrete variant.
protocol AbstractProductB {
    /// Product B is able to do its own thing...
    func usefulFunctionB() -> String

    /// ...but it also can collaborate with the ProductA.
    ///
    /// The Abstract Factory makes sure that all products it creates are of the
    /// same variant and thus, compatible.
    func anotherUsefulFunctionB(collaborator: AbstractProductA) -> String
}

/// Concrete Products are created by corresponding Concrete Factories.
class ConcreteProductB1: AbstractProductB {
    func usefulFunctionB() -> String {
        return "The result of the product B1."
    }

    /// This variant, Product B1, is only able to work correctly with the
    /// variant, Product A1. Nevertheless, it accepts any instance of
    /// AbstractProductA as an argument.
    func anotherUsefulFunctionB(collaborator: AbstractProductA) -> String {
        let result = collaborator.usefulFunctionA()
        return "The result of the B1 collaborating with the (\(result))"
    }
}

class ConcreteProductB2: AbstractProductB {
    func usefulFunctionB() -> String {
        return "The result of the product B2."
    }

    /// This variant, Product B2, is only able to work correctly with the
    /// variant, Product A2. Nevertheless, it accepts any instance of
    /// AbstractProductA as an argument.
    func anotherUsefulFunctionB(collaborator: AbstractProductA) -> String {
        let result = collaborator.usefulFunctionA()
        return "The result of the B2 collaborating with the (\(result))"
    }
}

/// The client code works with factories and products only through abstract
/// types: AbstractFactory and AbstractProduct. This lets you pass any factory
/// or product subclass to the client code without breaking it.
class Client {
    // ...
    static func someClientCode(factory: AbstractFactory) {
        let productA = factory.createProductA()
        let productB = factory.createProductB()

        print(productB.usefulFunctionB())
        print(productB.anotherUsefulFunctionB(collaborator: productA))
    }
    // ...
}

/// Let's see how it all works together.
class AbstractFactoryConceptual_TestCase {
    func testAbstractFactoryConceptual() {
        /// The client code can work with any concrete factory class.
        print("Client: Testing client code with the first factory type:")
        Client.someClientCode(factory: ConcreteFactory1())

        print("Client: Testing the same client code with the second factory type:")
        Client.someClientCode(factory: ConcreteFactory2())
    }
}

let testCase = AbstractFactoryConceptual_TestCase()
testCase.testAbstractFactoryConceptual()
