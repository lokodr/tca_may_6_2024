import ComposableArchitecture
import SwiftUI

struct BookListView: View {
    
    /*
     Within the BookListView, I’ve created a variable called “store”. This variable holds the reducer. However, we cannot directly read data from this “store” variable or trigger any actions within the view.
     */
    let store: StoreOf<BookListReducer>

    var body: some View {
        
         /// A navigation stack that is driven by a store.
         ///
         /// This view can be used to drive stack-based navigation in the Composable Architecture when passed
         /// a store that is focused on ``StackState`` and ``StackAction``.
        NavigationStackStore(self.store.scope(state: \.path, action: { .path($0) })) {
            /*
             To update our view as this “store” changes, we need to use a structure called “WithViewStore”. This structure takes the “store” variable as a parameter and the scope we want to observe. Defining the observe scope as “{ $0 }” means it will observe all parameters in the State we created within the Reducer.
             */
            
            //public struct WithViewStore<ViewState, ViewAction, Content: View>: View
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                List {
                    if let books = viewStore.books {
                        ForEach(books, id: \.isbn) { book in
                            Text(book.name)
                        }
                    } else {
                        Text("Book list is empty, refresh the page.")
                    }
                }
                .navigationTitle("Books")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            viewStore.send(.fetchBooks)
                        } label: {
                            Text("refresh")
                        }
                    }
                })
            }
        }  destination: { store in
            BookDetailView(store: store)
        }
    }
}

#Preview {
    BookListView(store: Store(initialState: BookListReducer.State(), reducer: {
        BookListReducer()
    }))
}
