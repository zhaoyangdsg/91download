//
//  ZYDownloadObject.swift
//  91download
//
//  Created by 扬扬 on 2018/3/3.
//  Copyright © 2018年 me2. All rights reserved.
//

import UIKit

class ZYDownloadObject: NSObject {

    var session:URLSession?
    var sessionTask:URLSessionTask?
    var sessionId:String?
    var resumeData:Data?
}
