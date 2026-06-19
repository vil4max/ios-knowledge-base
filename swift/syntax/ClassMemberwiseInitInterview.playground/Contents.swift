import Foundation

/*
 Q&A cards — Q10 (no memberwise init for classes)

 Swift book — Initialization / Class Inheritance:
 https://docs.swift.org/swift-book/documentation/the-swift-programming-language/initialization/

 Thesis: structs get memberwise init when stored properties allow it; classes need designated inits,
 inheritance rules, and access control — auto memberwise would break those guarantees.
*/

struct Point {
    var x: Int
    var y: Int
}

let p = Point(x: 1, y: 2)
print("struct memberwise:", p)

class Animal {
    let name: String

    init(name: String) {
        self.name = name
    }
}

class Dog: Animal {
    let breed: String

    init(name: String, breed: String) {
        self.breed = breed
        super.init(name: name)
    }
}

let d = Dog(name: "Rex", breed: "mix")
print("class designated:", d.name, d.breed)
