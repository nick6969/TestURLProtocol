//
//  WKWebViewVC.swift
//  URLProtocolTest
//
//  Created by nickLin on 2017/6/10.
//  Copyright © 2017年 nickLin. All rights reserved.
//

import UIKit
import WebKit

class WKWebViewVC: UIViewController {

    fileprivate var web : WKWebView!
//    fileprivate let urlString = "https://zonble.gitbooks.io/kkbox-ios-dev/content/"

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .init(rawValue: 0)
        web = WKWebView(frame: .zero , configuration: WKWebViewConfiguration() )
        view.addSubview(web)
        view.addConstraints(web.mLay(pin: .zero, to: view))
        web.load(URLRequest(url: URL(string: urlString)!))

    }


}
