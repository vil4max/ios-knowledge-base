/*:#localized(key: "Decimal2Hexadecimal")
 ## Decimal to Hexadecimal Conversion
 
 **Goal:** Write a function that converts a given decimal (base-10) integer into its hexadecimal (base-16) representation.
 
 The result should be returned as a string containing digits 0-9 and letters A-F.
 
 ---
 
 **Instructions:**
 
 1. Define a function named `decimalToHex(_:)` that takes an integer as input.
 2. Use division by 16 to convert the decimal number into hexadecimal:
    - Repeatedly divide the number by 16, storing the remainders.
    - Convert remainders greater than 9 into the corresponding letters (10 becomes A, 11 becomes B, etc.).
    - Reverse the order of the remainders to form the hexadecimal string.
 3. Return the hexadecimal string.
 
 * Callout(Extra challenge):
   Create a function that converts a hexadecimal string back to a decimal number.
 */
import Foundation
