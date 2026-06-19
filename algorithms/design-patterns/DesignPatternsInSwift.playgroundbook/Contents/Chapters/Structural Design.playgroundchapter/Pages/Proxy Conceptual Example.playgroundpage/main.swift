/*:
# Proxy: Conceptual Example

**Proxy** is a structural design pattern that provides an object that acts as a substitute for a real service object used by a client. A proxy receives client requests, does some work (access control, caching, etc.) and then passes the request to a service object.

The proxy object has the same interface as a service, which makes it interchangeable with a real object when passed to a client.

[Learn more about Proxy →](https://refactoring.guru/design-patterns/proxy)

* **Complexity:** ★★☆
* **Popularity:** ★☆☆
* **Usage examples:** While the Proxy pattern isn’t a frequent guest in most Swift applications, it’s still very handy in some special cases. It’s irreplaceable when you want to add some additional behaviors to an object of some existing class without changing the client code.
* **Identification:** Proxies delegate all of the real work to some other object. Each proxy method should, in the end, refer to a service object unless the proxy is a subclass of a service.

- Example: This example illustrates the structure of the **Proxy** design pattern and focuses on the following questions:
   * What classes does it consist of?
   * What roles do these classes play?
   * In what way the elements of the pattern are related?

After learning about the pattern’s structure it’ll be easier for you to grasp [the following example](@next), based on a real-world Swift use case.
 */
/// The Subject interface declares common operations for both RealSubject and
/// the Proxy. As long as the client works with RealSubject using this
/// interface, you'll be able to pass it a proxy instead of a real subject.
protocol Subject {
    func request()
}

/// The RealSubject contains some core business logic. Usually, RealSubjects are
/// capable of doing some useful work which may also be very slow or sensitive -
/// e.g. correcting input data. A Proxy can solve these issues without any
/// changes to the RealSubject's code.
class RealSubject: Subject {
    func request() {
        print("RealSubject: Handling request.")
    }
}

/// The Proxy has an interface identical to the RealSubject.
class Proxy: Subject {
    private var realSubject: RealSubject

    /// The Proxy maintains a reference to an object of the RealSubject class.
    /// It can be either lazy-loaded or passed to the Proxy by the client.
    init(_ realSubject: RealSubject) {
        self.realSubject = realSubject
    }

    /// The most common applications of the Proxy pattern are lazy loading,
    /// caching, controlling the access, logging, etc. A Proxy can perform one
    /// of these things and then, depending on the result, pass the execution to
    /// the same method in a linked RealSubject object.
    func request() {
        if (checkAccess()) {
            realSubject.request()
            logAccess()
        }
    }

    private func checkAccess() -> Bool {
        /// Some real checks should go here.

        print("Proxy: Checking access prior to firing a real request.")

        return true
    }

    private func logAccess() {
        print("Proxy: Logging the time of request.")
    }
}

/// The client code is supposed to work with all objects (both subjects and
/// proxies) via the Subject interface in order to support both real subjects
/// and proxies. In real life, however, clients mostly work with their real
/// subjects directly. In this case, to implement the pattern more easily, you
/// can extend your proxy from the real subject's class.
class Client {
    // ...
    static func clientCode(subject: Subject) {
        // ...
        subject.request()
        // ...
    }
    // ...
}

/// Let's see how it all works together.
class ProxyConceptual_TestCase {
    func testProxyConceptual() {
        print("Client: Executing the client code with a real subject:")
        let realSubject = RealSubject()
        Client.clientCode(subject: realSubject)

        print("\nClient: Executing the same client code with a proxy:")
        let proxy = Proxy(realSubject)
        Client.clientCode(subject: proxy)
    }
}

let testCase = ProxyConceptual_TestCase()
testCase.testProxyConceptual()
