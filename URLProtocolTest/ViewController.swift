//
//  ViewController.swift
//  URLProtocolTest
//
//  Created by nickLin on 2017/5/25.
//  Copyright © 2017年 nickLin. All rights reserved.
//

import UIKit
import AFNetworking

class ViewController: UIViewController {

    let urlString = "http://ptx.transportdata.tw/MOTC/v2/Rail/THSR/Station?$format=JSON"
    
    
    @IBAction func alamofire()
    {
        
        WebServiceAlamofire.shard.request(urlString, method: .get, parameters: nil).responseData{ res in
            if let json = res.value?.arrayDic
            {
                json.log()
            }
            else
            {
                print(msg:res.error?.localizedDescription)
            }
        }
    
    }

    @IBAction func afnetworking()
    {
        WebServiceAFNetworking.shard.get(urlString, parameters: nil, progress: nil, success: { (task, any) in
            if let json = any as? [[String:Any]]
            {
                json.log()
            }
            
        }) { (task, err) in
            if let data = ((err as NSError?)?.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? Data)?.dic
            {
                data.log()
            }
            print(msg:err.localizedDescription)
        }
    }
    
    @IBAction func webservice()
    {
        WebService.shard.request(method: .GET, url: urlString, parameters: nil) { (data, res, err) in
            if let json = data?.arrayDic
            {
                json.log()
            }
            else
            {
                print(msg: err?.localizedDescription)
            }
        }
    }
    

}

