//
//  ChlURLProtocol.swift
//  URLProtocolTest
//
//  Created by nickLin on 2017/5/25.
//  Copyright © 2017年 nickLin. All rights reserved.
//

import UIKit

class ChlURLProtocol: URLProtocol , URLSessionDelegate , URLSessionDataDelegate{

    fileprivate var session : URLSession?
    fileprivate var sessionTask : URLSessionTask?

    override class func canInit(with request: URLRequest) -> Bool
    {
        return URLProtocol.property(forKey: "process", in: request) == nil
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest
    {
        return request
    }
    
    override func startLoading()
    {
        print(self.request.url ?? "沒有URL")
        let request = (self.request as NSURLRequest).mutableCopy() as! NSMutableURLRequest
        URLProtocol.setProperty("process", forKey: "process", in: request)
        
        session = URLSession.init(configuration: .default, delegate: self, delegateQueue: nil)
        sessionTask = self.session?.dataTask(with: request as URLRequest)
        { [weak self] (data, res, err) in
            guard let strongSelf = self else { return }

            if let err = err
            {
                strongSelf.client?.urlProtocol(strongSelf, didFailWithError: err)
            }
            else
            {
                strongSelf.client?.urlProtocol(strongSelf, didReceive: res!, cacheStoragePolicy: .allowed)
                strongSelf.client?.urlProtocol(strongSelf, didLoad: data!)
                strongSelf.client?.urlProtocolDidFinishLoading(strongSelf)
            }
        }
        sessionTask?.resume()
    }
    
    override func stopLoading()
    {
        self.sessionTask?.cancel()
        self.sessionTask = nil
        self.session = nil
    }
}
