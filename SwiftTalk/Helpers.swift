//
//  Helpers.swift
//  SwiftTalk
//
//  Created by Florian Kugler on 02.07.19.
//  Copyright © 2019 Chris Eidhof. All rights reserved.
//

import SwiftUI
import TinyNetworking

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


