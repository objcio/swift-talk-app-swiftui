//
//  ContentView.swift
//  SwiftTalk
//
//  Created by Chris Eidhof on 27.06.19.
//  Copyright © 2019 Chris Eidhof. All rights reserved.
//

import SwiftUI
import TinyNetworking
import Model
import ViewHelpers

struct ContentView : View {
    @ObjectBinding var store = sharedStore
    var body: some View {
        Group {
            if !store.loaded {
                Text("Loading...")
            } else {
                TabbedView {
                    NavigationView {
                        CollectionsList(collections: store.collections)
                    }.tabItem { Text("Collections" )}.tag(0)
                    NavigationView {
                        AllEpisodes(episodes: store.episodes)
                    }.tabItem { Text("All Episodes" )}.tag(1)
                }
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
