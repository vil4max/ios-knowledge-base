/*:
# Iterator: Conceptual Example

**Iterator** is a behavioral design pattern that allows sequential traversal through a complex data structure without exposing its internal details.

Thanks to the Iterator, clients can go over elements of different collections in a similar fashion using a single iterator interface.

[Learn more about Iterator →](https://refactoring.guru/design-patterns/iterator)

* **Complexity:** ★★☆
* **Popularity:** ★★★
* **Usage examples:** The pattern is very common in Swift code. Many frameworks and libraries use it to provide a standard way for traversing their collections.
* **Identification:** Iterator is easy to recognize by the navigation methods (such as `next`, `previous` and others). Client code that uses iterators might not have direct access to the collection being traversed.

- Example: This example illustrates the structure of the **Iterator** design pattern and focuses on the following questions:
   * What classes does it consist of?
   * What roles do these classes play?
   * In what way the elements of the pattern are related?

After learning about the pattern’s structure it’ll be easier for you to grasp [the following example](@next), based on a real-world Swift use case.
 */
/// This is a collection that we're going to iterate through using an iterator
/// derived from IteratorProtocol.
class WordsCollection {
    fileprivate lazy var items = [String]()

    func append(_ item: String) {
        self.items.append(item)
    }
}

extension WordsCollection: Sequence {
    func makeIterator() -> WordsIterator {
        return WordsIterator(self)
    }
}

/// Concrete Iterators implement various traversal algorithms. These classes
/// store the current traversal position at all times.
class WordsIterator: IteratorProtocol {
    private let collection: WordsCollection
    private var index = 0

    init(_ collection: WordsCollection) {
        self.collection = collection
    }

    func next() -> String? {
        defer { index += 1 }
        return index < collection.items.count ? collection.items[index] : nil
    }
}

/// This is another collection that we'll provide AnyIterator for traversing its
/// items.
class NumbersCollection {
    fileprivate lazy var items = [Int]()

    func append(_ item: Int) {
        self.items.append(item)
    }
}

extension NumbersCollection: Sequence {
    func makeIterator() -> AnyIterator<Int> {
        var index = self.items.count - 1

        return AnyIterator {
            defer { index -= 1 }
            return index >= 0 ? self.items[index] : nil
        }
    }
}

/// Client does not know the internal representation of a given sequence.
class Client {
    // ...
    static func clientCode<S: Sequence>(sequence: S) {
        for item in sequence {
            print(item)
        }
    }
    // ...
}

/// Let's see how it all works together.
class IteratorConceptual_TestCase {
    func testIteratorProtocol() {
        let words = WordsCollection()
        words.append("First")
        words.append("Second")
        words.append("Third")

        print("Straight traversal using IteratorProtocol:")
        Client.clientCode(sequence: words)
    }

    func testAnyIterator() {
        let numbers = NumbersCollection()
        numbers.append(1)
        numbers.append(2)
        numbers.append(3)

        print("\nReverse traversal using AnyIterator:")
        Client.clientCode(sequence: numbers)
    }
}

let testCase = IteratorConceptual_TestCase()
testCase.testIteratorProtocol()
testCase.testAnyIterator()
