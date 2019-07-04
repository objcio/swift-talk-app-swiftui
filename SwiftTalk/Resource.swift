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
    var didChange: AnyPublisher<A?, Never> = Publishers.Empty().eraseToAnyPublisher()
    private let subject = PassthroughSubject<A?, Never>()
    let endpoint: Endpoint<A>
    private var firstLoad = true
    var value: A? {
        didSet {
            DispatchQueue.main.async {
                self.subject.send(self.value)
            }
        }
    }
    
    init(endpoint: Endpoint<A>) {
        self.endpoint = endpoint
        self.didChange = subject.handleEvents(receiveSubscription: { [weak self] sub in
            guard let s = self, s.firstLoad else { return }
            s.firstLoad = false
            s.reload()

        }).eraseToAnyPublisher()
    }
    
    func reload() {
        print(endpoint.request.url!)
        URLSession.shared.load(endpoint) { result in
            self.value = try? result.get()
        }
    }
}
