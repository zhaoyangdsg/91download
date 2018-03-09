//
//  ZYDownloadModel.swift
//  91download
//
//  Created by me2 on 2018/3/9.
//  Copyright © 2018年 me2. All rights reserved.
//

import UIKit
enum ZYDownloadStatus {
    case none      // 初始状态
    case running    // 下载中
    case suspended   // 下载暂停
    case completed  // 下载完成
    case failed    // 下载失败
    case waiting    // 等待下载
}



class ZYDownloadModel: NSObject {
    typealias ZYProgressChangedBlock = ((ZYDownloadModel)->())
    typealias ZYStatusChangedBlock = ((ZYDownloadModel)->())
    var fileName:String?
    var fileUrl:String?
    var fileTitle:String?
    var fileImg:String?
    
    var resumeData:Data?
    var localPath:String?
    var progress:String? {
        didSet {
            if progressChangedBlock != nil {
                progressChangedBlock!(self)
            }
        }
    }
    var status:ZYDownloadStatus? {
        didSet {
            if statusChangedBlock != nil {
                statusChangedBlock!(self)
            }
        }
    }
    
    var progressChangedBlock:ZYProgressChangedBlock?
    var statusChangedBlock:ZYStatusChangedBlock?
    
    var operation:ZYOperation?
}
