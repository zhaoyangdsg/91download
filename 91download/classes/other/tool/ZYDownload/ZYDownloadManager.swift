//
//  ZYDownloadManager.swift
//  91download
//
//  Created by me2 on 2018/3/9.
//  Copyright © 2018年 me2. All rights reserved.
//

import UIKit

class ZYDownloadManager: NSObject,URLSessionDelegate {
    
    // 所有modelAry
    private var modelAry = Array<ZYDownloadModel>()
    
    // 下载完成modelAry
    private var completedmodelAry = Array<ZYDownloadModel>()
    
    // 正在下载modelAry
    private var downloadingmodelAry = Array<ZYDownloadModel>()
    
    private static var manager = ZYDownloadManager()
    class var shared:ZYDownloadManager {
        return manager
    }
    
    private lazy var session:URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "com.zy.91download")
        config.isDiscretionary = true
        let session = URLSession.init(configuration: config, delegate: self, delegateQueue: nil)
        return session
    }()
    
    /** queue */
    lazy var queue: OperationQueue = {
        let queue = OperationQueue.init()
        queue.maxConcurrentOperationCount = 3
        return queue
    }()
    
    override init() {
        super.init()
        
        
    }
    // 开始下载
    func startDownload(with model:ZYDownloadModel) {
        if model.status != ZYDownloadStatus.completed {
            
            model.status = ZYDownloadStatus.running
            
            // 已添加到下载队列
            if model.operation != nil {
                
                // 直接操作model的operation 继续下载
                model.operation?.resume()
            }else {
                // 创建新operation 赋给model
                let operation = ZYOperation.init(model: model, session: session)
                model.operation = operation
                // 开始下载
                model.operation?.resume()
            }
        }
        
    }
    
    // 继续下载
    func resumeDownload(with model:ZYDownloadModel) {
        if model.status != ZYDownloadStatus.completed {
            model.operation?.resume()
        }
    }
    
    // 暂停下载
    func pauseDownload(with model:ZYDownloadModel) {
        if model.status != ZYDownloadStatus.completed {
            model.operation?.suspend()
        }
    }
    
    // 停止/取消下载
    func stopDownload(with model:ZYDownloadModel) {
        if model.status != ZYDownloadStatus.completed {
            model.operation?.cancel()
            // remove model
        }
    }

}
