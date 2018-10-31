//
//  PersistentDataStore.swift
//  PinIt
//
//  Created by Rene Haavre on 30/10/2018.
//  Copyright © 2018 Rene Haavre. All rights reserved.
//

import Foundation

final class PersistentDataStore {
    let name: String
    private let dataStoreURL: URL
    
    init(name: String) throws {
        self.name = name
        let documentsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        dataStoreURL = documentsURL.appendingPathComponent(name, isDirectory: true)
        
        try FileManager.default.createDirectory(at: dataStoreURL, withIntermediateDirectories: true, attributes: nil)
    }
}
