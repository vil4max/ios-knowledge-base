/*:#localized(key: "GCD")
 ## Greatest Common Divisor (GCD)
 
 **Goal:** Write a function that calculates the greatest common divisor (GCD) of two integers.
 
 The GCD is the largest positive integer that divides both numbers without leaving a remainder.
 
 ---
 
 **Instructions:**
 
 1. Define a function named `gcd(_:_:)` that takes two integers as input.
 2. Use the Euclidean algorithm to find the GCD:  
    - If one number is 0, the GCD is the other number.
    - Otherwise, repeatedly divide the larger number by the smaller and take the remainder, until one of the numbers becomes zero.
 3. Return the GCD as an integer.
 
 * Callout(Extra challenge):
   Extend the function to handle an array of integers, returning the GCD of all elements.
 */
import Foundation
