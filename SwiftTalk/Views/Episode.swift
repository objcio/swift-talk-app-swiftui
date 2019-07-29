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

struct PreviewBadge: View {
    let text: Text = Text("PREVIEW")
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .center) {
                Path { p in
                    p.move(to: .zero)
                    p.addLine(to: CGPoint(x: proxy.size.width, y: 0))
                    p.addLine(to: CGPoint(x: 0, y: proxy.size.height))
                }
                .fill(Color.orange)
                self.text
                    .foregroundColor(.white)
                    .offset(CGSize(width: 0, height: -15))
                    .rotationEffect(.degrees(-45), anchor: .init(x: 0.5, y: 0.5))
            }
        }
    }
}

struct Episode : View {
    let episode: EpisodeView
    @State var playState = PlayState()
    @ObjectBinding var image: Resource<UIImage>
    @ObjectBinding var progress: EpisodeProgress
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
                Text(episode.durationAndDate)
                    .foregroundColor(.gray)
            }
            Text(episode.synopsis)
                .lineLimit(nil)
                .padding([.bottom])
            ZStack(alignment: .topLeading) {
                Player(url: episode.mediaURL!, isPlaying: $playState.isPlaying, playPosition: $progress.progress, overlay: overlay)
                  .aspectRatio(16/9, contentMode: .fit)
                if episode.isPreview {
                    PreviewBadge()
                        .frame(width: 100, height: 100)
                }
            }
            Slider(value: $progress.progress, from: 0, through: TimeInterval(episode.media_duration))
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
