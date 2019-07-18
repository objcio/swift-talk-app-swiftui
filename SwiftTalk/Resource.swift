//
//  Resource.swift
//  SwiftTalk2
//
//  Created by Chris Eidhof on 27.06.19.
//  Copyright © 2019 Chris Eidhof. All rights reserved.
//

import Foundation
import TinyNetworking
import Combine
import SwiftUI

final class Resource<A>: BindableObject {
    // todo empty publisher
    var willChange: AnyPublisher<(), Never> = Publishers.Sequence<[()], Never>(sequence: []).eraseToAnyPublisher()
    private let subject = PassthroughSubject<(), Never>()
    let endpoint: Endpoint<A>
    private var firstLoad = true
    var value: A? {
        willSet {
            self.subject.send()
        }
    }
    
    init(endpoint: Endpoint<A>) {
        self.endpoint = endpoint
        self.willChange = subject.handleEvents(receiveSubscription: { [weak self] sub in
            guard let s = self, s.firstLoad else { return }
            s.firstLoad = false
            s.reload()

        }).eraseToAnyPublisher()
    }
    
    func reload() {
        print(endpoint.request.url!)
        URLSession.shared.load(endpoint) { result in
            DispatchQueue.main.async {
                self.value = try? result.get()
            }
        }
    }
}
