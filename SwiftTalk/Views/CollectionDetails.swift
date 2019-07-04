//
//  CollectionDetails.swift
//  SwiftTalk
//
//  Created by Chris Eidhof on 27.06.19.
//  Copyright © 2019 Chris Eidhof. All rights reserved.
//

import SwiftUI
import TinyNetworking
import Model

struct CollectionDetails : View {
    let collection: CollectionView
    @ObjectBinding var store = sharedStore
    @ObjectBinding var image: Resource<UIImage>
    var collectionEpisodes: [EpisodeView] {
        return store.episodes.filter { $0.collection == collection.id }
    }
    init(collection: CollectionView) {
        self.collection = collection
        self.image = Resource(endpoint: Endpoint(imageURL: collection.artwork.png))
    }
    var body: some View {
        VStack(alignment: .leading) {
            if image.value != nil {
                Image(uiImage: image.value!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            VStack(alignment: .leading) {
                HStack {
                    Text(collection.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .lineLimit(nil)
                    if collection.new {
                        newBadge
                    }
                }
                Text(collection.episodeCountAndTotalDuration)
                    .color(.gray)
                    .padding([.bottom])
                Text(collection.description)
                    .lineLimit(nil)
            }.padding([.leading, .trailing])
            List {
                ForEach(collectionEpisodes) { episode in
                    NavigationLink(destination: Episode(episode: episode)) {
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
        }
    }
}

#if DEBUG
struct CollectionDetails_Previews : PreviewProvider {
    static var previews: some View {
        CollectionDetails(collection: sampleCollections[1])
    }
}
#endif
