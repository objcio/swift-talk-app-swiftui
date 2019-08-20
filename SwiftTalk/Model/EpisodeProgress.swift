//
//  EpisodeProgress.swift
//  SwiftTalk
//
//  Created by Chris Eidhof on 29.07.19.
//  Copyright © 2019 Chris Eidhof. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import Model

final class EpisodeProgress: ObservableObject {
    let objectWillChange = PassthroughSubject<TimeInterval, Never>()
    let sink: AnyCancellable
    let episode: EpisodeView
    var progress: TimeInterval {
        willSet {
            objectWillChange.send(newValue)
        }
    }
    init(episode: EpisodeView, progress: TimeInterval) {
        self.episode = episode
        self.progress = progress
        sink = objectWillChange
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
