/*:#localized(key: "AreaPolygon")
 ## Area of Polygon
 
 **Goal:** Write a function that calculates the area of a simple polygon given the vertices as an array of coordinate pairs.
 
 Assume the polygon is non-self-intersecting and defined in a 2D Cartesian plane.
 
 ---
 
 **Instructions:**
 
 1. Define a function named `areaOfPolygon(_:)` that takes an array of coordinate pairs as input, where each coordinate pair is represented as a tuple `(x, y)`.
 2. Use the **Shoelace formula** to calculate the area:
    - Multiply each x-coordinate by the y-coordinate of the next vertex, then subtract the y-coordinate multiplied by the next x-coordinate.
    - Sum these results and take the absolute value, dividing by 2.
 3. Return the area as a `Double`.
 
 * Callout(Extra challenge):
   Extend the function to handle polygons with holes, calculating the area as the difference between outer and inner polygons.
 */
import Foundation
