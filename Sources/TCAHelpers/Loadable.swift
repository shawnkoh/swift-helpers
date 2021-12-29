import Foundation

public enum Loadable<T> {
    case notLoaded
    case loading
    case loaded(T)
}

extension Loadable: Equatable where T: Equatable {}
extension Loadable: Hashable where T: Hashable {}
