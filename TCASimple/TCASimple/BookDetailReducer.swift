import ComposableArchitecture
import Foundation

class BookDetailReducer: Reducer {
    //I included “bookClient” as a dependency in “BookDetailReducer.”
    @Dependency(\.bookClient) var bookClient
    
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
            //Restructure the “fetchCharacters” action within the reduce function to send a request to this client and trigger the “characterFetched” action upon receiving the response.
            let characterURLS = state.book.characters
            state.isLoading = true
            return .run { send in
                let characters = try? await self.bookClient.fetchCharacters(characterURLS)
                await send(.characterFetched(characters))
            }
        case let .characterFetched(characters):
            state.isLoading = false
            state.characters = characters
            return .none
        }
    }
}
