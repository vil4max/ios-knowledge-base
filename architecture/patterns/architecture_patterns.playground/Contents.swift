import Foundation

/*
 Q&A cards — Theme 5 MVVM vs Clean boundaries (Q35, Q36, Q39)

 MVVM keeps UI logic near the view layer; Clean Architecture pushes domain rules inward
 behind protocols so frameworks become plugins.

 Below: constructor injection (explicit dependency) vs hiding services behind a locator.
*/

protocol Clock {
    func now() -> Date
}

struct SystemClock: Clock {
    func now() -> Date {
        Date()
    }
}

protocol GreeterService {
    func message(at date: Date) -> String
}

struct TimeGreeter: GreeterService {
    let clock: Clock

    func message(at date: Date) -> String {
        let hour = Calendar.current.component(.hour, from: date)
        return hour < 12 ? "Good morning" : "Hello"
    }
}

struct GreeterViewModel {
    let greeter: GreeterService

    func headline() -> String {
        let date = Date()
        return greeter.message(at: date)
    }
}

let vm = GreeterViewModel(greeter: TimeGreeter(clock: SystemClock()))
print("MVVM-style headline:", vm.headline())

enum ServiceLocator {
    static var clock: Clock = SystemClock()
}

struct LocatorBackedGreeter: GreeterService {
    func message(at date: Date) -> String {
        let hour = Calendar.current.component(.hour, from: date)
        _ = ServiceLocator.clock.now()
        return hour < 12 ? "Locator morning" : "Locator hello"
    }
}

print("Locator-style:", GreeterViewModel(greeter: LocatorBackedGreeter()).headline())
