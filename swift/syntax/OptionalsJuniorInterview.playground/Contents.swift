import Foundation

/*
 Q&A cards — Q41 (optionals)

 Swift book — Optionals:
 https://docs.swift.org/swift-book/documentation/the-swift-programming-language/thebasics/#Optionals
*/

var nickname: String? = "alex"
nickname = nil

if let boundNickname = nickname {
    print("if let:", boundNickname)
}

func greet(_ name: String?) {
    guard let name else {
        print("guard: missing name")
        return
    }
    print("guard:", name)
}
greet(nil)
greet("Sam")

let title: String? = nil
print("nil-coalescing:", title ?? "Guest")

struct User {
    let email: String?
}

let user = User(email: "a@b.c")
print("optional chaining:", user.email?.count ?? 0)
