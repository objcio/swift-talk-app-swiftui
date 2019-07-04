//
//  CollectionsList.swift
//  SwiftTalk
//
//  Created by Chris Eidhof on 27.06.19.
//  Copyright © 2019 Chris Eidhof. All rights reserved.
//

import SwiftUI
import Model
import ViewHelpers

struct CollectionsList : View {
    let collections: [CollectionView]
    var body: some View {
        List {
            ForEach(collections) { coll in
                NavigationLink(destination: CollectionDetails(collection: coll)) {
                    VStack(alignment: .leading) {
                        Text(coll.title)
                        Text("\(coll.episodes_count) episodes ᐧ \(TimeInterval(coll.total_duration).hoursAndMinutes)").font(.caption).color(.gray)
                    }
                }
            }
        }.navigationBarTitle(Text("Collections"))
    }
}

#if DEBUG
struct CollectionsList_Previews : PreviewProvider {
    static var previews: some View {
        NavigationView {
            CollectionsList(collections: sampleCollections)
        }
    }
}
#endif
