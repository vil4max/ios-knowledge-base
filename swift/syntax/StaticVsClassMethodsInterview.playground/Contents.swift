import Foundation

/*
 Q&A cards — Q6 (static vs class methods)

 Swift book — Methods:
 https://docs.swift.org/swift-book/documentation/the-swift-programming-language/methods/

 Thesis: static type methods are non-overridable; class methods on classes can be overridden in subclasses.
*/

class BasePrinter {
    static func tag() -> String {
        "base-static"
    }

    class func kind() -> String {
        "base-class"
    }
}

class ChildPrinter: BasePrinter {
    override class func kind() -> String {
        "child-class"
    }
}

print(BasePrinter.tag(), BasePrinter.kind())
print(ChildPrinter.kind())
