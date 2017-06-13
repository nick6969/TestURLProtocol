//
//  AppDelegate.swift
//  URLProtocolTest
//
//  Created by nickLin on 2017/5/25.
//  Copyright © 2017年 nickLin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        URLProtocol.registerClass(ChlURLProtocol.self)
        
        window = UIWindow(frame:UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: MainVC())

        
        return true
    }


    
    
}




















// MARK: - 列印出程式碼的檔案名 Func 名 列數 及原本的名稱
public func print<T>(_ type:LogEvent = .info,msg: T,file: String = #file,method: String = #function,line: Int = #line)
{
    // build setting - Other Swift Flags - Debug  Add ( -D  DEBUG )
    #if DEBUG
        Swift.print("\((file as NSString).lastPathComponent)[\(line)]\(type.rawValue), \(method): \(msg)")
    #endif
    
}

public enum LogEvent: String {
    case error   = "[‼️]" // error
    case info    = "[ℹ️]" // info
    case debug   = "[💬]" // debug
    case warning = "[⚠️]" // warning
}




extension Data {
    @nonobjc var arrayDic : [[String:Any]]?{
        do {
            return try JSONSerialization.jsonObject(with: self, options: .mutableContainers ) as? [[String:Any]]
        } catch let error as NSError {
            print(.error ,msg:error.localizedDescription)
        }
        return nil
    }
    @nonobjc var dic : [String:Any]?{
        do {
            return try JSONSerialization.jsonObject(with: self, options: .mutableContainers ) as? [String:Any]
        } catch let error as NSError {
            print(.error ,msg:error.localizedDescription)
        }
        return nil
    }
    @nonobjc var array : [Any]?{
        do {
            return try JSONSerialization.jsonObject(with: self, options: .mutableContainers ) as? [Any]
        } catch let error as NSError {
            print(.error ,msg:error.localizedDescription)
        }
        return nil
    }
    
    @nonobjc var string : String? {
        return String(data: self, encoding: .utf8)
    }
    
    
}

extension Dictionary {
    @nonobjc var json:Data?{
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return jsonData
        } catch {
            return nil
        }
    }
}

extension Array {
    @nonobjc var json:Data?{
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return jsonData
        } catch {
            return nil
        }
    }
}

extension String {
    @nonobjc var ArrayDic : [[String:Any]]?{
        return self.data?.arrayDic
    }
    @nonobjc var Array : [Any]?{
        return self.data?.array
    }
    @nonobjc var Dic : [String:Any]?{
        return self.data?.dic
    }
    @nonobjc var data : Data?{
        return self.data(using: .utf8)
    }
}



extension Collection where Self : ExpressibleByDictionaryLiteral{
    
    func log(file: String = #file,method: String = #function,line: Int = #line){
        Swift.print("\((file as NSString).lastPathComponent)[\(line)], \(method) : 總共有 key / Value \(count) 筆")
        enumerated().forEach{print($0)}
    }
    
}

extension Array where Element : Collection , Element: ExpressibleByDictionaryLiteral {
    
    func log(file: String = #file,method: String = #function,line: Int = #line){
        Swift.print("\((file as NSString).lastPathComponent)[\(line)], \(method) : 總共有 \(count) 筆")
        enumerated().forEach
            {
                print("第 \($0.offset) 筆")
                print("總共有 key / Value \($0.element.count) 筆")
                $0.element.forEach
                    {
                        print($0)
                }
                print("-------------------\n")
        }
    }
}

// MARK:- extension UIView - With AutoLayout
extension UIView {
    // 便利使用的 NSLayoutConstraint
    func mLay(_ attribute:NSLayoutAttribute,_ relatedBy:NSLayoutRelation,_ toItem:Any?,_ attribute1:NSLayoutAttribute , multiplier: CGFloat , constant: CGFloat)->NSLayoutConstraint{
        self.translatesAutoresizingMaskIntoConstraints = false
        return NSLayoutConstraint(item: self, attribute: attribute, relatedBy: relatedBy, toItem: toItem, attribute: attribute1, multiplier: multiplier, constant: constant)
    }
    
    // 便利使用的 NSLayoutConstraint
    func mLay(_ attribute:NSLayoutAttribute,_ relatedBy:NSLayoutRelation,_ toItem:Any?)->NSLayoutConstraint{
        return mLay(attribute, relatedBy, toItem, attribute, multiplier:1, constant:0)
    }
    
    // 便利使用的 NSLayoutConstraint
    func mLay(_ attribute:NSLayoutAttribute,_ constant: CGFloat)->NSLayoutConstraint{
        return mLay(attribute, .equal, nil, attribute,multiplier: 1, constant:constant)
    }
    
    // 便利使用的 NSLayoutConstraint
    func mLay(_ attribute:NSLayoutAttribute,_ relatedBy:NSLayoutRelation,_ toItem:Any?, multiplier: CGFloat, constant: CGFloat)->NSLayoutConstraint{
        return mLay(attribute, relatedBy , toItem, attribute, multiplier:multiplier, constant:constant)
    }
    // 便利使用的 NSLayoutConstraint
    func mLay(_ attribute:NSLayoutAttribute,_ relatedBy:NSLayoutRelation,_ toItem:Any?,  constant: CGFloat)->NSLayoutConstraint{
        return mLay(attribute, relatedBy , toItem, attribute, multiplier:1, constant:constant)
    }
    // 便利使用的 NSLayoutConstraint
    func mLay(_ attribute:NSLayoutAttribute,_ relatedBy:NSLayoutRelation,_ toItem:Any?,_ attribute1:NSLayoutAttribute ,constant: CGFloat)->NSLayoutConstraint{
        return mLay(attribute, relatedBy , toItem, attribute1, multiplier:1, constant:constant)
    }
    
    // 直接四個邊的layout一次處理
    func mLay(pin:UIEdgeInsets,to view:UIView)->[NSLayoutConstraint]{
        return [
            self.mLay(.top    , .equal , view , constant:  pin.top    ),
            self.mLay(.left   , .equal , view , constant:  pin.left   ),
            self.mLay(.bottom , .equal , view , constant: -pin.bottom ),
            self.mLay(.right  , .equal , view , constant: -pin.right  ),
        ]
    }
    
}
