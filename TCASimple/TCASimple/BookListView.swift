//
//  BookListView.swift
//  BookListApp
//
//  Created by Bozkurt, Umit on 22.10.2023.
//

import ComposableArchitecture
import SwiftUI

struct BookListView: View {
    
    let store: StoreOf<BookListReducer>

    var body: some View {
        
        NavigationView {
                Text("Hello, World!")
                .navigationTitle("Books")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {

                        } label: {
                            Text("refresh")
                        }
                    }
                })
            }
        }
    }

#Preview {
    BookListView(store: Store(initialState: BookListReducer.State(), reducer: {
        BookListReducer()
    }))
}
