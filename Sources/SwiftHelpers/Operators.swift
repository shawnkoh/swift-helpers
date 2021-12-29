import Prelude

/// Forward composition of functions.
///
/// - Parameters:
///   - f: A function that takes a value in `A` and returns a value in `B`.
///   - a: An argument in `A`.
///   - g: A function that takes a value in `B` and returns a value in `C`.
///   - b: An argument in `B`.
/// - Returns: A new function that takes a value in `A` and returns a value in `C`.
/// - Note: This function is commonly seen in operator form as `>>>`.
public func >>> <A, B, C>(
    _ f: @escaping (_ a: A) throws -> B,
    _ g: @escaping (_ b: B) throws -> C
)
    -> (A) throws -> C
{
    { (a: A) throws -> C in
        try g(f(a))
    }
}
