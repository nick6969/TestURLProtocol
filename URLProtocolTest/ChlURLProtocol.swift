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

    fileprivate var clientThread : Thread?
    
    override class func canInit(with request: URLRequest) -> Bool
    {
        if let _ = URLProtocol.property(forKey: "process", in: request)
        {
            return false
        }
        if request.url?.host?.contains("127") ?? false{
            return true
        }
        return false
    }
    
    override class func canInit(with task: URLSessionTask) -> Bool
    {
        guard let request = task.originalRequest else{
            return false
        }
        
        if let _ = URLProtocol.property(forKey: "process", in: request)
        {
            return false
        }
        if request.url?.host?.contains("127") ?? false{

            return true
        }

        return false
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest
    {

        let newRequest = request as! NSMutableURLRequest
        URLProtocol.setProperty("process", forKey: "process", in: newRequest)
        newRequest.addChlHeader()
        return newRequest as URLRequest
    }
    
    override func startLoading()
    {

        clientThread = Thread.current

        var req = self.request
        req.httpMethod = "GET"
        session = URLSession.init(configuration: .default, delegate: self, delegateQueue: URLSession.shared.delegateQueue)
        sessionTask = self.session?.dataTask(with: req)
        { [weak self] (data, res, err) in
            guard let strongSelf = self else { return }

            strongSelf.threadSafety {

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
        }
        sessionTask?.resume()
    }
    
    override func stopLoading()
    {
        self.sessionTask?.cancel()
        self.sessionTask = nil
        self.session = nil
    }
    
    func threadSafety(_ clourse:(()->Void)){
        guard let thread = clientThread else { return }
        perform(#selector(performClourseOnThread(_:)), on: thread , with: clourse, waitUntilDone: false)
    }
    
    func performClourseOnThread(_ clourse:Any){
        guard let clourse = clourse as? ()->Void else{ return }
        clourse()
    }
    
    
}

extension NSMutableURLRequest {
    func addChlHeader()
    {
        self.addValue("ABCD1234", forHTTPHeaderField: "Token")
    }
}





