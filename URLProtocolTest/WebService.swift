//
//  WebService.swift
//  URLProtocolTest
//
//  Created by nickLin on 2017/5/25.
//  Copyright © 2017年 nickLin. All rights reserved.
//

import UIKit
import AFNetworking
import Alamofire

class WebService: NSObject , URLSessionDelegate {
    
    static let shard = WebService()
    fileprivate var session : URLSession!
    fileprivate override init() {
        super.init()
        let config = URLSessionConfiguration.default
        config.protocolClasses = [ChlURLProtocol.self]
        self.session = URLSession(configuration: config , delegate: self, delegateQueue: URLSession.shared.delegateQueue)
    }
    
    enum httpMethod : String {
        case POST = "POST"
        case GET  = "GET"
    }
    func request(method:httpMethod ,url:String, parameters:[String : Any]? = nil,timeout:Double = 30 ,handle: @escaping (Data?, URLResponse?, Error?)->Void){
        let parseParameterWithPost = {
            (dic:[String:Any])->Data in
            var par = ""
            dic.forEach{ par += "&\($0.key)=\($0.value)" }
            par.characters.removeFirst(1)
            let urlEncode = par.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)?.replacingOccurrences(of: "+", with: "%2B")
            return urlEncode!.data(using: String.Encoding.utf8)!
        }
        let parseParameterWithGet = {
            (dic:[String:Any])->String in
            var urlString = ""
            for (offset:i,(key:key, value:value)) in dic.enumerated() {
                i == 0 ? (urlString += "?\(key)=\(value)") : (urlString += "&\(key)=\(value)")
            }
            return urlString
        }
        
        var request = URLRequest(url: URL.init(string: url)!)
        request.httpMethod = method.rawValue
        request.timeoutInterval = timeout
        
        switch method {
        case .GET:
            if let para = parameters { request.url = URL.init(string: url + parseParameterWithGet(para))! }
    
        case .POST:
            if let para = parameters { request.httpBody = parseParameterWithPost(para) }
        }
        
        session.dataTask(with: request, completionHandler: handle).resume()

    }
}


class WebServiceAFNetworking : AFHTTPSessionManager{
    
    static let shard = WebServiceAFNetworking.init(baseURL: nil)
    
    fileprivate convenience init(baseURL url: URL?)
    {
        let config = URLSessionConfiguration.default
        config.protocolClasses = [ChlURLProtocol.self]
        self.init(baseURL: url, sessionConfiguration: config)
    }
    
}

class WebServiceAlamofire : SessionManager {
    
    static let shard = WebServiceAlamofire()
    
    fileprivate convenience init()
    {
        let config = URLSessionConfiguration.default
        config.protocolClasses = [ChlURLProtocol.self]
        self.init(configuration: config, delegate:  SessionDelegate(), serverTrustPolicyManager: nil)
    }
    
    
    
    
    
}



