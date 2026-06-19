/*:#localized(key: "Decimal2Octal")
 ## Decimal to Octal Conversion
 
 **Goal:** Write a function that converts a given decimal (base-10) integer into its octal (base-8) representation.
 
 The result should be returned as a string containing digits 0-7.
 
 ---
 
 **Instructions:**
 
 1. Define a function named `decimalToOctal(_:)` that takes an integer as input.
 2. Use division by 8 to convert the decimal number into octal:
    - Repeatedly divide the number by 8, storing the remainders.
    - Reverse the order of the remainders to form the octal string.
 3. Return the octal string.
 
 * Callout(Extra challenge):
   Create a function that performs the reverse operation, converting an octal string back to a decimal number.
 */
import Foundation
