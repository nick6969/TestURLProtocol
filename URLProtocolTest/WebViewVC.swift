//
//  WebViewVC.swift
//  URLProtocolTest
//
//  Created by nickLin on 2017/5/27.
//  Copyright © 2017年 nickLin. All rights reserved.
//

import UIKit

class WebViewVC: UIViewController {

    @IBOutlet weak var webview: UIWebView!
    
    let urlString = "https://zonble.gitbooks.io/kkbox-ios-dev/content/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .init(rawValue: 0)

        webview.loadRequest(URLRequest(url: URL(string: urlString)!))
    }

}
