import Foundation

// Swift 5.5, iOS 15+

let selectedLocale: Locale = .americanEnglish
print("Locale: " + selectedLocale.description)
let selectedCurrency: String = .usDollar
print("Currency: " + selectedCurrency.description)
print()

print("Numbers")
print("=======")

let number1 = 74230.formatted(.number.locale(selectedLocale))
print(number1)
let number2 = 74_230.formatted(.number.grouping(.never).locale(selectedLocale))
print(number2)

print()
let decimals1 = 0.25.formatted(.number.locale(selectedLocale))
print(decimals1)
let decimals2 = 0.4.formatted(.number.precision(.significantDigits(2)).locale(selectedLocale))
print(decimals2)
let decimals3 = Double.pi.formatted(.number.precision(.fractionLength(4)).locale(selectedLocale))
print(decimals3)
let decimals4 = Double.pi.formatted(.number.precision(.integerAndFractionLength(integer: 3, fraction: 3)).locale(selectedLocale))
print(decimals4)
let decimals5 = 4123.2270.formatted(.number.precision(.integerLength(2)).locale(selectedLocale))
print(decimals5)

print()
let notation1 = 20_270_094.formatted(.number.notation(.compactName).locale(selectedLocale))
print(notation1)
let notation2 = 20_000_000.formatted(.number.notation(.compactName).locale(selectedLocale))
print(notation2)
let notation3 = 20_000_000_000.formatted(.number.notation(.compactName).locale(selectedLocale))
print(notation3)

print()
let sign1 = (4923+726).formatted(.number.sign(strategy: .always()).locale(selectedLocale))
print(sign1)
let sign2 = (204-723).formatted(.number.sign(strategy: .always()).locale(selectedLocale))
print(sign2)
let sign3 = 0.formatted(.number.sign(strategy: .always()).locale(selectedLocale))
print(sign3)
let sign4 = 0.formatted(.number.sign(strategy: .always(includingZero: false)).locale(selectedLocale))
print(sign4)

print()
let scientific1 = 20_000.formatted(.number.notation(.scientific).locale(selectedLocale))
print(scientific1)
let scientific2 = 20_000_000.formatted(.number.notation(.scientific).locale(selectedLocale))
print(scientific2)
let scientific3 = 20_500_000.formatted(.number.notation(.scientific).locale(selectedLocale))
print(scientific3)

print()
let percent1 = 0.85.formatted(.percent.locale(selectedLocale))
print(percent1)
let percent2 = 0.85.formatted(.percent.precision(.fractionLength(2)).locale(selectedLocale))
print(percent2)
let percent3 = 0.327.formatted(.percent.locale(selectedLocale))
print(percent3)

print()
print("Byte Count")
print("==========")

let size = 1_845_200_876
let sizeMemory = size.formatted(.byteCount(style: .memory).locale(selectedLocale))
print(sizeMemory)
let sizeDecimal = size.formatted(.byteCount(style: .decimal).locale(selectedLocale))
print(sizeDecimal)
let sizeMore = size.formatted(.byteCount(style: .memory,
  allowedUnits: .all, spellsOutZero: true,
  includesActualByteCount: true).locale(selectedLocale))
print(sizeMore)

print()
print("Currency ISO-4217")
print("=================")

let currency1 = 3_650.formatted(.currency(code: selectedCurrency).locale(selectedLocale))
print(currency1)

let currency2 = 1_520.72.formatted(.currency(code: selectedCurrency).locale(selectedLocale))
print(currency2)

let currency3 = 3_500.formatted(.currency(code: selectedCurrency).locale(selectedLocale))
print(currency3)

let currency4 = 10_500.formatted(.currency(code: selectedCurrency).locale(selectedLocale))
print(currency4)

let currency5 = 650.formatted(.currency(code: selectedCurrency).locale(selectedLocale))
print(currency5)

let currency6 = 35_490.formatted(.currency(code: selectedCurrency).locale(selectedLocale))
print(currency6)

print()
print("Measurement")
print("===========")

// Acceleration
let acceleration = Measurement<UnitAcceleration>(value: 23.4,
                                                 unit: .metersPerSecondSquared)
let accelerationNarrow = acceleration.formatted(.measurement(width: .narrow).locale(selectedLocale))
let accelerationAbbreviated = acceleration.formatted(.measurement(width: .abbreviated).locale(selectedLocale))
let accelerationWide = acceleration.formatted(.measurement(width: .wide).locale(selectedLocale))
print("Acceleration: " + accelerationNarrow)
print("              " + accelerationAbbreviated)
print("              " + accelerationWide)

// Planar angle and rotation
let angle = Measurement<UnitAngle>(value: 47.23,
                                   unit: .degrees)
let angleNarrow = angle.formatted(.measurement(width: .narrow).locale(selectedLocale))
let angleAbbreviated = angle.formatted(.measurement(width: .abbreviated).locale(selectedLocale))
let angleWide = angle.formatted(.measurement(width: .wide).locale(selectedLocale))
print("Planar angle and rotation: " + angleNarrow)
print("                           " + angleAbbreviated)
print("                           " + angleWide)

// Area
let area = Measurement<UnitArea>(value: 254.02,
                                 unit: .squareMeters)
let areaNarrow = area.formatted(.measurement(width: .narrow).locale(selectedLocale))
let areaAbbreviated = area.formatted(.measurement(width: .abbreviated).locale(selectedLocale))
let areaWide = area.formatted(.measurement(width: .wide).locale(selectedLocale))
print("Area: " + areaNarrow)
print("      " + areaAbbreviated)
print("      " + areaWide)

// Concentration of mass
let concentrationMass = Measurement<UnitConcentrationMass>(value: 430.54,
                                                           unit: .milligramsPerDeciliter)
let concentrationMassNarrow = concentrationMass.formatted(.measurement(width: .narrow).locale(selectedLocale))
let concentrationMassAbbreviated = concentrationMass.formatted(.measurement(width: .abbreviated).locale(selectedLocale))
let concentrationMassWide = concentrationMass.formatted(.measurement(width: .wide).locale(selectedLocale))
print("Concentration of mass: " + concentrationMassNarrow)
print("                       " + concentrationMassAbbreviated)
print("                       " + concentrationMassWide)

// Dispersion
let dispersion = Measurement<UnitDispersion>(value: 54,
                                             unit: .partsPerMillion)
let dispersionNarrow = dispersion.formatted(.measurement(width: .narrow).locale(selectedLocale))
let dispersionAbbreviated = dispersion.formatted(.measurement(width: .abbreviated).locale(selectedLocale))
let dispersionWide = dispersion.formatted(.measurement(width: .wide).locale(selectedLocale))
print("Dispersion: " + dispersionNarrow)
print("            " + dispersionAbbreviated)
print("            " + dispersionWide)

// Duration
let duration = Measurement<UnitDuration>(value: 624,
                                         unit: .seconds)
let durationNarrow = duration.formatted(.measurement(width: .narrow).locale(selectedLocale))
let durationAbbreviated = duration.formatted(.measurement(width: .abbreviated).locale(selectedLocale))
let durationWide = duration.formatted(.measurement(width: .wide).locale(selectedLocale))
print("Duration: " + durationNarrow)
print("          " + durationAbbreviated)
print("          " + durationWide)

// Electric charge
let electricCharge = Measurement<UnitElectricCharge>(value: 75,
                                                     unit: .milliampereHours)
let electricChargeNarrow = electricCharge.formatted(.measurement(width: .narrow).locale(selectedLocale))
let electricChargeAbbreviated = electricCharge.formatted(.measurement(width: .abbreviated).locale(selectedLocale))
let electricChargeWide = electricCharge.formatted(.measurement(width: .wide).locale(selectedLocale))
print("Electric charge: " + electricChargeNarrow)
print("                 " + electricChargeAbbreviated)
print("                 " + electricChargeWide)

// Electric current
let electricCurrent = Measurement<UnitElectricCurrent>(value: 24,
                                                       unit: .amperes)
let electricCurrentNarrow = electricCurrent.formatted(.measurement(width: .narrow).locale(selectedLocale))
let electricCurrentAbbreviated = electricCurrent.formatted(.measurement(width: .abbreviated).locale(selectedLocale))
let electricCurrentWide = electricCurrent.formatted(.measurement(width: .wide).locale(selectedLocale))
print("Electric current: " + electricCurrentNarrow)
print("                  " + electricCurrentAbbreviated)
print("                  " + electricCurrentWide)

// Electric potential difference
let electricPotentialDifference = Measurement<UnitElectricPotentialDifference>(value: 12,
                                                                               unit: .volts)
let electricPotentialDifferenceNarrow = electricPotentialDifference.formatted(.measurement(width: .narrow).locale(selectedLocale))
let electricPotentialDifferenceAbbreviated = electricPotentialDifference.formatted(.measurement(width: .abbreviated).locale(selectedLocale))
let electricPotentialDifferenceWide = electricPotentialDifference.formatted(.measurement(width: .wide).locale(selectedLocale))
print("Electric potential difference: " + electricPotentialDifferenceNarrow)
print("                               " + electricPotentialDifferenceAbbreviated)
print("                               " + electricPotentialDifferenceWide)

// Electric resistance
let electricResistance = Measurement<UnitElectricResistance>(value: 140,
                                                             unit: .ohms)
let electricResistanceNarrow = electricResistance.formatted(.measurement(width: .narrow).locale(selectedLocale))
let electricResistanceAbbreviated = electricResistance.formatted(.measurement(width: .abbreviated).locale(selectedLocale))
let electricResistanceWide = electricResistance.formatted(.measurement(width: .wide).locale(selectedLocale))
print("Electric resistance: " + electricResistanceNarrow)
print("                     " + electricResistanceAbbreviated)
print("                     " + electricResistanceWide)

// Energy
let energy = Measurement<UnitEnergy>(value: 5500,
                                     unit: .joules)
let energyNarrow = energy.formatted(.measurement(width: .narrow).locale(selectedLocale))
let energyAbbreviated = energy.formatted(.measurement(width: .abbreviated).locale(selectedLocale))
let energyWide = energy.formatted(.measurement(width: .wide).locale(selectedLocale))
print("Energy: " + energyNarrow)
print("        " + energyAbbreviated)
print("        " + energyWide)

// Frequency
let frequency = Measurement<UnitFrequency>(value: 64,
                                           unit: .hertz)
let frequencyNarrow = frequency.formatted(.measurement(width: .narrow).locale(selectedLocale))
let frequencyAbbreviated = frequency.formatted(.measurement(width: .abbreviated).locale(selectedLocale))
let frequencyWide = frequency.formatted(.measurement(width: .wide).locale(selectedLocale))
print("Frequency: " + frequencyNarrow)
print("           " + frequencyAbbreviated)
print("           " + frequencyWide)

// Fuel consumption
let fuelConsumption = Measurement<UnitFuelEfficiency>(value: 50,
                                                      unit: .litersPer100Kilometers)
let fuelConsumptionNarrow = fuelConsumption.formatted(.measurement(width: .narrow).locale(selectedLocale))
let fuelConsumptionAbbreviated = fuelConsumption.formatted(.measurement(width: .abbreviated).locale(selectedLocale))
let fuelConsumptionWide = fuelConsumption.formatted(.measurement(width: .wide).locale(selectedLocale))
print("Fuel consumption: " + fuelConsumptionNarrow)
print("                  " + fuelConsumptionAbbreviated)
print("                  " + fuelConsumptionWide)

// Illuminance
let illuminance = Measurement<UnitIlluminance>(value: 8,
                                               unit: .lux)
let illuminanceNarrow = illuminance.formatted(.measurement(width: .narrow).locale(selectedLocale))
let illuminanceAbbreviated = illuminance.formatted(.measurement(width: .abbreviated).locale(selectedLocale))
let illuminanceWide = illuminance.formatted(.measurement(width: .wide).locale(selectedLocale))
print("Illuminance: " + illuminanceNarrow)
print("             " + illuminanceAbbreviated)
print("             " + illuminanceWide)

// Information Storage
let informationStorage = Measurement<UnitInformationStorage>(value: 256,
                                                             unit: .kilobytes)
let informationStorageNarrow = informationStorage.formatted(.measurement(width: .narrow).locale(selectedLocale))
let informationStorageAbbreviated = informationStorage.formatted(.measurement(width: .abbreviated).locale(selectedLocale))
let informationStorageWide = informationStorage.formatted(.measurement(width: .wide).locale(selectedLocale))
print("Information Storage: " + informationStorageNarrow)
print("                     " + informationStorageAbbreviated)
print("                     " + informationStorageWide)

// Length
let length = Measurement<UnitLength>(value: 5.72,
                                     unit: .kilometers)
let lengthNarrow = length.formatted(.measurement(width: .narrow).locale(selectedLocale))
let lengthAbbreviated = length.formatted(.measurement(width: .abbreviated).locale(selectedLocale))
let lengthWide = length.formatted(.measurement(width: .wide).locale(selectedLocale))
print("Length: " + lengthNarrow)
print("        " + lengthAbbreviated)
print("        " + lengthWide)

// Mass
let mass = Measurement<UnitMass>(value: 74,
                                 unit: .kilograms)
let massNarrow = mass.formatted(.measurement(width: .narrow).locale(selectedLocale))
let massAbbreviated = mass.formatted(.measurement(width: .abbreviated).locale(selectedLocale))
let massWide = mass.formatted(.measurement(width: .wide).locale(selectedLocale))
print("Mass: " + massNarrow)
print("      " + massAbbreviated)
print("      " + massWide)

// Power
let power = Measurement<UnitPower>(value: 8,
                                   unit: .kilowatts)
let powerNarrow = power.formatted(.measurement(width: .narrow).locale(selectedLocale))
let powerAbbreviated = power.formatted(.measurement(width: .abbreviated).locale(selectedLocale))
let powerWide = power.formatted(.measurement(width: .wide).locale(selectedLocale))
print("Power: " + powerNarrow)
print("       " + powerAbbreviated)
print("       " + powerWide)

// Pressure
let pressure = Measurement<UnitPressure>(value: 50,
                                         unit: .hectopascals)
let pressureNarrow = pressure.formatted(.measurement(width: .narrow).locale(selectedLocale))
let pressureAbbreviated = pressure.formatted(.measurement(width: .abbreviated).locale(selectedLocale))
let pressureWide = pressure.formatted(.measurement(width: .wide).locale(selectedLocale))
print("Pressure: " + pressureNarrow)
print("          " + pressureAbbreviated)
print("          " + pressureWide)

// Speed
let speed = Measurement<UnitSpeed>(value: 111.6,
                                   unit: .kilometersPerHour)
let speedNarrow = speed.formatted(.measurement(width: .narrow).locale(selectedLocale))
let speedAbbreviated = speed.formatted(.measurement(width: .abbreviated).locale(selectedLocale))
let speedWide = speed.formatted(.measurement(width: .wide).locale(selectedLocale))
print("Speed: " + speedNarrow)
print("       " + speedAbbreviated)
print("       " + speedWide)

// Temperature
let temperature = Measurement<UnitTemperature>(value: 24.3,
                                               unit: .celsius)
let temperatureNarrow = temperature.formatted(.measurement(width: .narrow).locale(selectedLocale))
let temperatureAbbreviated = temperature.formatted(.measurement(width: .abbreviated).locale(selectedLocale))
let temperatureWide = temperature.formatted(.measurement(width: .wide).locale(selectedLocale))
print("Temperature: " + temperatureNarrow)
print("             " + temperatureAbbreviated)
print("             " + temperatureWide)

// Volume
let volume = Measurement<UnitVolume>(value: 1.2,
                                     unit: .liters)
let volumeNarrow = volume.formatted(.measurement(width: .narrow).locale(selectedLocale))
let volumeAbbreviated = volume.formatted(.measurement(width: .abbreviated).locale(selectedLocale))
let volumeWide = volume.formatted(.measurement(width: .wide).locale(selectedLocale))
print("Volume: " + volumeNarrow)
print("        " + volumeAbbreviated)
print("        " + volumeWide)
