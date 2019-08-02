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
    var metaInfo: String {
        "#\(number) · \(TimeInterval(media_duration).hoursAndMinutes) · \(released_at.pretty)"
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

extension Session {
    var server: Server {
        let creds = credentials.map {
            Credentials(sessionId: $0.sessionId, csrf: $0.csrf)
        }
        return Server(credentials: creds)
    }
}

let sampleCollections: [CollectionView] = sample(name: "collections")
let sampleEpisodes: [EpisodeView] = sample(name: "episodes")

func sample<A: Codable>(name: String) -> A {
    let url = Bundle.main.url(forResource: name, withExtension: "json")!
    let data = try! Data(contentsOf: url)
    return try! decoder.decode(A.self, from: data)
}

