/*:#localized(key: "MergeSort")
 ## Merge Sort
 
 **Goal:** Write a function that sorts an array of integers in ascending order using the merge sort algorithm.
 
 Merge sort is a divide-and-conquer algorithm that splits the array into halves, sorts each half, and then merges the sorted halves.
 
 ---
 
 **Instructions:**
 
 1. Define a function named `mergeSort(_:)` that takes an array of integers as input.
 2. Implement the merge sort algorithm:
    - If the array has one or no elements, it is already sorted.
    - Split the array into two halves.
    - Recursively sort each half, then merge the sorted halves.
 3. Return the sorted array.
 
 * Callout(Extra challenge):
   Modify the function to sort the array in descending order.
 */
import Foundation
