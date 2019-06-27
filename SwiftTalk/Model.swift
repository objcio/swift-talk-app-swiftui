//
//  Model.swift
//  SwiftTalk
//
//  Created by Chris Eidhof on 27.06.19.
//  Copyright © 2019 Chris Eidhof. All rights reserved.
//

import Foundation
import SwiftUI
import TinyNetworking
import Model

extension CollectionView: Identifiable {    
}

let allCollections = Endpoint<[CollectionView]>(json: .get, url: URL(string: "https://talk.objc.io/collections.json")!)

let sampleCollections: [CollectionView] = sample(name: "collections")

func sample<A: Codable>(name: String) -> A {
    let url = Bundle.main.url(forResource: name, withExtension: "json")!
    let data = try! Data(contentsOf: url)
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970
    return try! decoder.decode(A.self, from: data)
}

