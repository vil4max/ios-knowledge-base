/*:#localized(key: "BalancedParentheses")
 ## Check for Balanced Parentheses
 
 **Goal:** Write a function that checks if a given string has balanced parentheses.
 
 Balanced parentheses mean that every opening parenthesis `(` has a corresponding closing parenthesis `)` in the correct order.
 
 ---
 
 **Instructions:**
 
 1. Define a function named `isBalanced(_:)` that takes a string as input.
 2. Traverse the string to check for balanced parentheses:
    - Every `(` should have a matching `)`.
    - The closing `)` should not appear before its matching opening `(`.
 3. Return `true` if the string is balanced, otherwise `false`.
 
 * Callout(Extra challenge):
   Extend the function to check for balanced brackets `[]`, curly braces `{}`, and parentheses `()` in combination.
 */
import Foundation
