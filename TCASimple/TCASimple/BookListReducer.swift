import ComposableArchitecture
import Foundation

class BookListReducer: Reducer {
    struct State: Equatable {
        /*
         In state, we create a StackState named path. This variable will hold the states of the detail pages we will open..
         */
        /// A list of data representing the content of a navigation stack.
        var path = StackState<BookDetailReducer.State>()
        var books: [Book]?
    }

    enum Action {
        case fetchBooks
        case booksFetched([Book]?)
        /*
         Then, we add a path action in the Action enum, which takes the State and Action enum of the detail page as parameters.
         */
        /// A wrapper type for actions that can be presented in a navigation stack.
        case path(StackAction<BookDetailReducer.State, BookDetailReducer.Action>)
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .fetchBooks:
            return .run { send in
                let bookListUrl = "https://anapioficeandfire.com/api/books"
                let (data, _) = try await URLSession.shared.data(from: URL(string: bookListUrl)!)
                let books = try? JSONDecoder().decode([Book].self, from: data)
                await send(.booksFetched(books))
            }
        case let .booksFetched(books):
            state.books = books
            return .none
        case .path:
            return .none
        }
    }
}
