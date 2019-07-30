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
    @ObservedObject var image: Resource<UIImage>
    @ObservedObject var progress: EpisodeProgress
    init(episode: EpisodeView) {
        self.episode = episode
        self.image = Resource(endpoint: Endpoint(imageURL: episode.poster_url))
        self.progress = EpisodeProgress(episode: episode, progress: 0) // todo real progress
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
                Text(episode.metaInfo)
                    .foregroundColor(.gray)
            }
            Text(episode.synopsis)
                .lineLimit(nil)
                .padding([.bottom])
            Player(url: episode.mediaURL!, isPlaying: $playState.isPlaying, playPosition: $progress.progress, overlay: overlay)
              .aspectRatio(16/9, contentMode: .fit)
            Slider(value: $progress.progress, in: 0...TimeInterval(episode.media_duration))
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
