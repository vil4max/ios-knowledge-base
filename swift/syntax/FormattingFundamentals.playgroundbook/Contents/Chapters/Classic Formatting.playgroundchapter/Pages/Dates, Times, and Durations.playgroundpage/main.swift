import Foundation

let selectedLocale: Locale = .americanEnglish
let selectedTimeZone: TimeZone = .LosAngeles
let selectedDate: Date = .iPhone

/*:
# DateFormatter

A formatter that converts between dates and their textual representations.

Instances of `DateFormatter` create string representations of `NSDate` objects, and convert textual representations of dates and times into `NSDate` objects. For user-visible representations of dates and times, `DateFormatter` provides a variety of localized presets and configuration options. For fixed format representations of dates and times, you can specify a custom format string.

[Apple Documentation](https://developer.apple.com/documentation/foundation/dateformatter)
 */
print("Locale: " + selectedLocale.description + "\n")
print("DateFormatter")
print("=============")

let dateFormatter = DateFormatter()
dateFormatter.locale = selectedLocale
dateFormatter.timeZone = selectedTimeZone

print("Date     Time\n")

dateFormatter.dateStyle = .full
dateFormatter.timeStyle = .full
let dateFullFull = dateFormatter.string(from: selectedDate)
print("full     full     ", dateFullFull)

dateFormatter.dateStyle = .full
dateFormatter.timeStyle = .long
let dateFullLong = dateFormatter.string(from: selectedDate)
print("full     long     ", dateFullLong)

dateFormatter.dateStyle = .full
dateFormatter.timeStyle = .medium
let dateFullMedium = dateFormatter.string(from: selectedDate)
print("full     medium   ", dateFullMedium)

dateFormatter.dateStyle = .full
dateFormatter.timeStyle = .short
let dateFullShort = dateFormatter.string(from: selectedDate)
print("full     short    ", dateFullShort)

dateFormatter.dateStyle = .full
dateFormatter.timeStyle = .none
let dateFullNone = dateFormatter.string(from: selectedDate)
print("full     none     ", dateFullNone)

print()

dateFormatter.dateStyle = .long
dateFormatter.timeStyle = .full
let dateLongFull = dateFormatter.string(from: selectedDate)
print("long     full     ", dateLongFull)

dateFormatter.dateStyle = .long
dateFormatter.timeStyle = .long
let dateLongLong = dateFormatter.string(from: selectedDate)
print("long     long     ", dateLongLong)

dateFormatter.dateStyle = .long
dateFormatter.timeStyle = .medium
let dateLongMedium = dateFormatter.string(from: selectedDate)
print("long     medium   ", dateLongMedium)

dateFormatter.dateStyle = .long
dateFormatter.timeStyle = .short
let dateLongShort = dateFormatter.string(from: selectedDate)
print("long     short    ", dateLongShort)

dateFormatter.dateStyle = .long
dateFormatter.timeStyle = .none
let dateLongNone = dateFormatter.string(from: selectedDate)
print("long     none     ", dateLongNone)

print()

dateFormatter.dateStyle = .medium
dateFormatter.timeStyle = .full
let dateMediumFull = dateFormatter.string(from: selectedDate)
print("medium   full     ", dateMediumFull)

dateFormatter.dateStyle = .medium
dateFormatter.timeStyle = .long
let dateMediumLong = dateFormatter.string(from: selectedDate)
print("medium   long     ", dateMediumLong)

dateFormatter.dateStyle = .medium
dateFormatter.timeStyle = .medium
let dateMediumMedium = dateFormatter.string(from: selectedDate)
print("medium   medium   ", dateMediumMedium)

dateFormatter.dateStyle = .medium
dateFormatter.timeStyle = .short
let dateMediumShort = dateFormatter.string(from: selectedDate)
print("medium   short    ", dateMediumShort)

dateFormatter.dateStyle = .medium
dateFormatter.timeStyle = .none
let dateMediumNone = dateFormatter.string(from: selectedDate)
print("medium   none     ", dateMediumNone)

print()

dateFormatter.dateStyle = .short
dateFormatter.timeStyle = .full
let dateShortFull = dateFormatter.string(from: selectedDate)
print("short    full     ", dateShortFull)

dateFormatter.dateStyle = .short
dateFormatter.timeStyle = .long
let dateShortLong = dateFormatter.string(from: selectedDate)
print("short    long     ", dateShortLong)

dateFormatter.dateStyle = .short
dateFormatter.timeStyle = .medium
let dateShortMedium = dateFormatter.string(from: selectedDate)
print("short    medium   ", dateShortMedium)

dateFormatter.dateStyle = .short
dateFormatter.timeStyle = .short
let dateShortShort = dateFormatter.string(from: selectedDate)
print("short    short    ", dateShortShort)

dateFormatter.dateStyle = .short
dateFormatter.timeStyle = .none
let dateShortNone = dateFormatter.string(from: selectedDate)
print("short    none     ", dateShortNone)

print()

dateFormatter.dateStyle = .none
dateFormatter.timeStyle = .full
let dateNoneFull = dateFormatter.string(from: selectedDate)
print("none     full     ", dateNoneFull)

dateFormatter.dateStyle = .none
dateFormatter.timeStyle = .long
let dateNoneLong = dateFormatter.string(from: selectedDate)
print("none     long     ", dateNoneLong)

dateFormatter.dateStyle = .none
dateFormatter.timeStyle = .medium
let dateNoneMedium = dateFormatter.string(from: selectedDate)
print("none     medium   ", dateNoneMedium)

dateFormatter.dateStyle = .none
dateFormatter.timeStyle = .short
let dateNoneShort = dateFormatter.string(from: selectedDate)
print("none     short    ", dateNoneShort)

dateFormatter.dateStyle = .none
dateFormatter.timeStyle = .none
let dateNoneNone = dateFormatter.string(from: selectedDate)
print("none     none     ", dateNoneNone)

print()
print("Create a date from custom format:")

dateFormatter.dateStyle = .medium
dateFormatter.timeStyle = .medium

dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
let dateString1 = "2024-02-05 12:17:52"
if let date = dateFormatter.date(from: dateString1),
   let dateFormat = dateFormatter.dateFormat {
    print(dateFormat, "->", dateString1)
    print(date)
}

print()

dateFormatter.dateFormat = "yy-MM-dd HH"
let dateString2 = "24-01-17 21"
if let date = dateFormatter.date(from: dateString2),
   let dateFormat = dateFormatter.dateFormat {
    print(dateFormat, " -> ", dateString2)
    print(date)
}

/*:
# ISO8601DateFormatter

A formatter that converts between dates and their ISO 8601 string representations.

The `ISO8601DateFormatter` class generates and parses string representations of dates following the ISO 8601 standard. Use this class to create [ISO 8601](https://www.iso.org/iso-8601-date-and-time-format.html) representations of dates and create dates from text strings in ISO 8601 format.

[Apple Documentation](https://developer.apple.com/documentation/foundation/iso8601dateformatter)
 */

print()
print("ISO8601DateFormatter")
print("====================")

let isoFormatter = ISO8601DateFormatter()
isoFormatter.timeZone = selectedTimeZone
if let isoDate = isoFormatter.date(from: "2024-02-12T09:41:00-07:00") {
    let isoString = isoFormatter.string(from: isoDate)
    print("ISO8601:  ", isoString)
    print("Date:     ", isoDate)
}

print()
isoFormatter.formatOptions = [.withFullDate, .withTime, .withTimeZone, .withFractionalSeconds]
let dateMacintoshString = isoFormatter.string(from: .Macintosh)
print(dateMacintoshString)

isoFormatter.formatOptions = [.withFullDate, .withTime, .withTimeZone]
isoFormatter.timeZone = .NewYork
let dateiPodString = isoFormatter.string(from: .iPod)
print(dateiPodString)

isoFormatter.formatOptions = [.withInternetDateTime]
let isoDateString = "2024-02-18T20:00:00+05:00"
if let isoDate = isoFormatter.date(from: isoDateString) {
    print(isoDate)
}

/*:
# DateIntervalFormatter

A formatter that creates string representations of time intervals.

A `DateIntervalFormatter` object creates user-readable strings from pairs of dates. Use a date interval formatter to create user-readable strings of the form <start> - <end> for your app’s interface, where <start> and <end> are date values that you supply. The formatter uses locale and language information, along with custom formatting options, to define the content of the resulting string. You can specify different styles for the date and time information in each date value.

To use this class, create an instance, configure its properties, and call the `string(from:to:)` method to generate a string. The properties of this class let you configure the calendar and specify the style to apply to date and time values. Given a current date of January 16, 2015, Configuring the Formatter Options shows how to configure a formatter object and generate the string “1/16/15 - 1/17/15”.

[Apple Documentation](https://developer.apple.com/documentation/foundation/dateintervalformatter)
 */

print()
print("DateIntervalFormatter")
print("=====================")

let intervalFormatter = DateIntervalFormatter()
intervalFormatter.locale = selectedLocale

print("Date     Time\n")

let fromDate: Date = .VisionPro
let toDateDays = Calendar.current.date(byAdding: .day, value: 7, to: fromDate)!
let toDateMinutes = Calendar.current.date(byAdding: .minute, value: 126, to: fromDate)!

intervalFormatter.dateStyle = .none
intervalFormatter.timeStyle = .none
let intervalNoneNone = intervalFormatter.string(from: fromDate, to: toDateDays)
print("none     none     ", intervalNoneNone)
let intervalMNoneNone = intervalFormatter.string(from: fromDate, to: toDateMinutes)
print("                  ", intervalMNoneNone)

intervalFormatter.dateStyle = .short
intervalFormatter.timeStyle = .none
let intervalShortNone = intervalFormatter.string(from: fromDate, to: toDateDays)
print("short    none     ", intervalShortNone)
let intervalMShortNone = intervalFormatter.string(from: fromDate, to: toDateMinutes)
print("                  ", intervalMShortNone)

intervalFormatter.dateStyle = .medium
intervalFormatter.timeStyle = .none
let intervalMediumNone = intervalFormatter.string(from: fromDate, to: toDateDays)
print("medium   none     ", intervalMediumNone)
let intervalMMediumNone = intervalFormatter.string(from: fromDate, to: toDateMinutes)
print("                  ", intervalMMediumNone)

intervalFormatter.dateStyle = .long
intervalFormatter.timeStyle = .none
let intervalLongNone = intervalFormatter.string(from: fromDate, to: toDateDays)
print("long     none     ", intervalLongNone)
let intervalMLongNone = intervalFormatter.string(from: fromDate, to: toDateMinutes)
print("                  ", intervalMLongNone)

intervalFormatter.dateStyle = .full
intervalFormatter.timeStyle = .none
let intervalFullNone = intervalFormatter.string(from: fromDate, to: toDateDays)
print("full     none     ", intervalFullNone)
let intervalMFullNone = intervalFormatter.string(from: fromDate, to: toDateMinutes)
print("                  ", intervalMFullNone)

print()

intervalFormatter.dateStyle = .none
intervalFormatter.timeStyle = .short
let intervalNoneShort = intervalFormatter.string(from: fromDate, to: toDateDays)
print("none     short    ", intervalNoneShort)
let intervalMNoneShort = intervalFormatter.string(from: fromDate, to: toDateMinutes)
print("                  ", intervalMNoneShort)

intervalFormatter.dateStyle = .short
intervalFormatter.timeStyle = .short
let intervalShortShort = intervalFormatter.string(from: fromDate, to: toDateDays)
print("short    short    ", intervalShortShort)
let intervalMShortShort = intervalFormatter.string(from: fromDate, to: toDateMinutes)
print("                  ", intervalMShortShort)

intervalFormatter.dateStyle = .medium
intervalFormatter.timeStyle = .short
let intervalMediumShort = intervalFormatter.string(from: fromDate, to: toDateDays)
print("medium   short    ", intervalMediumShort)
let intervalMMediumShort = intervalFormatter.string(from: fromDate, to: toDateMinutes)
print("                  ", intervalMMediumShort)

intervalFormatter.dateStyle = .long
intervalFormatter.timeStyle = .short
let intervalLongShort = intervalFormatter.string(from: fromDate, to: toDateDays)
print("long     short    ", intervalLongShort)
let intervalMLongShort = intervalFormatter.string(from: fromDate, to: toDateMinutes)
print("                  ", intervalMLongShort)

intervalFormatter.dateStyle = .full
intervalFormatter.timeStyle = .short
let intervalFullShort = intervalFormatter.string(from: fromDate, to: toDateDays)
print("full     short    ", intervalFullShort)
let intervalMFullShort = intervalFormatter.string(from: fromDate, to: toDateMinutes)
print("                  ", intervalMFullShort)

print()

intervalFormatter.dateStyle = .none
intervalFormatter.timeStyle = .medium
let intervalNoneMedium = intervalFormatter.string(from: fromDate, to: toDateDays)
print("none     medium   ", intervalNoneMedium)
let intervalMNoneMedium = intervalFormatter.string(from: fromDate, to: toDateMinutes)
print("                  ", intervalMNoneMedium)

intervalFormatter.dateStyle = .short
intervalFormatter.timeStyle = .medium
let intervalShortMedium = intervalFormatter.string(from: fromDate, to: toDateDays)
print("short    medium   ", intervalShortMedium)
let intervalMShortMedium = intervalFormatter.string(from: fromDate, to: toDateMinutes)
print("                  ", intervalMShortMedium)

intervalFormatter.dateStyle = .medium
intervalFormatter.timeStyle = .medium
let intervalMediumMedium = intervalFormatter.string(from: fromDate, to: toDateDays)
print("medium   medium   ", intervalMediumMedium)
let intervalMMediumMedium = intervalFormatter.string(from: fromDate, to: toDateMinutes)
print("                  ", intervalMMediumMedium)

intervalFormatter.dateStyle = .long
intervalFormatter.timeStyle = .medium
let intervalLongMedium = intervalFormatter.string(from: fromDate, to: toDateDays)
print("long     medium   ", intervalLongMedium)
let intervalMLongMedium = intervalFormatter.string(from: fromDate, to: toDateMinutes)
print("                  ", intervalMLongMedium)

intervalFormatter.dateStyle = .full
intervalFormatter.timeStyle = .medium
let intervalFullMedium = intervalFormatter.string(from: fromDate, to: toDateDays)
print("full     medium   ", intervalFullMedium)
let intervalMFullMedium = intervalFormatter.string(from: fromDate, to: toDateMinutes)
print("                  ", intervalMFullMedium)

print()

intervalFormatter.dateStyle = .none
intervalFormatter.timeStyle = .long
let intervalNoneLong = intervalFormatter.string(from: fromDate, to: toDateDays)
print("none     long     ", intervalNoneLong)
let intervalMNoneLong = intervalFormatter.string(from: fromDate, to: toDateMinutes)
print("                  ", intervalMNoneLong)

intervalFormatter.dateStyle = .short
intervalFormatter.timeStyle = .long
let intervalShortLong = intervalFormatter.string(from: fromDate, to: toDateDays)
print("short    long     ", intervalShortLong)
let intervalMShortLong = intervalFormatter.string(from: fromDate, to: toDateMinutes)
print("                  ", intervalMShortLong)

intervalFormatter.dateStyle = .medium
intervalFormatter.timeStyle = .long
let intervalMediumLong = intervalFormatter.string(from: fromDate, to: toDateDays)
print("medium   long     ", intervalMediumLong)
let intervalMMediumLong = intervalFormatter.string(from: fromDate, to: toDateMinutes)
print("                  ", intervalMMediumLong)

intervalFormatter.dateStyle = .long
intervalFormatter.timeStyle = .long
let intervalLongLong = intervalFormatter.string(from: fromDate, to: toDateDays)
print("long     long     ", intervalLongLong)
let intervalMLongLong = intervalFormatter.string(from: fromDate, to: toDateMinutes)
print("                  ", intervalMLongLong)

intervalFormatter.dateStyle = .full
intervalFormatter.timeStyle = .long
let intervalFullLong = intervalFormatter.string(from: fromDate, to: toDateDays)
print("full     long     ", intervalFullLong)
let intervalMFullLong = intervalFormatter.string(from: fromDate, to: toDateMinutes)
print("                  ", intervalMFullLong)

print()

intervalFormatter.dateStyle = .none
intervalFormatter.timeStyle = .full
let intervalNoneFull = intervalFormatter.string(from: fromDate, to: toDateDays)
print("none     full     ", intervalNoneFull)
let intervalMNoneFull = intervalFormatter.string(from: fromDate, to: toDateMinutes)
print("                  ", intervalMNoneFull)

intervalFormatter.dateStyle = .short
intervalFormatter.timeStyle = .full
let intervalShortFull = intervalFormatter.string(from: fromDate, to: toDateDays)
print("short    full     ", intervalShortFull)
let intervalMShortFull = intervalFormatter.string(from: fromDate, to: toDateMinutes)
print("                  ", intervalMShortFull)

intervalFormatter.dateStyle = .medium
intervalFormatter.timeStyle = .full
let intervalMediumFull = intervalFormatter.string(from: fromDate, to: toDateDays)
print("medium   full     ", intervalMediumFull)
let intervalMMediumFull = intervalFormatter.string(from: fromDate, to: toDateMinutes)
print("                  ", intervalMMediumFull)

intervalFormatter.dateStyle = .long
intervalFormatter.timeStyle = .full
let intervalLongFull = intervalFormatter.string(from: fromDate, to: toDateDays)
print("long     full     ", intervalLongFull)
let intervalMLongFull = intervalFormatter.string(from: fromDate, to: toDateMinutes)
print("                  ", intervalMLongFull)

intervalFormatter.dateStyle = .full
intervalFormatter.timeStyle = .full
let intervalFullFull = intervalFormatter.string(from: fromDate, to: toDateDays)
print("full     full     ", intervalFullFull)
let intervalMFullFull = intervalFormatter.string(from: fromDate, to: toDateMinutes)
print("                  ", intervalMFullFull)

/*:
# DateComponentsFormatter

A formatter that creates string representations of quantities of time.

An `DateComponentsFormatter` object takes quantities of time and formats them as a user-readable string. Use a date components formatter to create strings for your app’s interface. The formatter object has many options for creating both abbreviated and expanded strings. The formatter takes the current user’s locale and language into account when generating strings.

To use this class, create an instance, configure its properties, and call one of its methods to generate an appropriate string. The properties of this class let you configure the calendar and specify the date and time units you want displayed in the resulting string. Listing 1 shows how to configure a formatter to create the string “About 5 minutes remaining”.

[Apple Documentation](https://developer.apple.com/documentation/foundation/datecomponentsformatter)
 */

print()
print("DateComponentsFormatter\n=======================")

let componentsFormatter = DateComponentsFormatter()
let components = DateComponents(day: 1, hour: 2, minute: 3)

//componentsFormatter.formattingContext = .standalone

componentsFormatter.unitsStyle = .positional
if let string = componentsFormatter.string(from: components) {
    print("positional    ", string)
}

componentsFormatter.unitsStyle = .abbreviated
if let string = componentsFormatter.string(from: components) {
    print("abbreviated   ", string)
}

componentsFormatter.unitsStyle = .short
if let string = componentsFormatter.string(from: components) {
    print("short         ", string)
}

componentsFormatter.unitsStyle = .full
if let string = componentsFormatter.string(from: components) {
    print("full          ", string)
}

componentsFormatter.unitsStyle = .spellOut
if let string = componentsFormatter.string(from: components) {
    print("spellOut      ", string)
}

componentsFormatter.unitsStyle = .brief
if let string = componentsFormatter.string(from: components) {
    print("brief         ", string)
}

print()
let timeInterval1 = TimeInterval(3662) // 1 hour, 1 minute, and 2 seconds
componentsFormatter.unitsStyle = .full
if let formattedString = componentsFormatter.string(from: timeInterval1) {
    print("TimeInterval: ", formattedString)
}

let timeHours2 = 3 * 60 * 60
let timeMins2 = 15 * 60
let timeComplete2 = timeHours2 + timeMins2
let timeInterval2 = TimeInterval(timeComplete2) // 3 hours, 15 minutes
componentsFormatter.unitsStyle = .abbreviated
if let formattedString = componentsFormatter.string(from: timeInterval2) {
    print("              ", formattedString)
}

let timeDays3 = 10 * 24 * 60 * 60
let timeHours3 = 5 * 60 * 60
let timeComplete3 = timeDays3 + timeHours3
let timeInterval3 = TimeInterval(timeComplete3) // 10 days, 5 hours
componentsFormatter.unitsStyle = .abbreviated
componentsFormatter.maximumUnitCount = 2
componentsFormatter.includesApproximationPhrase = true
componentsFormatter.includesTimeRemainingPhrase = true
if let formattedString = componentsFormatter.string(from: timeInterval3) {
    print("              ", formattedString)
}

/*:
# RelativeDateTimeFormatter

A formatter that creates locale-aware string representations of a relative date or time.

Use the strings that the formatter produces, such as “1 hour ago”, “in 2 weeks”, “yesterday”, and “tomorrow” as standalone strings. Embedding them in other strings may not be grammatically correct.

[Apple Documnetation](https://developer.apple.com/documentation/foundation/relativedatetimeformatter/)
 */

let relativeFormatter = RelativeDateTimeFormatter()
relativeFormatter.locale = selectedLocale

print()
print("RelativeDateTimeFormatter\n=========================")

let relative1 = relativeFormatter.localizedString(from: DateComponents(day: 1, hour: 1)) // "in 1 day"
print(relative1)
let relative2 = relativeFormatter.localizedString(from: DateComponents(day: -1)) // "1 day ago"
print(relative2)
let relative3 = relativeFormatter.localizedString(from: DateComponents(hour: 3)) // "in 3 hours"
print(relative3)
let relative4 = relativeFormatter.localizedString(from: DateComponents(minute: 60)) // "in 60 minutes"
print(relative4)

// bad formatters
print("\nBut formatters are not perfect:")
let relative5 = relativeFormatter.localizedString(from: DateComponents(hour: 0)) // "in 0 hours"
print(relative5)
let relative6 = relativeFormatter.localizedString(from: DateComponents(day: 1, hour: -24)) // "in 1 day"
print(relative6)
let relative7 = relativeFormatter.localizedString(from: DateComponents()) // ""
print(relative7)

// Styles
print()

relativeFormatter.unitsStyle = .abbreviated
let relativeAbbreviated = relativeFormatter.localizedString(from: DateComponents(month: -1))
print("Abbreviated:   ", relativeAbbreviated)

relativeFormatter.unitsStyle = .short
let relativeShort = relativeFormatter.localizedString(from: DateComponents(month: -1))
print("Short:         ", relativeShort)

relativeFormatter.unitsStyle = .full
let relativeFull = relativeFormatter.localizedString(from: DateComponents(month: -1))
print("Full:          ", relativeFull)

relativeFormatter.unitsStyle = .spellOut
let relativeSpellOut = relativeFormatter.localizedString(from: DateComponents(month: -1))
print("Spell Out:     ", relativeSpellOut)

// Using Named Relative Date Times
print()

relativeFormatter.unitsStyle = .full

relativeFormatter.dateTimeStyle = .numeric
let dtStyleNumeric = relativeFormatter.localizedString(from: DateComponents(day: -1))
print("Numeric:   ", dtStyleNumeric)

relativeFormatter.dateTimeStyle = .named

let dtStyleNamed1 = relativeFormatter.localizedString(from: DateComponents(day: -1))
print("Named:     ", dtStyleNamed1)

let dtStyleNamed2 = relativeFormatter.localizedString(from: DateComponents(day: -2))
print("           ", dtStyleNamed2)

let dtStyleNamed3 = relativeFormatter.localizedString(from: DateComponents(day: 1))
print("           ", dtStyleNamed3)

let dtStyleNamed4 = relativeFormatter.localizedString(from: DateComponents(day: 2))
print("           ", dtStyleNamed4)

print()

relativeFormatter.formattingContext = .beginningOfSentence

relativeFormatter.dateTimeStyle = .numeric
let dtStyleNumericM = relativeFormatter.localizedString(from: DateComponents(month: -1))
print("Numeric:   ", dtStyleNumericM)

relativeFormatter.dateTimeStyle = .named

let dtStyleNamedM1 = relativeFormatter.localizedString(from: DateComponents(month: -1))
print("Named:     ", dtStyleNamedM1)

let dtStyleNamedM2 = relativeFormatter.localizedString(from: DateComponents(month: -2))
print("           ", dtStyleNamedM2)

let dtStyleNamedM3 = relativeFormatter.localizedString(from: DateComponents(month: 1))
print("           ", dtStyleNamedM3)

let dtStyleNamedM4 = relativeFormatter.localizedString(from: DateComponents(month: 2))
print("           ", dtStyleNamedM4)
