//
//  ViewHelpers.swift
//  SwiftTalk
//
//  Created by Florian Kugler on 02.07.19.
//  Copyright © 2019 Chris Eidhof. All rights reserved.
//

import SwiftUI

struct NewBadge: View {
    var body: some View {
        Text("NEW").foregroundColor(.white).font(.footnote).padding(5).background(Color.blue.cornerRadius(5))
    }
}

struct LazyView<V: View>: View {
    let build: () -> V
    
    init(_ build: @escaping @autoclosure () -> V) {
        self.build = build
    }
    
    var body: V {
        build()
    }
}
