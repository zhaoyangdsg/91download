//
//  ZYDownloadTool.swift
//  91download
//
//  Created by me2 on 2018/2/9.
//  Copyright © 2018年 me2. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol ZYDownloadToolDelegate:NSObjectProtocol {
    func didWriteData(bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
}

class ZYDownloadTool: NSObject,URLSessionDownloadDelegate {
    private var resumeData:Data?
    private var session:URLSession?
    private var task:URLSessionDownloadTask?
    private var currentUrl:String?
    
    static let staticTool = ZYDownloadTool()
    // 未完成下载队列
    private var downAry:[String]?
    
    typealias downloadedObj = downloadedObject_struct
    // 本地已下载文件路径
    private var localFileAry:Array<String> = UserDefaults.standard.array(forKey: "localFileAry") as! Array<String>
    
    weak var delegate:ZYDownloadToolDelegate?
   
    struct downloadedObject_struct {
        var name:String
        var path:String
    }
    
    
    // MARK: - <##>URLSessionDownloadDelegate
    // http://www.cocoachina.com/swift/20170713/19853.html

    // 下载完成
    internal func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("下载完成")
        downloadTask.response?.suggestedFilename
        // tmp文件地址
        print("location"+location.path)
        let fileName = (downloadTask.response?.suggestedFilename!)!
        let dirStr  = String.cacheDir("download/video/\(fileName)")()
        print("文件路径:\(dirStr)")
        do {
            try FileManager.default.moveItem(atPath: location.path, toPath: dirStr)
            //let downloadObj = downloadedObj(name: fileName, path: dirStr)
            localFileAry.append(fileName)
            print("已下载的文件: /n \(localFileAry)")
            // 存储已下载文件名
            UserDefaults.standard.set(localFileAry, forKey: "localFileAry")
            UserDefaults.standard.synchronize()
            
        } catch  {
            print("保存文件失败")
        }
        session.invalidateAndCancel()
    }
    // 任务完成时调用，但是不一定下载完成；用户点击暂停后，也会调用这个方法
    internal func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("暂停或下载完成")
        if error != nil {
            
            if let data = (error! as NSError).userInfo["NSURLSessionDownloadTaskResumeData"] as? Data {
                resumeData = data
            }
        }
    }
    // 每下载完一部分调用，可能会调用多次
    internal func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        print("下载了部分")
        print("已下载: \(totalBytesWritten)")
        print("总大小: \(totalBytesExpectedToWrite)")
        if self.delegate != nil {
            delegate?.didWriteData(bytesWritten: bytesWritten, totalBytesWritten: totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite)
        }
        
    }
    // 恢复下载
    internal func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        print("恢复下载")
    }
    

    private override init() {
        super.init()
        print("tool init ")
    }
    private static var tool = ZYDownloadTool()
    class var shareTool:ZYDownloadTool {
        return tool
    }
    
    // 加入下载队列
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
    // 开始下载
    func download(urlStr: String?) {
        
        print("开始下载")
        var url:URL?
        if urlStr != nil {
             url = URL.init(string: urlStr!)
            // test
            //url = URL.init(string: "http://120.25.226.186:32812/resources/videos/minion_01.mp4")
            currentUrl = urlStr
        }
        
        // 给config一个标识 用来区别不同的任务
        let config = URLSessionConfiguration.background(withIdentifier: "com.zy.91download_\(Date())")
        // 是否允许后台下载
        config.isDiscretionary = true
        let session = URLSession(configuration: config, delegate: self, delegateQueue: .main)
        
        if let url2 = url {
           let downTask = session.downloadTask(with: url2)
            downTask.resume()
           // task = downTask
        }
    }
    // 恢复下载
    func resumeDownload() {
        if resumeData != nil {
            let task = session!.downloadTask(withResumeData: resumeData!)
            task.resume()
            self.task = task
        }
    }
    
    // 暂停下载
    func pauseDownload() {
        if task != nil {
            task!.cancel(byProducingResumeData: { (data) in
                if data != nil {
                    self.resumeData = data
                }
            })
        }
    }
}
