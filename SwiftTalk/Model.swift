//
//  Model.swift
//  SwiftTalk
//
//  Created by Chris Eidhof on 27.06.19.
//  Copyright © 2019 Chris Eidhof. All rights reserved.
//

import Foundation
import SwiftUI
import TinyNetworking
import Model

extension CollectionView: Identifiable {}
extension EpisodeView: Identifiable {}

extension EpisodeView {
    var durationAndDate: String {
        "\(TimeInterval(media_duration).hoursAndMinutes) · \(released_at.pretty)"
    }
    
    var mediaURL: URL? {
        self.hls_url ?? self.preview_url
    }
}

extension CollectionView {
    var episodeCountAndTotalDuration: String {
        "\(episodes_count) episodes ᐧ \(TimeInterval(total_duration).hoursAndMinutes)"
    }
}

fileprivate let decoder: JSONDecoder = {
    let d = JSONDecoder()
    d.dateDecodingStrategy = Model.decodingStrategy
    return d
}()
let allCollections = Endpoint<[CollectionView]>(json: .get, url: URL(string: "https://talk.objc.io/collections.json")!, decoder: decoder)
let allEpisodes = Endpoint<[EpisodeView]>(json: .get, url: URL(string: "https://talk.objc.io/episodes.json")!, decoder: decoder)

let sampleCollections: [CollectionView] = sample(name: "collections")
let sampleEpisodes: [EpisodeView] = sample(name: "episodes")

import Combine

final class EpisodeProgress: BindableObject {
    let willChange = PassthroughSubject<(), Never>()
    
    let episode: EpisodeView
    var progress: TimeInterval {
        willSet {
            print(newValue)
            willChange.send()
        }
    }
    init(episode: EpisodeView, progress: TimeInterval) {
        self.episode = episode
        self.progress = progress
    }
}

final class Store: BindableObject {
    let willChange: AnyPublisher<(), Never>
    let sharedCollections = Resource(endpoint: allCollections)
    let sharedEpisodes = Resource(endpoint: allEpisodes)
    
    init() {
        willChange = sharedCollections.willChange.zip(sharedEpisodes.willChange).map { _ in () }.eraseToAnyPublisher()
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

func sample<A: Codable>(name: String) -> A {
    let url = Bundle.main.url(forResource: name, withExtension: "json")!
    let data = try! Data(contentsOf: url)
    return try! decoder.decode(A.self, from: data)
}

