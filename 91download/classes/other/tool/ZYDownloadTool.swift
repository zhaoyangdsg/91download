//
//  ZYDownloadTool.swift
//  91download
//
//  Created by me2 on 2018/2/9.
//  Copyright © 2018年 me2. All rights reserved.
//

import UIKit

class ZYDownloadTool: NSObject {
    
    static let staticTool = ZYDownloadTool()
    private var downAry:[String]?
    private override init() {
        super.init()
        print("tool init ")
    }
    class func shareTool() ->ZYDownloadTool {
        return staticTool
    }
    
    func addToDownloadAry(url: String) {
        downAry?.append(url)
    }
    // https://www.jianshu.com/p/af3eb9501fe0
    func download(urlStr: String) {
        let url = URL.init(string: urlStr)
        URLSession.shared.downloadTask(with: url!) { (urlData, urlresp, error) in
            
            print(urlresp)
        }
    }
}
