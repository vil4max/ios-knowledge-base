/*:#localized(key: "QuickSort")
 ## Quick Sort
 
 **Goal:** Write a function that sorts an array of integers in ascending order using the quicksort algorithm.
 
 Quicksort is a divide-and-conquer algorithm that selects a “pivot” element, partitions the array into elements less than and greater than the pivot, and recursively sorts the partitions.
 
 ---
 
 **Instructions:**
 
 1. Define a function named `quickSort(_:)` that takes an array of integers as input.
 2. Implement the quicksort algorithm:
    - If the array has one or no elements, it is already sorted.
    - Choose a pivot element (typically the last element or a random element).
    - Partition the array into elements less than the pivot and elements greater than the pivot.
    - Recursively apply quicksort to each partition and combine the results.
 3. Return the sorted array.
 
 * Callout(Extra challenge):
   Modify the function to sort the array in descending order.
 */
import Foundation
