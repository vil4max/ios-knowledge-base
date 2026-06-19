import Foundation

public extension Date {
    static var today: Date {
        Date()
    }
    
    static var Apple: Date {
        var dateComponents = DateComponents()
        dateComponents.year = 1976
        dateComponents.month = 1
        dateComponents.day = 24
        dateComponents.hour = 10
        dateComponents.timeZone = TimeZone(identifier: "America/Los_Angeles")
        return Calendar.current.date(from: dateComponents) ?? Date()
    }
    
    static var Macintosh: Date {
        var dateComponents = DateComponents()
        dateComponents.year = 1984
        dateComponents.month = 1
        dateComponents.day = 24
        dateComponents.timeZone = TimeZone(identifier: "America/Los_Angeles")
        return Calendar.current.date(from: dateComponents) ?? Date()
    }
    
    static var iPod: Date {
        var dateComponents = DateComponents()
        dateComponents.year = 2001
        dateComponents.month = 10
        dateComponents.day = 23
        dateComponents.hour = 10
        dateComponents.timeZone = TimeZone(identifier: "America/Los_Angeles")
        return Calendar.current.date(from: dateComponents) ?? Date()
    }
    
    static var iPhone: Date {
        var dateComponents = DateComponents()
        dateComponents.year = 2007
        dateComponents.month = 1
        dateComponents.day = 9
        dateComponents.hour = 9
        dateComponents.minute = 41
        dateComponents.timeZone = TimeZone(identifier: "America/Los_Angeles")
        return Calendar.current.date(from: dateComponents) ?? Date()
    }
    
    static var iPad: Date {
        var dateComponents = DateComponents()
        dateComponents.year = 2010
        dateComponents.month = 1
        dateComponents.day = 27
        dateComponents.hour = 9
        dateComponents.minute = 41
        dateComponents.timeZone = TimeZone(identifier: "America/Los_Angeles")
        return Calendar.current.date(from: dateComponents) ?? Date()
    }
    
    static var VisionPro: Date {
        var dateComponents = DateComponents()
        dateComponents.year = 2023
        dateComponents.month = 6
        dateComponents.day = 5
        dateComponents.hour = 11
        dateComponents.minute = 21
        dateComponents.timeZone = TimeZone(identifier: "America/Los_Angeles")
        return Calendar.current.date(from: dateComponents) ?? Date()
    }
}
