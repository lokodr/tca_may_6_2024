import SwiftUI
import ComposableArchitecture

@main
struct TCASimpleApp: App {
    
    private static let store = Store(initialState: BookListReducer.State(), reducer: {
        BookListReducer()
    })
    
    var body: some Scene {
        WindowGroup {
            BookListView(store: TCASimpleApp.store)
        }
    }
}
