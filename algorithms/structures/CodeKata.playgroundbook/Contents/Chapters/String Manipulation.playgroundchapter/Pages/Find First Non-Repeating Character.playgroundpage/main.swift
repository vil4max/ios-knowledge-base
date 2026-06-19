/*:#localized(key: "NonRepeatingCharacter")
 ## Find First Non-Repeating Character
 
 **Goal:** Write a function that finds the first non-repeating character in a given string.
 
 If all characters repeat, return `nil`.
 
 ---
 
 **Instructions:**
 
 1. Define a function named `firstNonRepeatingCharacter(_:)` that takes a string as input.
 2. Use a dictionary to count the occurrences of each character.
 3. Iterate through the string to find the first character with a count of `1`.
 4. Return the first non-repeating character, or `nil` if none exist.
 
 * Callout(Extra challenge):
   Extend the function to return all non-repeating characters in order of appearance.
 */
import Foundation
