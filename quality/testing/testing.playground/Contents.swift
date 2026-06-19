import Foundation

/*
 Q&A cards — Theme 5 testing baseline (Q20, Q37, Q46)

 Structure tests as Arrange → Act → Assert; inject clocks/network so async work stays deterministic.
 XCTest wraps the same shape inside test methods.
*/

func priceAfterDiscount(base: Decimal, percentOff: Decimal) -> Decimal {
    base * (1 - percentOff / 100)
}

func runDiscountExample() {
    let base: Decimal = 100
    let percent: Decimal = 15

    let actual = priceAfterDiscount(base: base, percentOff: percent)

    let expected: Decimal = 85
    assert(actual == expected, "AAA demo failed: \(actual) != \(expected)")
    print("AAA discount check OK")
}

runDiscountExample()
