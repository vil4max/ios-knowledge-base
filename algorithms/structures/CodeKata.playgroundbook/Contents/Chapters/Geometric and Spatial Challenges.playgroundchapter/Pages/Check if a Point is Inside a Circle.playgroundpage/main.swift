/*:#localized(key: "PointCircle")
 ## Check if a Point is Inside a Circle
 
 **Goal:** Write a function that checks whether a given point lies inside, outside, or on the edge of a circle.
 
 The circle is defined by its center point and radius.
 
 ---
 
 **Instructions:**
 
 1. Define a function named `isPointInsideCircle(_:center:radius:)` that takes a point, the center of the circle, and the radius as input.
 2. Calculate the Euclidean distance between the point and the center of the circle.
 3. Return "`inside`" if the distance is less than the radius, "`on the edge`" if the distance is equal to the radius, and "`outside`" if the distance is greater than the radius.
 
 * Callout(Extra challenge):
   Extend the function to check if multiple points are inside, on the edge, or outside the circle and return the results as a list.
 */
import Foundation
