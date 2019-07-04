//
//  ViewHelpers.swift
//  SwiftTalk
//
//  Created by Florian Kugler on 02.07.19.
//  Copyright © 2019 Chris Eidhof. All rights reserved.
//

import SwiftUI

let newBadge = Text("NEW").color(.white).font(.footnote).padding(5).background(Color.blue.cornerRadius(5))

struct LazyView<V: View>: View {
    let build: () -> V
    
    init(_ build: @escaping @autoclosure () -> V) {
        self.build = build
    }
    
    var body: V {
        build()
    }
}
