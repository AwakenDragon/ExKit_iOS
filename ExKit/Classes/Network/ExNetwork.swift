//
//  QSNetwork.swift
//  JDXL2.0
//
//  Created by ZhouYuzhen on 2020/2/25.
//  Copyright © 2020 Zhujian. All rights reserved.
//

import Foundation
import Alamofire
import KakaJSON
import RxSwift
import RealmSwift

public class ExNetwork {

    public static let shared: ExNetwork = {
        ExNetwork(env: ExEnv.current)
    }()

    private var env: ExEnv? // 当前运行环境
    private var urls: [String: ExURL] = [:] // 当前环境可访问BaseUrl
    private var clients: [String: ExClient] = [:] // 当前环境网络访问对象, 和urls数量对应
    
    public var reachability: NetworkReachabilityManager?

    required internal init(env: ExEnv) {
        self.env = env
        env.urls.forEach { (url) in
            urls[url.key] = url
            if let host = URL(string: url.value)?.host {
                reachability = NetworkReachabilityManager(host: host)
            }
        }
        if (reachability == nil && urls.count > 0) {
            if let host = URL(string: urls.first!.value.value)?.host {
                reachability = NetworkReachabilityManager(host: host)
            }
        }
        let manager = Session.default
        var headers = manager.session.configuration.httpAdditionalHeaders ?? [:]
        headers["device_model"] = UIDevice.current.model
        headers["system_name"] = UIDevice.current.systemName
        headers["system_version"] = UIDevice.current.systemVersion
        headers["app_version"] = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        headers["app_build"] = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion")
        headers["app_id"] = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier")
        manager.session.configuration.httpAdditionalHeaders = headers

        if let app = UIApplication.shared.exApp {
            app.urlDelegate?.managerBuilder(env: env.name, manager: manager)
        }
    }

    public func getClient(_ key: String) -> ExClient? {
        guard let url = urls[key] else {
            return nil
        }
        var client = clients[key]
        if (client == nil) {
            client = ExClient(url.value)
            clients[key] = client!
        }
        if let app = UIApplication.shared.exApp {
            client = app.urlDelegate?.clientBuilder(env: env!.name, key: key, client: client!) ?? client
        }
        return client
    }
}
