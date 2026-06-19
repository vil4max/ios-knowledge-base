import Foundation

// Swift 5.5, iOS 15+

let selectedLocale: Locale = .americanEnglish
let selectedDate: Date = .iPhone
print("Locale: " + selectedLocale.description)
print("Date: " + selectedDate.description)

print()
print("Date/Time")
print("=========")

print("Date         Time")
print()

let dateOmittedOmitted = selectedDate.formatted(date: .omitted, time: .omitted)
print("omitted      omitted   ", dateOmittedOmitted)
let dateOmittedStandard = selectedDate.formatted(date: .omitted, time: .standard)
print("omitted      standard  ", dateOmittedStandard)
let dateOmittedShortened = selectedDate.formatted(date: .omitted, time: .shortened)
print("omitted      shortened ", dateOmittedShortened)
let dateOmittedComplete = selectedDate.formatted(date: .omitted, time: .complete)
print("omitted      complete  ", dateOmittedComplete)

print()
let dateNumericOmitted = selectedDate.formatted(date: .numeric, time: .omitted)
print("numeric      omitted   ", dateNumericOmitted)
let dateNumericStandard = selectedDate.formatted(date: .numeric, time: .standard)
print("numeric      standard  ", dateNumericStandard)
let dateNumericShortened = selectedDate.formatted(date: .numeric, time: .shortened)
print("numeric      shortened ", dateNumericShortened)
let dateNumericComplete = selectedDate.formatted(date: .numeric, time: .complete)
print("numeric      complete  ", dateNumericComplete)

print()
let dateAbbreviatedOmitted = selectedDate.formatted(date: .abbreviated, time: .omitted)
print("abbreviated  omitted   ", dateAbbreviatedOmitted)
let dateAbbreviatedStandard = selectedDate.formatted(date: .abbreviated, time: .standard)
print("abbreviated  standard  ", dateAbbreviatedStandard)
let dateAbbreviatedShortened = selectedDate.formatted(date: .abbreviated, time: .shortened)
print("abbreviated  shortened ", dateAbbreviatedShortened)
let dateAbbreviatedComplete = selectedDate.formatted(date: .abbreviated, time: .complete)
print("abbreviated  complete  ", dateAbbreviatedComplete)

print()
let dateLongOmitted = selectedDate.formatted(date: .long, time: .omitted)
print("long         omitted   ", dateLongOmitted)
let dateLongStandard = selectedDate.formatted(date: .long, time: .standard)
print("long         standard  ", dateLongStandard)
let dateLongShortened = selectedDate.formatted(date: .long, time: .shortened)
print("long         shortened ", dateLongShortened)
let dateLongComplete = selectedDate.formatted(date: .long, time: .complete)
print("long         complete  ", dateLongComplete)

print()
let dateCompleteOmitted = selectedDate.formatted(date: .complete, time: .omitted)
print("complete     omitted   ", dateCompleteOmitted)
let dateCompleteStandard = selectedDate.formatted(date: .complete, time: .standard)
print("complete     standard  ", dateCompleteStandard)
let dateCompleteShortened = selectedDate.formatted(date: .complete, time: .shortened)
print("complete     shortened ", dateCompleteShortened)
let dateCompleteComplete = selectedDate.formatted(date: .complete, time: .complete)
print("complete     complete  ", dateCompleteComplete)


print()
print("dateTime")
print("========")

let dateTime = selectedDate.formatted(.dateTime.locale(selectedLocale))
print(dateTime)

let dateDay = selectedDate.formatted(.dateTime.day().locale(selectedLocale))
print(dateDay)

let dateMonth = selectedDate.formatted(.dateTime.month().locale(selectedLocale))
print(dateMonth)

let dateYear = selectedDate.formatted(.dateTime.year().locale(selectedLocale))
print(dateYear)

let dateFormatted = selectedDate.formatted(.dateTime.year().month(.abbreviated).day().locale(selectedLocale))
print(dateFormatted)

let dateFormatted2 = selectedDate.formatted(.dateTime.year().month(.wide).day().hour().minute().locale(selectedLocale))
print(dateFormatted2)

let dateFormatted3 = selectedDate.formatted(.dateTime.year().month(.narrow).day().locale(selectedLocale))
print(dateFormatted3)

let dateFormatted4 = selectedDate.formatted(.dateTime.day(.twoDigits).month(.twoDigits).year().locale(selectedLocale))
print(dateFormatted4)


print()
print("dayOfYear")
print("=========")

let dayOfYear1 = Date.VisionPro.formatted(.dateTime.dayOfYear())
print(dayOfYear1)
let dayOfYear2 = Date.iPad.formatted(.dateTime.dayOfYear(.threeDigits))
print(dayOfYear2)
let dayOfYear3 = Date.iPhone.formatted(.dateTime.dayOfYear(.twoDigits))
print(dayOfYear3)
let dayOfYear4 = Date.Apple.formatted(.dateTime.dayOfYear(.defaultDigits))
print(dayOfYear4)


print()
print("era")
print("===")

let era = selectedDate.formatted(.dateTime.era().locale(selectedLocale))
print(era)
let eraAbbreviated = selectedDate.formatted(.dateTime.era(.abbreviated).locale(selectedLocale))
print(eraAbbreviated)
let eraNarrow = selectedDate.formatted(.dateTime.era(.narrow).locale(selectedLocale))
print(eraNarrow)
let eraWide = selectedDate.formatted(.dateTime.era(.wide).locale(selectedLocale))
print(eraWide)


print()
print("quarter")
print("=======")

let quarter = selectedDate.formatted(.dateTime.quarter().locale(selectedLocale))
print(quarter)
let quarterOneDigit = selectedDate.formatted(.dateTime.quarter(.oneDigit).locale(selectedLocale))
print(quarterOneDigit)
let quarterTwoDigits = selectedDate.formatted(.dateTime.quarter(.twoDigits).locale(selectedLocale))
print(quarterTwoDigits)
let quarterNarrow = selectedDate.formatted(.dateTime.quarter(.narrow).locale(selectedLocale))
print(quarterNarrow)
let quarterWide = selectedDate.formatted(.dateTime.quarter(.wide).locale(selectedLocale))
print(quarterWide)


print()
print("timeZone")
print("========")

let timezone = selectedDate.formatted(.dateTime.timeZone().locale(selectedLocale))
print(timezone)
let timezoneExemplarLocation = selectedDate.formatted(.dateTime.timeZone(.exemplarLocation).locale(selectedLocale))
print(timezoneExemplarLocation)
let timezoneGenericLocation = selectedDate.formatted(.dateTime.timeZone(.genericLocation).locale(selectedLocale))
print(timezoneGenericLocation)
let timezoneGenericNameShort = selectedDate.formatted(.dateTime.timeZone(.genericName(.short)).locale(selectedLocale))
print(timezoneGenericNameShort)
let timezoneGenericNameLong = selectedDate.formatted(.dateTime.timeZone(.genericName(.long)).locale(selectedLocale))
print(timezoneGenericNameLong)
let timezoneISOShort = selectedDate.formatted(.dateTime.timeZone(.iso8601(.short)).locale(selectedLocale))
print(timezoneISOShort)
let timezoneISOLong = selectedDate.formatted(.dateTime.timeZone(.iso8601(.long)).locale(selectedLocale))
print(timezoneISOLong)


print()
print("week")
print("====")

let week = selectedDate.formatted(.dateTime.week().locale(selectedLocale))
print(week)
let weekTwo = selectedDate.formatted(.dateTime.week(.twoDigits).locale(selectedLocale))
print(weekTwo)
let weekMonth = selectedDate.formatted(.dateTime.week(.weekOfMonth).locale(selectedLocale))
print(weekMonth)


print()
print("weekday")
print("=======")

let weekday = selectedDate.formatted(.dateTime.weekday().locale(selectedLocale))
print(weekday)
let weekdayAbbreviated = selectedDate.formatted(.dateTime.weekday(.abbreviated).locale(selectedLocale))
print(weekdayAbbreviated)
let weekdayNarrow = selectedDate.formatted(.dateTime.weekday(.narrow).locale(selectedLocale))
print(weekdayNarrow)
let weekdayOneDigit = selectedDate.formatted(.dateTime.weekday(.oneDigit).locale(selectedLocale))
print(weekdayOneDigit)
let weekdayShort = selectedDate.formatted(.dateTime.weekday(.short).locale(selectedLocale))
print(weekdayShort)
let weekdayTwoDigits = selectedDate.formatted(.dateTime.weekday(.twoDigits).locale(selectedLocale))
print(weekdayTwoDigits)
let weekdayWide = selectedDate.formatted(.dateTime.weekday(.wide).locale(selectedLocale))
print(weekdayWide)


print()
print("iso8601")
print("=======")

let dateISO1 = selectedDate.formatted(.iso8601.locale(selectedLocale))
print(dateISO1)
let dateISO2 = Date.VisionPro.formatted(.iso8601.locale(selectedLocale))
print(dateISO2)

print()
print("Custom extension")
print("================")

extension Date {
    func formatForTimeline() -> String {
        if Calendar.current.isDateInToday(self) {
            return "Today at \(self.formatted(.dateTime.hour().minute()))"
        } else {
            return self.formatted(.dateTime.year().month().day().hour().minute())
        }
    }
}

let timeline1 = Date.today.formatForTimeline()
print(timeline1)
let timeline2 = Date.iPhone.formatForTimeline()
print(timeline2)
