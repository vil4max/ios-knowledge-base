/*:#localized(key: "LineIntersection")
 ## Line Intersection Checker
 
 **Goal:** Write a function that determines whether two line segments intersect in a 2D Cartesian plane.
 
 Each line segment is represented by two endpoints.
 
 ---
 
 **Instructions:**
 
 1. Define a function named `doLinesIntersect(_:_:)` that takes two line segments as input, where each line segment is represented as a pair of coordinate tuples `(x, y)`.
 2. Use the orientation method to check for intersection:
    - Calculate the orientation of each endpoint with respect to the other segment.
    - Check if the segments “straddle” each other.
 3. Return `true` if the segments intersect, otherwise `false`.
 
 * Callout(Extra challenge):
   Extend the function to return the intersection point if the segments do intersect.
 */
import Foundation
