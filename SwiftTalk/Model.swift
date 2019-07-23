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

let server = Server()

let sampleCollections: [CollectionView] = sample(name: "collections")
let sampleEpisodes: [EpisodeView] = sample(name: "episodes")

import Combine

final class EpisodeProgress: BindableObject {
    let willChange = PassthroughSubject<TimeInterval, Never>()
    let sink: Subscribers.Sink<TimeInterval, Never>
    let episode: EpisodeView
    var progress: TimeInterval {
        willSet {
            willChange.send(newValue)
        }
    }
    init(episode: EpisodeView, progress: TimeInterval) {
        self.episode = episode
        self.progress = progress
        sink = willChange
            .throttle(for: 10, scheduler: RunLoop.main, latest: true)
            .removeDuplicates()
            .sink { time in
                guard let credentials = Session.shared.credentials else { return }
                let auth = server.authenticated(sessionId: credentials.sessionId, csrf: credentials.csrf)
                let resource = auth.playProgress(episode: episode, progress: Int(time))
                URLSession.shared.load(resource, onComplete: { print($0) })
                print("Send to network \(time) \(episode.id)")
            }
    }
}

final class Store: BindableObject {
    let willChange: AnyPublisher<(), Never>
    let sharedCollections = Resource(endpoint: server.allCollections)
    let sharedEpisodes = Resource(endpoint: server.allEpisodes)
    
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

