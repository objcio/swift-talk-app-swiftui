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
    @ObjectBinding var image: Resource<UIImage>
    
    init(_ episode: EpisodeView) {
        self.episode = episode
        self.image = Resource(endpoint: Endpoint(imageURL: episode.poster_url))
    }
    
    var body: some View {
        HStack {
            if image.value != nil {
                Image(uiImage: image.value!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(episode.title)
                    .font(.headline)
                Text(episode.durationAndDate)
                    .font(.subheadline)
                    .color(.gray)
            }
        }
    }
}

struct AllEpisodes : View {
    let episodes: [EpisodeView]
    
    var body: some View {
        List {
            ForEach(episodes) { episode in
                EpisodeItem(episode)
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
