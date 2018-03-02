//
//  ZYDownloadTool.swift
//  91download
//
//  Created by me2 on 2018/2/9.
//  Copyright © 2018年 me2. All rights reserved.
//

import UIKit

class ZYDownloadTool: NSObject,URLSessionDownloadDelegate {
    // 下载完成
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("下载完成")
        print("location"+location.path)
        let dirStr:String  = String.cacheDir((downloadTask.response?.suggestedFilename!)!)()
        
        do {
            try FileManager.default.moveItem(atPath: location.path, toPath: dirStr)
        } catch  {
            print("保存文件失败")
        }
        session.invalidateAndCancel()
    }
    // 任务完成时调用，但是不一定下载完成；用户点击暂停后，也会调用这个方法
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("暂停或下载完成")
    }
    // 每下载完一部分调用，可能会调用多次
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("下载了部分")
    }
    // 恢复下载
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        print("恢复下载")
    }
    
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
    /**
     URLSession的使用步骤:
     根据实际情况，创建一个会话配置URLSessionConfiguration对象
     创建会话URLSession对象
     使用会话对象创建一个任务
     调用任务的resume()方法，开始执行任务
    */
    func download(urlStr: String) {
        let url = URL.init(string: urlStr)
        // 给config一个标识 用来区别不同的任务
        let config = URLSessionConfiguration.background(withIdentifier: "0001")
        // 是否允许后台下载
        config.isDiscretionary = true
        let session = URLSession(configuration: config, delegate: self, delegateQueue: .main)
        if let url2 = url {
           let downTask = session.downloadTask(with: url2)
            
            downTask.resume()
        }
        
    }
}
