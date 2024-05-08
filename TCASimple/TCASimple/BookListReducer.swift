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
    
    /*
     While making the page, we move the actions we defined in the reduce function into the ReduceBuilder, which we will call “body”. Because using this reduce builder gives us the flexibility we cannot do with the reduce function.
     */
    //Before:
//    func reduce(into state: inout State, action: Action) -> Effect<Action> {
//        switch action {
//        case .fetchBooks:
//            return .run { send in
//                let bookListUrl = "https://anapioficeandfire.com/api/books"
//                let (data, _) = try await URLSession.shared.data(from: URL(string: bookListUrl)!)
//                let books = try? JSONDecoder().decode([Book].self, from: data)
//                await send(.booksFetched(books))
//            }
//        case let .booksFetched(books):
//            state.books = books
//            return .none
//        case .path:
//            return .none
//        }
//    }
    
    //After:
    ////// A convenience for constraining a ``Reducer`` conformance.
    ///
    /// This allows you to specify the `body` of a ``Reducer`` conformance
    var body: some ReducerOf<BookListReducer> {
        Reduce { state, action in
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
        /*
         At the end of the Reduce function, I call a forEach function. This function uses it to open all the pages attached to the path in TCA. As a parameter, it takes the path variable we created in State as keyPath and listens to the path action we added as an action. Since we will only open the detail page, I created just a BookDetailReducer object.
         */
        .forEach(\.path, action: /Action.path) {
            BookDetailReducer()
        }
    }
}
