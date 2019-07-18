//
//  Episode.swift
//  SwiftTalk
//
//  Created by Chris Eidhof on 04.07.19.
//  Copyright © 2019 Chris Eidhof. All rights reserved.
//

import SwiftUI
import Model
import TinyNetworking

struct PlayState {
    var isPlaying = false {
        didSet {
            if isPlaying { startedPlaying = true }
        }
    }
    var startedPlaying = false
}

struct Episode : View {
    let episode: EpisodeView
    @State var playState = PlayState()
    @ObjectBinding var image: Resource<UIImage>
    init(episode: EpisodeView) {
        self.episode = episode
        self.image = Resource(endpoint: Endpoint(imageURL: episode.poster_url))
    }
    
    var overlay: AnyView? {
        if let i = image.value, !playState.startedPlaying {
            return AnyView(Image(uiImage: i).resizable().aspectRatio(contentMode: .fit))
        } else {
            return nil
        }
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack (alignment: .leading) {
                Text(episode.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .lineLimit(nil)
                Text(episode.durationAndDate)
                    .foregroundColor(.gray)
            }
            Text(episode.synopsis)
                .lineLimit(nil)
                .padding([.bottom])
            Player(url: episode.mediaURL!, isPlaying: $playState.isPlaying, overlay: overlay)
              .aspectRatio(16/9, contentMode: .fit)
            Spacer()
        }.padding([.leading, .trailing])
    }
}

#if DEBUG
struct Episode_Previews : PreviewProvider {
    static var previews: some View {
        Episode(episode: sampleEpisodes[0])
    }
}
#endif
