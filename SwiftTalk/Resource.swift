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
    let didChange = PassthroughSubject<A?, Never>()
    let endpoint: Endpoint<A>
    var value: A? {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self.value)
            }
        }
    }
    
    init(endpoint: Endpoint<A>) {
        self.endpoint = endpoint
        reload()
    }
    
    func reload() {
        URLSession.shared.load(endpoint) { result in
            self.value = try? result.get()
        }
    }
}
