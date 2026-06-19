/*:#localized(key: "MorseCode")
 ## Morse Code Translator
 
 **Goal:** Write a function that translates a given string into Morse code.
 
 Each letter and number has a corresponding Morse code, and words should be separated by spaces.
 
 For simplicity, focus on letters A-Z, digits 0-9, and use a single space between Morse code characters.
 
 ---
 
 **Instructions:**
 
 1. Define a function named `toMorseCode(_:)` that takes a string as input.
 2. Use a predefined dictionary to map each character to its Morse code equivalent.
 3. Convert each character in the input string to Morse code, and join the codes with spaces.
 4. Ignore any characters that do not have a Morse code equivalent.
 
 * Callout(Extra challenge):
   Create a reverse function that converts Morse code back to English text.
 
 _Reference:_ [Morse Code Chart](https://morsecode.world/international/morse2.html)
 */
import Foundation
