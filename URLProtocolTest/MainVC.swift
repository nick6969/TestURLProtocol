//
//  ViewController.swift
//  URLProtocolTest
//
//  Created by nickLin on 2017/5/25.
//  Copyright © 2017年 nickLin. All rights reserved.
//

import UIKit
import AFNetworking

import Alamofire

let urlString = "http://127.0.0.1:6969/urlProtocolTest"

class MainVC: UIViewController {

    let alamofireBtn    = UIButton()
    let afnetworkingBtn = UIButton()
    let sessionBtn      = UIButton()
    let webViewBtn      = UIButton()
    let wkWebViewBtn    = UIButton()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupUI()
        
        
    }
    
    func setupUI()
    {
        view.backgroundColor = .white
        let buttonArray = [alamofireBtn,afnetworkingBtn,sessionBtn,webViewBtn,wkWebViewBtn]
        let titleName = ["alamofire","afnetworking","session","webView","wkWebView"]
        let actions = [#selector(alamofireAction),#selector(afnetworkingAction),#selector(sessionAction),#selector(webViewAction),#selector(wkWebViewAction)]
        let yMultis : [CGFloat] = [0.4,0.7,1,1.3,1.6]
        
        for index in 0..<buttonArray.count{
            view.addSubview(buttonArray[index])
            buttonArray[index].backgroundColor = .blue
            buttonArray[index].titleLabel?.textColor = .white
            buttonArray[index].setTitle(titleName[index], for: .normal)
            buttonArray[index].addTarget(self, action: actions[index], for: .touchUpInside)
            view.addConstraints([
                buttonArray[index].mLay(.height, 60),
                buttonArray[index].mLay(.width, 160),
                buttonArray[index].mLay(.centerX, .equal, view),
                buttonArray[index].mLay(.centerY, .equal, view, multiplier: yMultis[index] , constant: 0)
                ])
        }
    }

}


// MARK: - Action
extension MainVC {
    
    func alamofireAction()
    {
        
        WebServiceAlamofire.shared.request(urlString, method: .get, parameters: nil).responseData{ res in
            if let json = res.value?.arrayDic
            {
                json.log()
                print(.info, msg: json.count)
            }
            else
            {
                print(.error,msg:res.error?.localizedDescription)
            }
        }
    }
    
    func afnetworkingAction()
    {
        WebServiceAFNetworking.shared.get(urlString, parameters: nil, progress: nil, success: { (task, any) in
            if let json = any as? [[String:Any]]
            {
                json.log()
                print(.info, msg: json.count)
            }
            
        }) { (task, err) in
            if let data = ((err as NSError?)?.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? Data)?.dic
            {
                data.log()
            }
            print(.error,msg:err.localizedDescription)
        }
    }
    
    func sessionAction()
    {
        WebServiceSession.shared.request(method: .GET, url: urlString, parameters: nil) { (data, res, err) in
            if let json = data?.arrayDic
            {
                json.log()
                print(.info, msg: json.count)
            }
            else
            {
                print(.error,msg: err?.localizedDescription)
            }
        }
    }
    
    func webViewAction()
    {
        self.navigationController?.pushViewController(WebViewVC(), animated: true)
    }

    func wkWebViewAction()
    {
        self.navigationController?.pushViewController(WKWebViewVC(), animated: true)
    }
}



























