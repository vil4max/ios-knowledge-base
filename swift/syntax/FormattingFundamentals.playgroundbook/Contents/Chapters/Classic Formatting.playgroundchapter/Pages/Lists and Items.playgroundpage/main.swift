import Foundation

let selectedLocale: Locale = .americanEnglish

/*:
# ListFormatter

The `ListFormatter` is a fantastic tool in Swift for converting arrays of strings into a single, localized string representation. It’s especially useful for displaying lists of items in a way that conforms to the linguistic rules of the user’s locale.
 */

print("ListFormatter")
print("=============")

let operatingSystems = ["iOS", "iPadOS", "macOS", "tvOS", "visionOS", "watchOS"]
let osList = ListFormatter.localizedString(byJoining: operatingSystems)
print(osList)

let emptyList = ListFormatter.localizedString(byJoining: [])
print(emptyList)

let listOfOne = ListFormatter.localizedString(byJoining: ["Apple"])
print(listOfOne)

let listOfTwo = ListFormatter.localizedString(byJoining: ["Jobs", "Woz"])
print(listOfTwo)

// Lists of Formatted Values

let numberFormatter = NumberFormatter()
numberFormatter.locale = selectedLocale

numberFormatter.numberStyle = .ordinal

let listFormatter = ListFormatter()
listFormatter.locale = selectedLocale

listFormatter.itemFormatter = numberFormatter

print()
print("Lists of Formatted Values")
print("=========================")

print("Locale: " + selectedLocale.description + "\n")

if let ordinalList = listFormatter.string(from: [1, 2, 3]) {
    print(ordinalList)
}

let itemList = ["iPhone", "iPad", "Mac", "TV", "Vision", "Watch"]
if let formattedList = listFormatter.string(from: itemList) {
    print(formattedList)
}
