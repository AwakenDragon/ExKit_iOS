//
// Created by ZhouYuzhen on 2020/5/22.
// Copyright (c) 2020 Beijing Zhujian Technology Co., Ltd. All rights reserved.
//

import Foundation
import Alamofire
import KakaJSON
import RxSwift
import SwifterSwift
import Alamofire

public struct ExClient {
    public var baseURL: String?
    public var headers: HTTPHeaders?
    public var parameters: Parameters?
    public var encoding: ParameterEncoding = URLEncoding.default
    public var interceptor: RequestInterceptor? = nil
    
    public init(_ baseURL: String? = nil) {
        if let base = baseURL {
            self.baseURL = base.hasSuffix("/") ? base : "\(base)/"
        }
    }
    
    public init(_ baseURL: URL? = nil) {
        if let base = baseURL?.absoluteString {
            self.baseURL = base.hasSuffix("/") ? base : "\(base)/"
        }
    }
    
    public func get<T: Convertible>(_ path: String, headers: HTTPHeaders? = nil, parameters: Parameters? = nil) -> Observable<T> {
        request(.get, path, headers: headers, parameters: parameters)
    }
    
    public func post<T: Convertible>(_ path: String, headers: HTTPHeaders? = nil, parameters: Parameters? = nil) -> Observable<T> {
        request(.post, path, headers: headers, parameters: parameters)
    }
    
    public func put<T: Convertible>(_ path: String, headers: HTTPHeaders? = nil, parameters: Parameters? = nil) -> Observable<T> {
        request(.put, path, headers: headers, parameters: parameters)
    }
    
    public func delete<T: Convertible>(_ path: String, headers: HTTPHeaders? = nil, parameters: Parameters? = nil) -> Observable<T> {
        request(.delete, path, headers: headers, parameters: parameters)
    }
    
    public func options<T: Convertible>(_ path: String, headers: HTTPHeaders? = nil) -> Observable<T> {
        request(.options, path, headers: headers, parameters: parameters)
    }
    
    public func patch<T: Convertible>(_ path: String, headers: HTTPHeaders? = nil, parameters: Parameters? = nil) -> Observable<T> {
        request(.patch, path, headers: headers, parameters: parameters)
    }
    
    public func connect<T: Convertible>(_ path: String, headers: HTTPHeaders? = nil, parameters: Parameters? = nil) -> Observable<T> {
        request(.connect, path, headers: headers, parameters: parameters)
    }
    
    public func trace<T: Convertible>(_ path: String, headers: HTTPHeaders? = nil, parameters: Parameters? = nil) -> Observable<T> {
        request(.trace, path, headers: headers, parameters: parameters)
    }
    
    public func request<T: Convertible>(_ method: HTTPMethod = .get, _ path: String, headers: HTTPHeaders? = nil, parameters: Parameters? = nil) -> Observable<T> {
        
        Observable.create { (observer: AnyObserver<T>) in
            let url = "\(baseURL!)\((path.hasPrefix("/") ? path[from: 1] : path)!)"
            var h = headers ?? HTTPHeaders()
            self.headers?.forEach({ header in
                h.add(header)
            })
            
            var p = parameters ?? [String: Any]()
            self.parameters?.forEach({ (key, value) in
                if p[key] == nil {
                    p[key] = value
                }
            })
            
            let request = Session.default.request(url, method: method, parameters: p, encoding: encoding, headers: h, interceptor: interceptor).response(queue: DispatchQueue.global()) { response  in
                if let data = response.data {
                    if let model = data.kj.model(T.self) {
                        observer.onNext(model)
                        observer.onCompleted()
                    } else {
                        let message = String(data: data, encoding: .utf8)
                        observer.onError(ExResponseError(code: -2, message: message))
                    }
                } else {
                    if let error = response.error {
                        observer.onError(error)
                    } else {
                        observer.onError(ExResponseError(code: -1, message: "response data is null"))
                    }
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    public func upload<T: Convertible>(_ path: String, headers: HTTPHeaders? = nil, parameters: Parameters? = nil, file: (key: String, name: String, mimeType: String, data: Data)) -> Observable<ExUploadData<T>> {
        Observable.create { (observer: AnyObserver<ExUploadData<T>>) in
            let url = "\(baseURL!)\((path.hasPrefix("/") ? path[from: 1] : path)!)"
            var h = headers ?? HTTPHeaders()
            self.headers?.forEach({ header in
                h.add(header)
            })
            
            var p = parameters ?? [String: Any]()
            self.parameters?.forEach({ (key, value) in
                if p[key] == nil {
                    p[key] = value
                }
            })
            
            let upload = Session.default.upload(multipartFormData: { data in
                data.append(file.data, withName: file.key, fileName: file.name, mimeType: file.mimeType)
                p.forEach { (key, value) in
                    data.append("\(value)".data(using: .utf8)!, withName: key)
                }
            }, to: url, headers: h, interceptor: interceptor).uploadProgress(queue: DispatchQueue.global(), closure: { progress in
                observer.onNext(.Progress(progress))
            }).response(queue: DispatchQueue.global()) { response  in
                if let data = response.data {
                    if let model = data.kj.model(T.self) {
                        observer.onNext(.Result(model))
                        observer.onCompleted()
                    } else {
                        let message = String(data: data, encoding: .utf8)
                        observer.onError(ExResponseError(code: -2, message: message))
                    }
                } else {
                    if let error = response.error {
                        observer.onError(error)
                    } else {
                        observer.onError(ExResponseError(code: -1, message: "response data is null"))
                    }
                }
            }
            
            return Disposables.create {
                upload.cancel()
            }
        }
    }
}

public enum ExUploadData<T> {
    case Progress(Progress)
    case Result(T)
}

public struct ExResponseError: Error {
    public var code: Int = 0
    public var message: String?
}

public extension Observable {
    
    func io() -> Observable {
        subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
    func main() -> Observable {
        observe(on: MainScheduler.instance)
    }
    
    func task() -> Observable {
        io().main()
    }
}
