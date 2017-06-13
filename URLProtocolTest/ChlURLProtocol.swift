//
//  ChlURLProtocol.swift
//  URLProtocolTest
//
//  Created by nickLin on 2017/5/25.
//  Copyright © 2017年 nickLin. All rights reserved.
//

import UIKit


class ChlURLProtocol: URLProtocol , URLSessionDataDelegate{

    fileprivate var session : URLSession?
    fileprivate var sessionTask : URLSessionTask?

    override class func canInit(with request: URLRequest) -> Bool
    {
        print(msg: Date().timeIntervalSince1970)
        if let _ = URLProtocol.property(forKey: "process", in: request)
        {
            return false
        }
        if request.url?.host?.contains("127") ?? false{
            print(msg: request.url?.absoluteString ?? "")
            return true
        }
        return false
    }
    
    override class func canInit(with task: URLSessionTask) -> Bool
    {
        print(msg: Date().timeIntervalSince1970)
        guard let request = task.originalRequest else{
            return false
        }
        
        if let _ = URLProtocol.property(forKey: "process", in: request)
        {
            return false
        }
        if request.url?.host?.contains("127") ?? false{
            print(msg: request.url?.absoluteString ?? "")
            return true
        }

        return false
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest
    {
        print(msg: Date().timeIntervalSince1970)
        let newRequest = request as! NSMutableURLRequest
        URLProtocol.setProperty("process", forKey: "process", in: newRequest)
        newRequest.addChlHeader()
        return newRequest as URLRequest
    }
    
    override func startLoading()
    {
        print(msg: Date().timeIntervalSince1970)
        
        
        var req = self.request
        req.httpMethod = "GET"
        session = URLSession.init(configuration: .default, delegate: self, delegateQueue: URLSession.shared.delegateQueue)
        sessionTask = self.session?.dataTask(with: req)
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

extension NSMutableURLRequest {
    func addChlHeader()
    {
        self.addValue("ABCD1234", forHTTPHeaderField: "Token")
    }
}





