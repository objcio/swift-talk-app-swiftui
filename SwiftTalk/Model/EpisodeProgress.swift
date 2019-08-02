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
                guard let resource = Session.shared.server.authenticated?.playProgress(episode: episode, progress: Int(time)) else { return }
                URLSession.shared.load(resource, onComplete: { print($0) })
            }
    }
}
