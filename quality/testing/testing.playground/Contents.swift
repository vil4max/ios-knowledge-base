import Foundation

func priceAfterDiscount(base: Decimal, percentOff: Decimal) -> Decimal {
    base * (1 - percentOff / 100)
}

protocol CartStore {
    func save(itemId: String)
}

final class CartStoreSpy: CartStore {
    private(set) var savedItemIds: [String] = []

    func save(itemId: String) {
        savedItemIds.append(itemId)
    }
}

final class CartViewModel {
    private let store: CartStore
    private(set) var itemCount = 0

    init(store: CartStore) {
        self.store = store
    }

    func add(itemId: String) {
        store.save(itemId: itemId)
        itemCount += 1
    }
}

struct UserDTO: Decodable {
    let id: String
    let displayName: String
}

struct APIErrorDTO: Decodable {
    let code: String
    let message: String
}

enum ProfileError: Error, Equatable {
    case unauthorized(message: String)
    case unexpectedStatus(Int)
}

struct ProfileService {
    let session: URLSession
    let baseURL: URL

    func fetchUser(id: String) async throws -> UserDTO {
        let url = baseURL.appendingPathComponent("users/\(id)")
        let (data, response) = try await session.data(from: url)
        guard let http = response as? HTTPURLResponse else {
            throw ProfileError.unexpectedStatus(-1)
        }
        switch http.statusCode {
        case 200 ... 299:
            return try JSONDecoder().decode(UserDTO.self, from: data)
        case 401:
            let body = try? JSONDecoder().decode(APIErrorDTO.self, from: data)
            throw ProfileError.unauthorized(message: body?.message ?? "Unauthorized")
        default:
            throw ProfileError.unexpectedStatus(http.statusCode)
        }
    }
}

final class MockURLProtocol: URLProtocol {
    static var handler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let client, let handler = MockURLProtocol.handler else { return }
        do {
            let (response, data) = try handler(request)
            client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client.urlProtocol(self, didLoad: data)
            client.urlProtocolDidFinishLoading(self)
        } catch {
            client.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}

func makeMockSession() -> URLSession {
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [MockURLProtocol.self]
    return URLSession(configuration: config)
}

func loadFixture(named name: String) throws -> Data {
    if let url = Bundle.main.url(forResource: name, withExtension: "json") {
        return try Data(contentsOf: url)
    }
    switch name {
    case "user_ok":
        return #"{"id":"42","displayName":"Ada"}"#.data(using: .utf8)!
    case "user_401":
        return #"{"code":"unauthorized","message":"Token expired"}"#.data(using: .utf8)!
    default:
        throw URLError(.fileDoesNotExist)
    }
}

func runAAADiscountDemo() {
    let actual = priceAfterDiscount(base: 100, percentOff: 15)
    let expected: Decimal = 85
    assert(actual == expected)
    print("AAA discount OK")
}

func runSpyDemo() {
    let spy = CartStoreSpy()
    let sut = CartViewModel(store: spy)
    sut.add(itemId: "book-1")
    assert(sut.itemCount == 1)
    assert(spy.savedItemIds == ["book-1"])
    print("Spy cart OK")
}

func runURLProtocolDemo() {
    let semaphore = DispatchSemaphore(value: 0)
    Task {
        defer { semaphore.signal() }
        let okBody = try loadFixture(named: "user_ok")
        MockURLProtocol.handler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            )!
            assert(request.url?.path.contains("/users/42") == true)
            return (response, okBody)
        }
        let service = ProfileService(
            session: makeMockSession(),
            baseURL: URL(string: "https://api.example.com")!
        )
        let user = try await service.fetchUser(id: "42")
        assert(user.id == "42")
        assert(user.displayName == "Ada")
        print("URLProtocol contract decode OK (user_ok.json)")
    }
    semaphore.wait()
}

func runContract401Demo() {
    let semaphore = DispatchSemaphore(value: 0)
    Task {
        defer { semaphore.signal() }
        let errorBody = try loadFixture(named: "user_401")
        MockURLProtocol.handler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 401,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            )!
            return (response, errorBody)
        }
        let service = ProfileService(
            session: makeMockSession(),
            baseURL: URL(string: "https://api.example.com")!
        )
        do {
            _ = try await service.fetchUser(id: "42")
            assertionFailure("Expected ProfileError.unauthorized")
        } catch let error as ProfileError {
            assert(error == .unauthorized(message: "Token expired"))
            print("Contract 401 OK (user_401.json → ProfileError)")
        }
    }
    semaphore.wait()
}

runAAADiscountDemo()
runSpyDemo()
runURLProtocolDemo()
runContract401Demo()
