import ComposableArchitecture
import Foundation

class BookDetailReducer: Reducer {
    
    struct State: Equatable {
        var book: Book
        var characters: [Character]?
        var isLoading: Bool = false
    }

    enum Action {
        case fetchCharacters
        case characterFetched([Character]?)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .fetchCharacters:
            state.isLoading = true
            return .none
        case let .characterFetched(characters):
            state.isLoading = false
            state.characters = characters
            return .none
        }
    }
}
