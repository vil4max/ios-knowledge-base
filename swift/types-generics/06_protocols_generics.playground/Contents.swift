import Foundation

/*
 Q&A cards — Q7 (`any` vs generics), Q8 (`associatedtype`)

 Protocols with associated types:
 https://docs.swift.org/swift-book/documentation/the-swift-programming-language/generics/#Associated-Types

 Existentials:
 https://docs.swift.org/swift-book/documentation/the-swift-programming-language/opaquetypes-and-boxed-protocol-types/
*/

protocol Identified {
    associatedtype RawID: Hashable
    var id: RawID { get }
}

struct Book: Identified {
    typealias RawID = UUID
    let id: UUID
    let title: String
}

func describe<T: Identified>(_ value: T) -> String where T.RawID: CustomStringConvertible {
    "id=\(value.id)"
}

let book = Book(id: UUID(), title: "Swift")
print(describe(book))

protocol Drawable {
    func draw()
}

struct Circle: Drawable {
    func draw() {
        print("circle")
    }
}

struct Square: Drawable {
    func draw() {
        print("square")
    }
}

let shapes: [any Drawable] = [Circle(), Square()]
for shape in shapes {
    shape.draw()
}
