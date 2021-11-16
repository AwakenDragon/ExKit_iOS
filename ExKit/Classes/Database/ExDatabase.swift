//
//  ExDatabase.swift
//  ExKit
//
//  Created by 周玉震 on 2021/8/18.
//

import Foundation
import RealmSwift

public class ExDatabase {
    public static let DB_NAME = "ExKit.realm"
    public static let DB_PATH =  "\(NSHomeDirectory())/Documents/ExKit/"
    public static func get() -> Realm {
        let manager = FileManager.default
        if (!manager.fileExists(atPath: DB_PATH)) {
            try? manager.createDirectory(atPath: DB_PATH, withIntermediateDirectories: true, attributes: nil)
        }
        
        let file = URL(fileURLWithPath: DB_PATH + DB_NAME)
        let config = Realm.Configuration(fileURL: file, objectTypes: [ExEnvObj.self, ExURLObj.self])
        return try! Realm(configuration: config)
    }
    
    public static func `default`() -> Realm {
        try! Realm()
    }
}
