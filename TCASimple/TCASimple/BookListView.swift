import ComposableArchitecture
import SwiftUI

struct BookListView: View {
    
    /*
     Within the BookListView, I’ve created a variable called “store”. This variable holds the reducer. However, we cannot directly read data from this “store” variable or trigger any actions within the view.
     */
    let store: StoreOf<BookListReducer>

    var body: some View {
        
        NavigationView {
            /*
             To update our view as this “store” changes, we need to use a structure called “WithViewStore”. This structure takes the “store” variable as a parameter and the scope we want to observe. Defining the observe scope as “{ $0 }” means it will observe all parameters in the State we created within the Reducer.
             */
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
        }
    }
}

#Preview {
    BookListView(store: Store(initialState: BookListReducer.State(), reducer: {
        BookListReducer()
    }))
}
