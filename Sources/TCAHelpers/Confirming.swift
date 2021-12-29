import ComposableArchitecture
import Foundation
import NonEmpty

// TODO: This can be made more efficient as an ordered dictionary
@dynamicMemberLookup
public struct ConfirmingState<Steps: Collection> where Steps.Element: Equatable {
    // TODO: Mode can be extended to be even more generic
    // something like - steps an accept a sequence of Toggleable and Pulsable states.
    public enum Mode {
        case resting
        case confirming(Steps.Element)
    }

    private var steps: NonEmpty<Steps>
    public var mode: Mode

    public mutating func reset() {
        self.mode = .resting
    }

    public mutating func toggle() {
        switch mode {
        case .resting:
            self.mode = .confirming(steps.first)
        case .confirming:
            self.mode = .resting
        }
    }

    public mutating func pulse() {
        switch mode {
        case .resting:
            return
        case let .confirming(element):
            guard let nextIndex = steps.firstIndex(of: element).flatMap(steps.index(after:)),
                  nextIndex != steps.endIndex
            else {
                self.mode = .confirming(steps.first)
                return
            }
            self.mode = .confirming(steps[nextIndex])
        }
    }

    public subscript<T>(dynamicMember keyPath: WritableKeyPath<Mode, T>) -> T {
        get { self.mode[keyPath: keyPath] }
        set { self.mode[keyPath: keyPath] = newValue }
    }

    public init(steps: NonEmpty<Steps>) {
        self.mode = .resting
        self.steps = steps
    }
}

extension ConfirmingState.Mode: Equatable where Steps.Element: Equatable {}
extension ConfirmingState.Mode: Hashable where Steps.Element: Hashable {}
extension ConfirmingState: Equatable where Steps: Equatable, Steps.Index: Equatable {}
extension ConfirmingState: Hashable where Steps: Hashable, Steps.Element: Hashable, Steps.Index: Hashable {}

public enum ConfirmingAction {
    case reset
    case toggle
    case pulse
}

// TODO: Find out how to make this void
public struct ConfirmingEnvironment {}

public extension Reducer {
    func confirming<S>(
        state: WritableKeyPath<State, ConfirmingState<S>>,
        action: CasePath<Action, ConfirmingAction>,
        environment: @escaping (Environment) -> ConfirmingEnvironment
    ) -> Reducer {
        .combine(
            self,
            Reducer<ConfirmingState<S>, ConfirmingAction, ConfirmingEnvironment> { state, action, _ in
                switch action {
                case .toggle:
                    state.toggle()
                case .pulse:
                    state.pulse()
                case .reset:
                    state.reset()
                }
                return .none
            }
            .pullback(state: state, action: action, environment: environment)
        )
    }
}
