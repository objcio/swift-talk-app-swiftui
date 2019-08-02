//
//  Store.swift
//  SwiftTalk
//
//  Created by Chris Eidhof on 29.07.19.
//  Copyright © 2019 Chris Eidhof. All rights reserved.
//

import Foundation
import Model
import SwiftUI
import Combine

final class Store: ObservableObject {
    let objectWillChange: AnyPublisher<(), Never>
    let sharedCollections = Resource(endpoint: Session.shared.server.allCollections)
    let sharedEpisodes = Resource(endpoint: Session.shared.server.allEpisodes)
    
    init() {
        objectWillChange = sharedCollections.objectWillChange.zip(sharedEpisodes.objectWillChange).map { _ in () }.eraseToAnyPublisher()
    }
    
    var loaded: Bool {
        sharedCollections.value != nil && sharedEpisodes.value != nil
    }
    
    var collections: [CollectionView] { sharedCollections.value ?? [] }
    var episodes: [EpisodeView] { sharedEpisodes.value ?? [] }
    
    func collection(for ep: EpisodeView) -> CollectionView? {
        collections.first { $0.id == ep.collection }
    }
}

let sharedStore = Store()
