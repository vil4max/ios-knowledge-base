import Foundation

struct User {
    let name: String
    let age: Int
}

struct Company {
    let boss: User
    let employees: [User]
}

func inspect<T>(_ value: T) {
    let mirror = Mirror(reflecting: value)
    print("Inspecting \(mirror.subjectType):")
    for child in mirror.children {
        let label = child.label ?? "unknown"
        print("  - \(label): \(child.value)")
    }
}

func prettyPrint(_ value: Any, indent: Int = 0) {
    let mirror = Mirror(reflecting: value)

    if mirror.children.isEmpty {
        print(value)
        return
    }

    let isCollection = mirror.displayStyle == .collection
        || mirror.displayStyle == .set
        || mirror.displayStyle == .dictionary
    let open = isCollection ? "[" : "("
    let close = isCollection ? "]" : ")"

    if !isCollection {
        print("\(mirror.subjectType)", terminator: "")
    }
    print(open)

    let childIndent = String(repeating: "  ", count: indent + 1)

    for child in mirror.children {
        print(childIndent, terminator: "")
        if let label = child.label {
            print("\(label): ", terminator: "")
        }
        prettyPrint(child.value, indent: indent + 1)
    }

    let footerIndent = String(repeating: "  ", count: indent)
    print("\(footerIndent)\(close)")
}

@dynamicMemberLookup
struct JSONObject {
    private let value: Any

    init(_ value: Any) {
        self.value = value
    }

    subscript(dynamicMember member: String) -> JSONObject {
        guard let dictionary = value as? [String: Any], let next = dictionary[member] else {
            return JSONObject(NSNull())
        }
        return JSONObject(next)
    }

    var string: String? { value as? String }
    var int: Int? { value as? Int }
    var isNull: Bool { value is NSNull }
}

let michael = User(name: "Michael Scott", age: 44)
inspect(michael)

let dunderMifflin = Company(
    boss: User(name: "Michael", age: 44),
    employees: [
        User(name: "Jim", age: 33),
        User(name: "Dwight", age: 38)
    ]
)
prettyPrint(dunderMifflin)

let payload: [String: Any] = [
    "user": [
        "name": "Alex",
        "age": 30
    ]
]
let json = JSONObject(payload)
print(json.user.name.string ?? "missing")
print(json.user.age.int ?? -1)
