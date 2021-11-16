//
//  ExAppDelegate.swift
//  ExKit
//
//  Created by 周玉震 on 2021/8/18.
//

@_exported import UIKit
@_exported import Alamofire
@_exported import RealmSwift

public protocol ExEnvDelegate {
    var `release`: String { get }
    var `debug`: String { get }
    var env: Dictionary<String, ExEnv> { get }
}

public protocol ExURLDelegate {
    var keys: [String] { get }
    func values(env: String, key: String) -> ExURL
    func managerBuilder(env: String, manager: Session)
    func clientBuilder(env: String, key: String, client: ExClient) -> ExClient
}

extension ExURLDelegate {
    public func managerBuilder(env: String, manager: Session) {

    }

    public func clientBuilder(env: String, key: String, client: ExClient) -> ExClient {
        client
    }
}

/**
 * Database
 */
public protocol ExDatabaseDelegate {
    var version: Int { get }
    var name: String { get }
    var modules: [Object.Type]? { get }
    var readOnly: Bool { get }
    var memoryIdentifier: String? { get }
    var encryption: Data? { get }
    var migrationBlock: MigrationBlock? { get }
    var deleteIfMigrationNeeded: Bool { get }
}

extension ExDatabaseDelegate {
    public var readOnly: Bool {
        false
    }
    public var memoryIdentifier: String? {
        nil
    }
    public var encryption: Data? {
        nil
    }
    public var migrationBlock: MigrationBlock? {
        nil
    }
    public var deleteIfMigrationNeeded: Bool {
        false
    }
}


open class ExApp: UIResponder, UIApplicationDelegate {
    private let TAG = "ExKit"
    
    open var envDelegate: ExEnvDelegate? { nil }
    open var urlDelegate: ExURLDelegate? { nil }
    open var dbDelegate: ExDatabaseDelegate? { nil }
    
    open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if !self.initEnv() { return false }
        self.initDatabase()
        return true
    }
    
    private func initEnv() -> Bool {
        guard let dbDelegate = envDelegate else {
            print(TAG, "app环境不能为空")
            return false
        }
       
        guard dbDelegate.env[dbDelegate.release] != nil else {
            print(TAG, "正式默认环境不能为空")
            return false
        }
        
        guard dbDelegate.env[dbDelegate.debug] != nil else {
            print(TAG, "测试默认环境不能为空")
            return false
        }
        
        let realm: Realm = ExDatabase.get()

        #if DEBUG
        var newEnvs = [ExEnvObj]()

        for (name, data) in dbDelegate.env {
            let env = ExEnvObj()
            env.name = name
            env.label = data.label
            env.current = name == dbDelegate.debug
            env.debug = name != dbDelegate.release

            if let urlDelegate = self.urlDelegate {
                for key in urlDelegate.keys {
                    let value = urlDelegate.values(env: env.name, key: key)
                    let url = ExURLObj()
                    url.key = key
                    url.value = value.value
                    env.urls.append(url)
                }
            }

            newEnvs.append(env)
        }

        try? realm.write {
            newEnvs.forEach { (env) in
                let oldEnv = realm.object(ofType: ExEnvObj.self, forPrimaryKey: env.name)
                if (oldEnv != nil) {
                    oldEnv!.label = env.label
                    oldEnv!.urls.removeAll()
                    oldEnv!.urls.append(objectsIn: env.urls)
                } else {
                    realm.add(env, update:.all)
                }
            }
        }
        #endif

        return true
    }
    
    private func initDatabase() {
        if let dbDelegate = self.dbDelegate {
            let currentEnv = ExEnv.current
            let manager = FileManager.default
            if (!manager.fileExists(atPath: currentEnv.getPath())) {
                try? manager.createDirectory(atPath: currentEnv.getPath(), withIntermediateDirectories: true, attributes: nil)
            }
            let filePath = URL(fileURLWithPath:currentEnv.getPath() + dbDelegate.name + ".realm")
            NSLog("Database Path: \(filePath)")
            var config = Realm.Configuration(
                fileURL: filePath,
                schemaVersion: UInt64(dbDelegate.version),
                objectTypes: dbDelegate.modules
            )
            if let memoryIdentifier = dbDelegate.memoryIdentifier {
                config.inMemoryIdentifier = memoryIdentifier
            }
            config.readOnly = dbDelegate.readOnly
            config.encryptionKey = dbDelegate.encryption
            config.migrationBlock = dbDelegate.migrationBlock
            config.deleteRealmIfMigrationNeeded = dbDelegate.deleteIfMigrationNeeded
            Realm.Configuration.defaultConfiguration = config
        }
    }
}
