//
//  ZYDownloadObj.swift
//  91download
//
//  Created by me2 on 2018/3/8.
//  Copyright © 2018年 me2. All rights reserved.
//

import UIKit
enum ZYDownloadState {
    case running    // 下载中
    case suspended  // 暂停
    case canceled  // 取消
    case completed  // 下载完成
    case failed     // 下载失败
}

class ZYDownloadObj: NSObject {
    var task:URLSessionDownloadTask?
    var progress:String?
    var identify:String?
    var state:ZYDownloadState?
    var resumeData:Data?
}
