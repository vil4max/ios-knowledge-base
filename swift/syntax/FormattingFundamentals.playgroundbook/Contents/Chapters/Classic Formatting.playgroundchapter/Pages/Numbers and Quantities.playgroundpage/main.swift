import Foundation

let selectedLocale: Locale = .americanEnglish
print("Locale: " + selectedLocale.description + "\n")

/*:
# NumberFormatter

A formatter that converts between numeric values and their textual representations.

Instances of `NumberFormatter` format the textual representation of cells that contain `NSNumber` objects and convert textual representations of numeric values into `NSNumber` objects. The representation encompasses integers, floats, and doubles; floats and doubles can be formatted to a specified decimal position. `NumberFormatter` objects can also impose ranges on the numeric values cells can accept.

The `NumberFormatter` is a fundamental tool in Swift for converting numeric values into localized string representations. It supports a variety of number styles, including decimal, currency, percent, and more, making it incredibly versatile for different use cases.

[Apple Documentation](https://developer.apple.com/documentation/foundation/numberformatter)
 */
var numberFormatter = NumberFormatter()
numberFormatter.locale = selectedLocale

print("NumberFormatter Styles")
print("======================")

// No style is applied to the number.
numberFormatter.numberStyle = .none
if let none = numberFormatter.string(from: 123456) {
    print(".none                 " + none)
}

// Formats numbers as decimal numbers, according to the locale's rules. This includes the grouping separator.
numberFormatter.numberStyle = .decimal
if let decimal = numberFormatter.string(from: 12345.67890) {
    print(".decimal              " + decimal)
}

// Formats numbers as percentages, automatically multiplying by 100 and displaying the percent symbol.
numberFormatter.numberStyle = .percent
if let percent = numberFormatter.string(from: 0.12) {
    print(".percent              " + percent)
}

// Formats numbers in scientific notation, e.g., 1.23E3 for 1230.
numberFormatter.numberStyle = .scientific
if let scientific = numberFormatter.string(from: 12345.6789) {
    print(".scientific           " + scientific)
}

// Spells out the number in words, according to the locale's rules.
numberFormatter.numberStyle = .spellOut
if let spellOut = numberFormatter.string(from: 123) {
    print(".spellOut             " + spellOut)
}

// Formats numbers as ordinal numbers, e.g., 1st, 2nd, 3rd in English.
numberFormatter.numberStyle = .ordinal
if let ordinal = numberFormatter.string(from: 3) {
    print(".ordinal              " + ordinal)
}

// Formats numbers as currency, including the currency symbol according to the locale.
numberFormatter.numberStyle = .currency
if let currency = numberFormatter.string(from: 1234.5678) {
    print(".currency             " + currency)
}

// Formats numbers in the accounting style for currency, which may vary in presentation from .currency, especially regarding how negative values are displayed.
numberFormatter.numberStyle = .currencyAccounting
if let currencyAccounting = numberFormatter.string(from: -1234.5678) {
    print(".currencyAccounting   " + currencyAccounting)
}

// Formats numbers as currency, using the ISO currency code, e.g., "USD" for US Dollars.
numberFormatter.numberStyle = .currencyISOCode
if let currencyISOCode = numberFormatter.string(from: 1234.5678) {
    print(".currencyISOCode      " + currencyISOCode)
}

// Formats numbers as currency, using the plural form of the currency name, e.g., "US dollars".
numberFormatter.numberStyle = .currencyPlural
if let currencyPlural = numberFormatter.string(from: 1234.5678) {
    print(".currencyPlural       " + currencyPlural)
}

// Custom format for currency
numberFormatter.numberStyle = .currency
numberFormatter.currencyCode = "EUR"
numberFormatter.currencySymbol = "€"
numberFormatter.internationalCurrencySymbol = "EUR"
numberFormatter.currencyDecimalSeparator = ";"
numberFormatter.currencyGroupingSeparator = "-"
if let currencyCustom = numberFormatter.string(from: 1234567.89) {
    print()
    print("Custom format         " + currencyCustom)
}

print()
print("Rounding & Significant Digits")
print("=============================")

var significantFormatter = NumberFormatter()
significantFormatter.locale = selectedLocale

significantFormatter.usesSignificantDigits = true
significantFormatter.minimumSignificantDigits = 1 // default
significantFormatter.maximumSignificantDigits = 6 // default

if let number = significantFormatter.string(from: 123456789) {
    print(number)
}
if let number = significantFormatter.string(from: 1234.56789) {
    print(number)
}
if let number = significantFormatter.string(from: 100.23456789) {
    print(number)
}
if let number = significantFormatter.string(from: 1.23000) {
    print(number)
}
if let number = significantFormatter.string(from: 0.0000123) {
    print(number)
}

print()

significantFormatter.usesSignificantDigits = false // default
significantFormatter.minimumIntegerDigits = 0 // default
significantFormatter.maximumIntegerDigits = 42 // default
significantFormatter.minimumFractionDigits = 0 // default
significantFormatter.maximumFractionDigits = 0 // default

if let number = significantFormatter.string(from: 123456789) {
    print(number)
}
if let number = significantFormatter.string(from: 1234.56789) {
    print(number)
}
if let number = significantFormatter.string(from: 100.23456789) {
    print(number)
}
if let number = significantFormatter.string(from: 1.23000) {
    print(number)
}
if let number = significantFormatter.string(from: 0.0000123) {
    print(number)
}

/*:
## Measurement

A numeric quantity labeled with a unit of measure, with support for unit conversion and unit-aware calculations.

A Measurement object represents a quantity and unit of measure. The Measurement type provides a programmatic interface to converting measurements into different units, as well as calculating the sum or difference between two measurements.

Measurement objects are initialized with a Unit object and double value. Measurement objects are immutable, and cannot be changed after being created.

[Apple Documentation](https://developer.apple.com/documentation/foundation/measurement)

## MeasurementFormatter

A formatter that provides localized representations of units and measurements.

[Apple Documentation](https://developer.apple.com/documentation/foundation/measurementformatter)

Something to take into account is that `ByteCountFormatter`, `EnergyFormatter`, `MassFormatter`, `LengthFormatter`, and `MKDistanceFormatter` are superseded by `MeasurementFormatter`.

The only occasions in which you might still use `EnergyFormatter`, `MassFormatter`, or `LengthFormatter` are when working with the HealthKit framework; these formatters provide conversion and interoperability with `HKUnit` quantities.
 */
print()
print("MeasurementFormatter")
print("====================")

let measurementFormatter = MeasurementFormatter()
measurementFormatter.locale = selectedLocale

measurementFormatter.unitStyle = .medium
//measurementFormatter.numberFormatter.maximumFractionDigits = 1
//measurementFormatter.unitOptions = .providedUnit

// Acceleration
let acceleration = Measurement<UnitAcceleration>(value: 23.4,
                                                 unit: .metersPerSecondSquared)
let accelerationResult = measurementFormatter.string(from: acceleration)
// Convert unit into another unit
let accelerationInGravity = acceleration.converted(to: .gravity)
let accelerationInGravityResult = measurementFormatter.string(from: accelerationInGravity)
print("Acceleration:", accelerationResult, "(", accelerationInGravityResult, ")")

// Planar angle and rotation
let angle = Measurement<UnitAngle>(value: 47.23,
                                   unit: .degrees)
let angleResult = measurementFormatter.string(from: angle)
print("Planar angle and rotation:", angleResult)

// Area
let area = Measurement<UnitArea>(value: 254.02,
                                 unit: .squareMeters)
let areaResult = measurementFormatter.string(from: area)
print("Area:", areaResult)

// Concentration of mass
let concentrationMass = Measurement<UnitConcentrationMass>(value: 430.54,
                                                           unit: .milligramsPerDeciliter)
let concentrationMassResult = measurementFormatter.string(from: concentrationMass)
print("Concentration of mass:", concentrationMassResult)

// Dispersion
let dispersion = Measurement<UnitDispersion>(value: 54,
                                             unit: .partsPerMillion)
let dispersionResult = measurementFormatter.string(from: dispersion)
print("Dispersion:", dispersionResult)

// Duration
let duration = Measurement<UnitDuration>(value: 624,
                                         unit: .seconds)
let durationResult = measurementFormatter.string(from: duration)
print("Duration:", durationResult)

// Electric charge
let electricCharge = Measurement<UnitElectricCharge>(value: 75,
                                                     unit: .milliampereHours)
let electricChargeResult = measurementFormatter.string(from: electricCharge)
print("Electric charge:", electricChargeResult)

// Electric current
let electricCurrent = Measurement<UnitElectricCurrent>(value: 24,
                                                       unit: .amperes)
let electricCurrentResult = measurementFormatter.string(from: electricCurrent)
print("Electric current:", electricCurrentResult)

// Electric potential difference
let electricPotentialDifference = Measurement<UnitElectricPotentialDifference>(value: 12,
                                                                               unit: .volts)
let electricPDResult = measurementFormatter.string(from: electricPotentialDifference)
print("Electric potential difference:", electricPDResult)

// Electric resistance
let electricResistance = Measurement<UnitElectricResistance>(value: 140,
                                                             unit: .ohms)
let electricResistanceResult = measurementFormatter.string(from: electricResistance)
print("Electric resistance:", electricResistanceResult)

// Energy
let energy = Measurement<UnitEnergy>(value: 5500,
                                     unit: .joules)
let energyResult = measurementFormatter.string(from: energy)
print("Energy:", energyResult)

// Frequency
let frequency = Measurement<UnitFrequency>(value: 64,
                                           unit: .hertz)
let frequencyResult = measurementFormatter.string(from: frequency)
print("Frequency:", frequencyResult)

// Fuel consumption
let fuelConsumption = Measurement<UnitFuelEfficiency>(value: 50,
                                                      unit: .litersPer100Kilometers)
let fuelConsumptionResult = measurementFormatter.string(from: fuelConsumption)
print("Fuel consumption:", fuelConsumptionResult)

// Illuminance
let illuminance = Measurement<UnitIlluminance>(value: 8,
                                               unit: .lux)
let illuminanceResult = measurementFormatter.string(from: illuminance)
print("Illuminance:", illuminanceResult)

// Information Storage
let informationStorage = Measurement<UnitInformationStorage>(value: 256,
                                                             unit: .kilobytes)
let informationStorageResult = measurementFormatter.string(from: informationStorage)
print("Information Storage:", informationStorageResult)

// Length
let length = Measurement<UnitLength>(value: 5.72,
                                     unit: .kilometers)
let lengthResult = measurementFormatter.string(from: length)
print("Length:", lengthResult)

// Mass
let mass = Measurement<UnitMass>(value: 74,
                                 unit: .kilograms)
let massResult = measurementFormatter.string(from: mass)
print("Mass:", massResult)

// Power
let power = Measurement<UnitPower>(value: 8,
                                   unit: .kilowatts)
let powerResult = measurementFormatter.string(from: power)
print("Power:", powerResult)

// Pressure
let pressure = Measurement<UnitPressure>(value: 50,
                                         unit: .hectopascals)
let pressureResult = measurementFormatter.string(from: pressure)
print("Pressure:", pressureResult)

// Speed
let speed = Measurement<UnitSpeed>(value: 111.6,
                                   unit: .kilometersPerHour)
let speedResult = measurementFormatter.string(from: speed)
print("Speed:", speedResult)

// Temperature
let temperature = Measurement<UnitTemperature>(value: 24.3,
                                               unit: .celsius)
let temperatureResult = measurementFormatter.string(from: temperature)
print("Temperature:", temperatureResult)

// Volume
let volume = Measurement<UnitVolume>(value: 1.2,
                                     unit: .liters)
let volumeResult = measurementFormatter.string(from: volume)
print("Volume:", volumeResult)
