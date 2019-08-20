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
    @ObservedObject var store = sharedStore
    @ObservedObject var image: Resource<UIImage>
    var collectionEpisodes: [EpisodeView] {
        return store.episodes.filter { $0.collection == collection.id }
    }
    init(collection: CollectionView) {
        self.collection = collection
        self.image = Resource(endpoint: Endpoint(imageURL: collection.artwork.png))
    }
    var body: some View {        
        List {
            VStack(alignment: .leading) {
                if image.value != nil {                    
                    Image(uiImage: image.value!)
                        .resizable()
                        .aspectRatio(16/9, contentMode: .fit)
                } else {
                    Loader().aspectRatio(16/9, contentMode: .fit)
                }
                VStack(alignment: .leading) {
                    HStack {
                        Text(collection.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .lineLimit(nil)
                        if collection.new {
                            NewBadge()
                        }
                    }
                    Text(collection.episodeCountAndTotalDuration)
                        .foregroundColor(.gray)
                        .padding([.bottom])
                    Text(collection.description)
                        .lineLimit(nil)
                }
            }
            ForEach(collectionEpisodes) { episode in
                NavigationLink(destination: Episode(episode: episode)) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(episode.title)
                            .font(.headline)
                        Text(episode.durationAndDate)
                            .font(.subheadline)
                            .foregroundColor(.gray)
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
