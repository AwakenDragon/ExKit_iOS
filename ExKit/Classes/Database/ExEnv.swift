//
//  ExEnv.swift
//  ExKit
//
//  Created by 周玉震 on 2021/8/18.
//

import Foundation
import RealmSwift
import CoreLocation

public struct ExEnv {
    public var name: String!
    public var label: String?
    public var login: String?
    public var current: Bool = false
    public var debug: Bool = true
    public var urls:[ExURL] = []
    
    public init(name: String, label: String? = nil, login: String? = nil, current: Bool = false, debug: Bool = true, urls:[ExURL] = []) {
        self.name = name
        self.label = label
        self.login = login
        self.current = current
        self.debug = debug
        self.urls = urls
    }
    
    public static let current: ExEnv = {
        let realm = ExDatabase.get()
        var env: ExEnv?
        #if DEBUG
        if let envObj = realm.objects(ExEnvObj.self).filter("current = %@", true).first {
            env = envObj.toEnv()
        }
        #endif
        
        if env == nil,
           let app = UIApplication.shared.delegate as? ExApp,
           let evnDelegate = app.envDelegate,
           let urlDelegate = app.urlDelegate {
            let `release` = evnDelegate.env[evnDelegate.release]
            env = ExEnv(name: `release`!.name)
            env!.label = `release`?.label
            env!.current = true
            env!.debug = false
            let keys = urlDelegate.keys
            for key in keys {
                let url = urlDelegate.values(env: env!.name, key: key)
                env!.urls.append(url)
            }
        }
        return env!
    }()
 
    
    public static var isRelease: Bool { current.debug }
    
    public static func getEnvs() -> [ExEnv] {
        ExDatabase.get().objects(ExEnvObj.self).map { env in
            env.toEnv()
        }
    }
    
    public func getDownload(sub: String = "") -> String {
        let path = "\(NSSearchPathForDirectoriesInDomains(.downloadsDirectory, .userDomainMask, true).first!)/\(name!)/\(sub)"
        
        var isDirectory: ObjCBool = false
        if !FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) || !isDirectory.boolValue {
            try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        return path
    }
    
    public func getPath(sub: String = "") -> String {
        let path = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!)/\(name!)/\(sub)"
        var isDirectory: ObjCBool = false
        if !FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) || !isDirectory.boolValue {
            try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        return path
    }
    
    public func getCache(sub: String = "") -> String {
        let path = "\(NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!)/\(name!)/\(sub)"
        var isDirectory: ObjCBool = false
        if !FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) || !isDirectory.boolValue {
            try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        return path
    }
}

class ExEnvObj: Object {
    
    @objc public dynamic var name: String = "debug"
    @objc public dynamic var label: String? = nil
    @objc public dynamic var login: String? = nil
    @objc public dynamic var current: Bool = false
    @objc public dynamic var debug: Bool = true
    let urls: List<ExURLObj> = List<ExURLObj>()
    
    public override static func primaryKey() -> String? {
        "name"
    }
    
    func toEnv() -> ExEnv {
        ExEnv(name: name, label: label, login: login, current: current, debug: debug, urls: urls.map { obj in
            ExURL(key: obj.key, value: obj.value)
        })
    }
}
