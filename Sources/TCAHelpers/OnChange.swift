import ComposableArchitecture

// Credit: https://github.com/pointfreeco/isowords/blob/main/Sources/TcaHelpers/OnChange.swift
public extension Reducer {
    func onChange<LocalState>(
        of toLocalState: @escaping (State) -> LocalState,
        perform additionalEffects: @escaping (LocalState, inout State, Action, Environment) -> Effect<
            Action, Never
        >
    ) -> Self where LocalState: Equatable {
        .init { state, action, environment in
            let previousLocalState = toLocalState(state)
            let effects = self.run(&state, action, environment)
            let localState = toLocalState(state)

            return previousLocalState != localState
                ? .merge(effects, additionalEffects(localState, &state, action, environment))
                : effects
        }
    }

    func onChange<LocalState>(
        of toLocalState: @escaping (State) -> LocalState,
        perform additionalEffects: @escaping (LocalState, LocalState, inout State, Action, Environment)
            -> Effect<Action, Never>
    ) -> Self where LocalState: Equatable {
        .init { state, action, environment in
            let previousLocalState = toLocalState(state)
            let effects = self.run(&state, action, environment)
            let localState = toLocalState(state)

            return previousLocalState != localState
                ? .merge(
                    effects, additionalEffects(previousLocalState, localState, &state, action, environment)
                )
                : effects
        }
    }
}
