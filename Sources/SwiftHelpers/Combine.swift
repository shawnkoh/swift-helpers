import Combine

public extension Publisher where Output == Never {
    func setOutputType<NewOutput>(to _: NewOutput.Type) -> AnyPublisher<NewOutput, Failure> {
        func absurd<A>(_: Never) -> A {}
        return map(absurd).eraseToAnyPublisher()
    }
}

public extension Publisher {
    func ignoreOutput<NewOutput>(
        setOutputType _: NewOutput.Type
    ) -> AnyPublisher<NewOutput, Failure> {
        ignoreOutput()
            .setOutputType(to: NewOutput.self)
    }

    func ignoreFailure<NewFailure>(
        setFailureType _: NewFailure.Type
    ) -> AnyPublisher<Output, NewFailure> {
        self
            .catch { _ in Empty() }
            .setFailureType(to: NewFailure.self)
            .eraseToAnyPublisher()
    }

    func ignoreFailure() -> AnyPublisher<Output, Never> {
        self
            .catch { _ in Empty() }
            .setFailureType(to: Never.self)
            .eraseToAnyPublisher()
    }
}
