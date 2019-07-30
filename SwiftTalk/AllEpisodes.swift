//
//  AllEpisodes.swift
//  SwiftTalk
//
//  Created by Chris Eidhof on 04.07.19.
//  Copyright © 2019 Chris Eidhof. All rights reserved.
//

import SwiftUI
import Model
import TinyNetworking

struct EpisodeItem: View {
    let episode: EpisodeView
    @ObservedObject var store = sharedStore
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(store.collection(for: episode)?.title ?? "")
                    .font(.subheadline)
                    .foregroundColor(.blue)
                Text(episode.title)
                    .font(.headline)
                Text(episode.metaInfo)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct AllEpisodes : View {
    let episodes: [EpisodeView]
    
    var body: some View {
        List {
            ForEach(episodes) { episode in
                NavigationLink(destination: Episode(episode: episode)) {
                    EpisodeItem(episode: episode)
                }
            }
        }.navigationBarTitle("All Episodes")
    }
}

#if DEBUG
struct AllEpisodes_Previews : PreviewProvider {
    static var previews: some View {
        AllEpisodes(episodes: sampleEpisodes)
    }
}
#endif
