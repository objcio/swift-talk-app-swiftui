//
//  Account.swift
//  SwiftTalk
//
//  Created by Chris Eidhof on 18.07.19.
//  Copyright © 2019 Chris Eidhof. All rights reserved.
//

import SwiftUI

struct WindowKey: EnvironmentKey {
    static let defaultValue: UIWindow? = nil
}

extension EnvironmentValues {
    var window: UIWindow? {
        get {
            self[WindowKey.self]
        }
        set {
            self[WindowKey.self] = newValue
        }
    }
}

struct Account: View {
    @Environment(\.window) var window
    @ObservedObject var session = Session.shared
    var body: some View {
        Form {
            if session.credentials == nil {
                Button(action: {
                    getAuthToken(window: self.window!, onComplete: { result in
                        switch result {
                        case let .failure(e): print(e) // todo
                        case let .success(info):
                            self.session.credentials = info
                        }
                    })
                }) {
                    Text("Log In")
                }
            } else {
                Button(action: { self.session.credentials = nil }) {
                    Text("Log Out")
                }
            }
        }.navigationBarTitle("Account")
    }
}

#if DEBUG
struct Account_Previews: PreviewProvider {
    static var previews: some View {
        Account()
    }
}
#endif
