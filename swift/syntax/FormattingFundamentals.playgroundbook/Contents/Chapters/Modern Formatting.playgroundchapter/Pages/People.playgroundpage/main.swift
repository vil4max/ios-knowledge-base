import Foundation

struct User {
    let fullName: String

    func nameComponents(locale: Locale) -> PersonNameComponents? {
        let formatter = PersonNameComponentsFormatter()
        formatter.locale = locale
        return formatter.personNameComponents(from: fullName)
    }
}

print("People")
print("======")

print("\n# Spanish")

let ale = User(fullName: "Alejandro García Martínez")
if let components = ale.nameComponents(locale: .spanish) {
    print("Name    Short          ", components.formatted(.name(style: .short)))
    print("Name    Medium         ", components.formatted(.name(style: .medium)))
    print("Name    Long           ", components.formatted(.name(style: .long)))
    print("Name    Abbreviated    ", components.formatted(.name(style: .abbreviated)))
}

print("\n# American English")

let complexName = User(fullName: "Dr. Robert William Johnson III")
if let components = complexName.nameComponents(locale: .americanEnglish) {
    print("Name    Short          ", components.formatted(.name(style: .short)))
    print("Name    Medium         ", components.formatted(.name(style: .medium)))
    print("Name    Long           ", components.formatted(.name(style: .long)))
    print("Name    Abbreviated    ", components.formatted(.name(style: .abbreviated)))
}

print("\n# Japanese")

let japaneseName = User(fullName: "山田太郎") // Yamada Tarō
if let components = japaneseName.nameComponents(locale: .japanese) {
    print("Name    Short          ", components.formatted(.name(style: .short)))
    print("Name    Medium         ", components.formatted(.name(style: .medium)))
    print("Name    Long           ", components.formatted(.name(style: .long)))
    print("Name    Abbreviated    ", components.formatted(.name(style: .abbreviated)))
}
