import Foundation
import Contacts

/*:
# PersonNameComponentsFormatter

The `PersonNameComponentsFormatter` is a powerful tool in Swift for formatting personal names according to locale-specific conventions. It can handle names consisting of various components like given name, family name, middle name, prefix, suffix, and nickname, ensuring they are presented in a way that respects cultural norms.
 */

print("PersonNameComponentsFormatter")
print("=============================")

let personFormatter = PersonNameComponentsFormatter()
var personNameComponents = PersonNameComponents()

personNameComponents.givenName = "Steve"
personNameComponents.familyName = "Jobs"

personFormatter.style = .default
print(personFormatter.string(from: personNameComponents))

personFormatter.style = .short
print(personFormatter.string(from: personNameComponents))

personFormatter.style = .abbreviated
print(personFormatter.string(from: personNameComponents))

print()

var marieNameComponents = PersonNameComponents()
marieNameComponents.namePrefix = "Dr."
marieNameComponents.givenName = "Maria"
marieNameComponents.middleName = "Salomea"
marieNameComponents.familyName = "Skłodowska-Curie"
marieNameComponents.nameSuffix = "PhD"
marieNameComponents.nickname = "Marie Curie"

personFormatter.style = .default
print(personFormatter.string(from: marieNameComponents))

personFormatter.style = .short
print(personFormatter.string(from: marieNameComponents))

personFormatter.style = .medium
print(personFormatter.string(from: marieNameComponents))

personFormatter.style = .long
print(personFormatter.string(from: marieNameComponents))

personFormatter.style = .abbreviated
print(personFormatter.string(from: marieNameComponents))

print()

var phoneticNameComponents = PersonNameComponents()
phoneticNameComponents.namePrefix = "Doktor"
phoneticNameComponents.givenName = "Mah-ree-ah"
phoneticNameComponents.middleName = "Sal-oh-may-ah"
phoneticNameComponents.familyName = "Skwo-dovs-ka Kyoo-ree"
phoneticNameComponents.nameSuffix = "Pee Aych Dee"
phoneticNameComponents.nickname = "Muh-ree Kyoo-ree"

marieNameComponents.phoneticRepresentation = phoneticNameComponents

personFormatter.isPhonetic = true

personFormatter.style = .default
print(personFormatter.string(from: marieNameComponents))

personFormatter.style = .short
print(personFormatter.string(from: marieNameComponents))

personFormatter.style = .medium
print(personFormatter.string(from: marieNameComponents))

personFormatter.style = .long
print(personFormatter.string(from: marieNameComponents))

//: Please note that `.abbreviated` style has issues with phonetic representation.

personFormatter.isPhonetic = false

print()

var japaneseNameComponets = PersonNameComponents()
japaneseNameComponets.givenName = "太郎" // Tarō
japaneseNameComponets.familyName = "山田" // Yamada

personFormatter.style = .default
print(personFormatter.string(from: japaneseNameComponets))

personFormatter.style = .abbreviated
print(personFormatter.string(from: japaneseNameComponets))

/*:
# CNPostalAddressFormatter

`CNPostalAddressFormatter` is a class provided by the Contacts framework in iOS and macOS, used for formatting postal addresses. It takes a `CNPostalAddress` object, which contains components of a postal address such as street, city, state, postal code, country, and more, and returns a localized string representation of the address. This formatted string is suitable for display to the user or for use in mailing labels, respecting the formatting conventions of the specified locale.
 */

print()
print("CNPostalAddressFormatter")
print("========================")

let addressFormatter = CNPostalAddressFormatter()
addressFormatter.style = .mailingAddress

let appleParkAddress = CNMutablePostalAddress()
appleParkAddress.street = "1 Apple Park Way"
appleParkAddress.city = "Cupertino"
appleParkAddress.state = "CA"
appleParkAddress.postalCode = "95014"
appleParkAddress.country = "United States"
appleParkAddress.subLocality = "" // neighborhood or district
appleParkAddress.subAdministrativeArea = "Santa Clara"
appleParkAddress.isoCountryCode = "US"

print("Apple Park:")
print(addressFormatter.string(from: appleParkAddress))

let museoPradoAddress = CNMutablePostalAddress()
museoPradoAddress.street = "Calle de Ruiz de Alarcón, 23"
museoPradoAddress.city = "Madrid"
museoPradoAddress.postalCode = "28014"
museoPradoAddress.country = "España"

print()

print("Museo Nacional del Prado:")
print(addressFormatter.string(from: museoPradoAddress))
