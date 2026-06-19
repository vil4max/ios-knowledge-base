import Combine
import Foundation

struct User: Sendable { let id: String }
struct Post: Sendable { let title: String }

func fetchUser() async throws -> User {
    try await Task.sleep(nanoseconds: 100_000_000)
    return User(id: "u1")
}

func fetchPosts(for user: User) async throws -> [Post] {
    try await Task.sleep(nanoseconds: 100_000_000)
    return [Post(title: "Hello"), Post(title: "World")]
}

func loadData() async throws {
    let user = try await fetchUser()
    let posts = try await fetchPosts(for: user)
    print(posts.map(\.title))
}

func startWork() {
    Task {
        try? await loadData()
    }
}

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var users: [String] = []

    func fetchUsers() async {
        try? await Task.sleep(nanoseconds: 50_000_000)
        users = ["Alice", "Bob"]
    }
}

actor CounterManager {
    private var count = 0

    func increment() {
        count += 1
    }

    func value() -> Int { count }
}

func fetchUsersParallel() async throws -> [User] {
    try await Task.sleep(nanoseconds: 80_000_000)
    return [User(id: "a"), User(id: "b")]
}

func fetchPostsParallel() async throws -> [Post] {
    try await Task.sleep(nanoseconds: 80_000_000)
    return [Post(title: "A"), Post(title: "B")]
}

func loadParallel() async throws {
    async let users = fetchUsersParallel()
    async let posts = fetchPostsParallel()
    let (u, p) = try await (users, posts)
    print(u.count, p.count)
}

Task {
    try await loadData()
    try await loadParallel()

    let counter = CounterManager()
    await counter.increment()
    print(await counter.value())

    let viewModel = HomeViewModel()
    await viewModel.fetchUsers()
    print(viewModel.users)
}
