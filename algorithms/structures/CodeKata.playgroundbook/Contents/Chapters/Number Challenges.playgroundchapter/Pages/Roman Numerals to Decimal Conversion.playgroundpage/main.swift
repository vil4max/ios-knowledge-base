/*:#localized(key: "Roman")
 ## Roman Numerals to Decimal Conversion
 
 **Goal:** Write a function that converts a Roman numeral string into its decimal (base-10) integer representation.
 
 Roman numerals are written using the characters **I**, **V**, **X**, **L**, **C**, **D**, and **M**.
 
 ---
 
 **Instructions:**
 
 1. Define a function named `romanToDecimal(_:)` that takes a Roman numeral string as input.
 2. Convert the Roman numeral into decimal:
    - Iterate through each character in the string.
    - If a character represents a smaller value than the next character, subtract it (e.g., IV represents 4).
    - Otherwise, add the value.
 3. Return the result as an integer.
 
 * Callout(Extra challenge):
   Create a function that performs the reverse operation, converting a decimal number to Roman numerals.
 
 _Reference:_ [Roman Numerals](https://www.rapidtables.com/math/symbols/roman_numerals.html)
 */
import Foundation
