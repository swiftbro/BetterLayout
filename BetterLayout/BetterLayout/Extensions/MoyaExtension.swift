//
//  MoyaExtension.swift
//  Trading
//
//  Created by Vlad Che on 1/23/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import Foundation
import Moya
import PromiseKit
import Result

fileprivate private(set) var moyaRequestsSet: Set<String> = Set()

extension MoyaProvider {
    static var `default`: MoyaProvider<Target> {
        return MoyaProvider<Target>(stubClosure: MoyaProvider.neverStub,
                                    plugins: [
//                                        networkLogger,
                                        networkActivity
                                    ])
    }
    
    static var networkLogger: PluginType {
        return NetworkLoggerPlugin(verbose: true)
    }
    
    static var networkActivity: PluginType {
        return NetworkActivityPlugin(networkActivityClosure: { change, target in
            switch change {
            case .began: moyaRequestsSet.insert(target.path)
            case .ended: moyaRequestsSet.remove(target.path)
            }
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = moyaRequestsSet.count > 0
            }
        })
    }
}

struct CancelToken: Cancellable {
    var isCancelled: Bool { return inner?.isCancelled ?? false }
    
    func cancel() {
        inner?.cancel()
    }
    
    var inner: Cancellable?
    
}

extension MoyaProvider {
    func request(_ target: Target,
                 callbackQueue: DispatchQueue? = .none,
                 progress: ProgressBlock? = .none) -> Promise<Moya.Response> {
        var cancellable = CancelToken()
        return request(target, callbackQueue: callbackQueue, progress: progress, token: &cancellable)
    }
    
    func request(_ target: Target,
                 callbackQueue: DispatchQueue? = .none,
                 progress: ProgressBlock? = .none,
                 token: inout CancelToken) -> Promise<Moya.Response> {
        return Promise { seal in
            token.inner = self.request(target,
                                       callbackQueue: callbackQueue,
                                       progress: progress,
                                       completion: { result in
                                        switch result {
                                        case .success(let response): seal.fulfill(response)
                                        case .failure(let error):
                                            if case let .underlying(nsError, _) = error, nsError._code == NSURLErrorCancelled {
                                                seal.reject(PMKError.cancelled)
                                            } else {
                                                seal.reject(error)
                                            }
                                        }
            })
        }
    }
}

//extension Promise where T: 

extension Promise where T: Moya.Response {
    
    func filterSuccessfulStatusCodes() -> Promise<Moya.Response> {
        return self.map {
            try $0.filterSuccessfulStatusCodes()
        }
    }
    
    func mapResponse(_ transform: @escaping (String) throws -> String) -> Promise<Moya.Response> {
        return map { (response: Moya.Response) -> Moya.Response in
            let responseString = try String(data: response.data, encoding: .utf8).orThrow("Not a JSON")
            let changed = try transform(responseString).data(using: .utf8).orThrow("Transformed string is not valid")
            return Moya.Response(statusCode: response.statusCode, data: changed, request: response.request, response: response.response)
        }
    }
    
    func decode<D: Decodable>(_ type: D.Type, atKeyPath keyPath: String? = nil, using decoder: JSONDecoder = JSONDecoder(), failsOnEmptyData: Bool = true) -> Promise<D> {
        return self.map {
            try $0.map(type, atKeyPath: keyPath, using: decoder, failsOnEmptyData: failsOnEmptyData)
        }
    }
}

extension Moya.Task {
    static func queryParams(_ params: [String: Any]) -> Moya.Task {
        return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
    }
}

extension Error {
    func print() {
        if let error = self as? MoyaError, let response = error.response, let request = response.request {
            let logger = NetworkLoggerPlugin(verbose: true)
            logger.didReceive(Result(value: response), target: AnyTarget(with: request))
            Swift.print(error)
        }
    }
}
