/*:#localized(key: "BinarySearch")
 ## Binary Search
 
 **Goal:** Write a function that performs a binary search on a sorted array of integers to find the index of a specified target.
 
 If the target is not found, return `nil`.
 
 ---
 
 **Instructions:**
 
 1. Define a function named `binarySearch(_:target:)` that takes a sorted array of integers and a target integer as input.
 2. Use the binary search algorithm to find the target in the array:
    - Divide the array into halves.
    - Compare the middle element with the target to decide which half to search.
 3. Return the index of the target if found, or `nil` if the target is not in the array.
 
 * Callout(Extra challenge):
   Modify the function to return all indices if the array contains multiple occurrences of the target.
 */
import Foundation
