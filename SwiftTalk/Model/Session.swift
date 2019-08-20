//
//  Session.swift
//  SwiftTalk
//
//  Created by Chris Eidhof on 18.07.19.
//  Copyright © 2019 Chris Eidhof. All rights reserved.
//

import Foundation
import KeychainItem
import SwiftUI
import Combine

final class Session: ObservableObject {
    @KeychainItem(account: "sessionId") private var sessionId
    @KeychainItem(account: "csrf") private var csrf
    
    let objectWillChange = PassthroughSubject<(), Never>()
    
    var credentials: (sessionId: String, csrf: String)? {
        get {
            guard let s = sessionId, let c = csrf else { return nil }
            return (s, c)
        }
        set {
            objectWillChange.send()
            sessionId = newValue?.sessionId
            csrf = newValue?.csrf
        }
    }

    static let shared = Session()
}
