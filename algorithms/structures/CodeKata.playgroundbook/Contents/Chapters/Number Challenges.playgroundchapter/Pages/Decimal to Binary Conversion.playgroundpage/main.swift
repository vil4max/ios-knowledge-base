/*:#localized(key: "Decimal2Binary")
 ## Decimal to Binary Conversion
 
 **Goal:** Write a function that converts a given decimal (base-10) integer into its binary (base-2) representation.
 
 The result should be returned as a string of 0s and 1s.
 
 ---
 
 **Instructions:**
 
 1. Define a function named `decimalToBinary(_:)` that takes an integer as input.
 2. Use division by 2 to convert the decimal number into binary:
    - Repeatedly divide the number by 2, storing the remainders.
    - Reverse the order of the remainders to form the binary representation.
 3. Return the binary string.
 
 * Callout(Extra challenge):
   Create a function that performs the reverse operation, converting a binary string back to a decimal number.
 */
import Foundation
