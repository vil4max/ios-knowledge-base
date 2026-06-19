//: # Rule of Three
//: The “Rule of Three” is a mathematical principle used to solve problems that involve ratios or proportions. It is called “simple” because it deals with linear relationships where two given values determine a third. This method is frequently used in situations where the change in one quantity causes a proportional change in another quantity.
//: 
//: ## How it works:
//: The Rule of Three involves four values, arranged in two pairs. You know three of these values: two that form a known ratio, and one that is part of the ratio you wish to discover. The fourth value is the one you need to find. The process can be summarized in three steps:
//: 
//: 1. **Set up the proportion:** Write the known ratio and set it equal to the unknown ratio. For example, if “A is to B as C is to D,” and you know values for A, B, and C, but D is unknown, the proportion would be  A / B = C / D.
//: 2. **Cross-multiply:** Multiply the known cross-pairs to find the unknown value. Using the above example, you would solve for D by rearranging the equation to  D = B * C / A.
//: 3. **Solve the equation:** Perform the arithmetic to find the unknown value. This value will maintain the proportion between the two pairs.
// Define variables for the known quantities
let applesQuantity1: Int = /*#-editable-code*/8/*#-end-editable-code*/
let applesCost1: Double = /*#-editable-code*/4.0/*#-end-editable-code*/

// Define the variable for the unknown quantity
let applesQuantity2: Int = /*#-editable-code*/2/*#-end-editable-code*/

// Calculate the result using the rule of three
let applesCost2 = (applesCost1 * Double(applesQuantity2)) / Double(applesQuantity1)

//#-hidden-code
print("Rule of Three")
print("=============")
print("")
print("If \(applesQuantity1) apples cost \(applesCost1) dollars,")
print("then \(applesQuantity2) apples will cost \(applesCost2) dollars.")
//#-end-hidden-code