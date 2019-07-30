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

final class Resource<A>: ObservableObject {
    // todo is there a nicer way to have an empty publisher?
    var objectWillChange: AnyPublisher<A?, Never> = Publishers.Sequence<[A?], Never>(sequence: []).eraseToAnyPublisher()
    @Published var value: A? = nil
    let endpoint: Endpoint<A>
    private var firstLoad = true
    
    init(endpoint: Endpoint<A>) {
        self.endpoint = endpoint
        self.objectWillChange = $value.handleEvents(receiveSubscription: { [weak self] sub in
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
