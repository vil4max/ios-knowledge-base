import Foundation

let selectedLocale: Locale = .americanEnglish

print("Lists")
print("=====")

print("Locale: " + selectedLocale.description + "\n")

let beatles = ["John", "Paul", "George", "Ringo"]

print("And             ", beatles.formatted(.list(type: .and).locale(selectedLocale)))
print("And + Narrow    ", beatles.formatted(.list(type: .and, width: .narrow).locale(selectedLocale)))
print("And + Short     ", beatles.formatted(.list(type: .and, width: .short).locale(selectedLocale)))
print("And + Standard  ", beatles.formatted(.list(type: .and, width: .standard).locale(selectedLocale)))
print()

print("Or              ", beatles.formatted(.list(type: .or).locale(selectedLocale)))
print("Or + Narrow     ", beatles.formatted(.list(type: .or, width: .narrow).locale(selectedLocale)))
print("Or + Short      ", beatles.formatted(.list(type: .or, width: .short).locale(selectedLocale)))
print("Or + Standard   ", beatles.formatted(.list(type: .or, width: .standard).locale(selectedLocale)))

print()
print("Items")
print("=====")

let numbersRange = 5201719 ... 5201722

print(numbersRange.formatted(
    .list(memberStyle: IntegerFormatStyle(),
          type: .or,
          width: .standard)
    .locale(selectedLocale)
))
