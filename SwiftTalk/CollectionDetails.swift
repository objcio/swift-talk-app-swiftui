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

struct ImageError: Error {}

extension Endpoint where A == UIImage {
    init(imageURL url: URL) {
        self.init(.get, url: url, expectedStatusCode: expected200to300) { data in
            guard let d = data, let i = UIImage(data: d) else {
                return .failure(ImageError())
            }
            return .success(i)
        }
    }
}

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
        VStack {
            Text(collection.title).font(.largeTitle).lineLimit(nil)
            if image.value != nil {
                Image(uiImage: image.value!).resizable().aspectRatio(contentMode: .fit)
            }
            Text(collection.description).lineLimit(nil)
            List {
                ForEach(collectionEpisodes) { episode in
                    Text(episode.title)
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
