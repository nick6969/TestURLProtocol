//
//  WebViewVC.swift
//  URLProtocolTest
//
//  Created by nickLin on 2017/5/27.
//  Copyright © 2017年 nickLin. All rights reserved.
//

import UIKit

class WebViewVC: UIViewController {

    fileprivate var webview: UIWebView!
    fileprivate let urlString = "https://zonble.gitbooks.io/kkbox-ios-dev/content/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .init(rawValue: 0)
        webview = UIWebView(frame: .zero)
        view.addSubview(webview)
        view.addConstraints(webview.mLay(pin: .zero, to: view))
        
        webview.loadRequest(URLRequest(url: URL(string: urlString)!))
    }

}
