//
//  BookClient.swift
//  TCASimple
//
//  Created by WiseMac on 2024-05-07.
//

import Foundation
import ComposableArchitecture

struct BookClient {
    
    /* Type of variable: (Array<String>) async throws -> [Character]?
     the variable represents and asynchronous function
     parameter type: [String]
     return type: [Character]?
     it's async
     it can throw errors
     */
    var fetchCharacters: ([String]) async throws -> [Character]?
}


/*
 An extension where I provided that the BookClient struct conforms to the DependencyKey protocol. I defined a static variable to conform this protocol and included the “fetchCharacters” function. The “arrayRequest” function I used within this function is one that I created in an extension. This function takes a URL array, sends requests to all the URLs, and converts the responses into a character array.
 */
extension BookClient: DependencyKey {
    static var liveValue: BookClient = Self(
        fetchCharacters: { urls in
            let characters: [Character?] = try await arrayRequest(for: urls)
            return characters.compactMap({ $0 })
        }
    )
}

extension BookClient {
    private static func arrayRequest<T: Codable>(for links: [String]) async throws -> [T?] {
        let results: [T?] = try await withThrowingTaskGroup(of: T?.self) { group in
            for link in links {
                group.addTask {
                    do {
                        guard let linkURL = URL(string: link) else { return nil }
                        let (data, _) = try await URLSession.shared.data(from: linkURL)
                        let model = try JSONDecoder().decode(T.self, from: data)
                        return model
                    } catch {
                        print("Error fetching or decoding data from \(link): \(error)")
                        return nil
                    }
                }
            }
            return try await group.reduce(into: [T?]()) { models, model in
                models.append(model)
            }
        }
        return results
    }
}


/*
 To access the BookClient layer in the application through TCA’s Dependency Manager, I wrote an extension to the struct named DependencyValues and introduced BookClient. Now, I can access this struct in the project and send the character request.
 
 DependencyValues
 /// A collection of dependencies that is globally available.
 ///
 /// To access a particular dependency from the collection you use the ``Dependency`` property
 /// wrapper:
*/
extension DependencyValues {
    var bookClient: BookClient {
        get { self[BookClient.self] }
        set { self[BookClient.self] = newValue }
    }
}
