import Foundation

struct Profile {
    let name: String
    let age: Int

    var displayLabel: String {
        "\(name), \(age)"
    }
}

struct Team {
    let lead: Profile
    let members: [Profile]
}

enum LoadState {
    case idle
    case loaded(Profile)
    case failed(String)
}

func inspect<T>(_ value: T, title: String) {
    let mirror = Mirror(reflecting: value)
    print("=== \(title) ===")
    print("subjectType: \(mirror.subjectType)")
    print("displayStyle: \(String(describing: mirror.displayStyle))")
    for child in mirror.children {
        let label = child.label ?? "·"
        print("  \(label): \(child.value)")
    }
    print()
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
    var isMissing: Bool { isNull }
}

let alex = Profile(name: "Alex", age: 30)
inspect(alex, title: "Profile stored properties")
print("displayLabel is computed — not in Mirror.children above")
print()

let team = Team(
    lead: Profile(name: "Alex", age: 30),
    members: [
        Profile(name: "Sam", age: 28),
        Profile(name: "Jordan", age: 31)
    ]
)
print("=== prettyPrint Team ===")
prettyPrint(team)
print()

inspect(LoadState.loaded(alex), title: "Enum with associated value")
print()

let payload: [String: Any] = [
    "profile": [
        "name": "Alex",
        "age": 30
    ]
]
let json = JSONObject(payload)
print("=== Dynamic JSON ===")
print("name:", json.profile.name.string ?? "nil")
print("age:", json.profile.age.int.map(String.init) ?? "nil")
print("typo key isMissing:", json.profil.name.isMissing)
print("valid path isMissing:", json.profile.name.isMissing)
