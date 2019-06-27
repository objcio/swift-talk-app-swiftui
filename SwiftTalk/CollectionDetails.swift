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

struct CollectionDetails : View {
    let collection: CollectionView
    @ObjectBinding var image: Resource<UIImage>
    init(collection: CollectionView) {
        self.collection = collection
        let endpoint = Endpoint<UIImage>(.get, url: collection.artwork.png, expectedStatusCode: expected200to300) { data in
            guard let d = data, let i = UIImage(data: d) else {
                return .failure(ImageError())
            }
            return .success(i)
        }
        self.image = Resource<UIImage>(endpoint: endpoint)
    }
    var body: some View {
        VStack {
            Text(collection.title).font(.largeTitle).lineLimit(nil)
            if image.value != nil {
                Image(uiImage: image.value!).resizable().aspectRatio(contentMode: .fit)
            }
            Text(collection.description).lineLimit(nil)
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
