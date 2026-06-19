/*:
# Optionals summary
You’ve made it to the end of the tenth part of this series, so let’s summarize:

1. Optionals let us represent the absence of a value in a clear and unambiguous way.
2. Swift won’t let us use optionals without unwrapping them, either using `if let` or using `guard let`.
3. You can force unwrap optionals with an exclamation mark, but if you try to force unwrap `nil` your code will crash.
4. Implicitly unwrapped optionals don’t have the safety checks of regular optionals.
5. You can use nil coalescing to unwrap an optional and provide a default value if there was nothing inside.
6. Optional chaining lets us write code to manipulate an optional, but if the optional turns out to be empty the code is ignored.
7. You can use `try?` to convert a throwing function into an optional return value, or `try!` to crash if an error is thrown.
8. If you need your initializer to fail when it’s given bad input, use `init?()` to make a failable initializer.
9. You can use typecasting to convert one type of object to another.*/
