//
//  ZYDownloadManager.swift
//  91download
//
//  Created by me2 on 2018/3/9.
//  Copyright © 2018年 me2. All rights reserved.
//

import UIKit

class ZYDownloadManager: NSObject,URLSessionDownloadDelegate {
    
    // 所有modelAry
    private var modelAry = Array<ZYDownloadModel>()
    
    // 下载完成modelAry
    private var completedmodelAry = Array<ZYDownloadModel>()
    
    // 正在下载modelAry
    private var downloadingmodelAry = Array<ZYDownloadModel>()
    //
    private let comPath = "comFilesAry.plist".cacheDir()
    private let downPath = "downingAry.plist".cacheDir()
    
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
        setModelAry()
        
    }
    /** 设置 modelAry */
    private func  setModelAry() {

        if let dicAry = NSArray(contentsOfFile: comPath)  {
            for dic in dicAry {
                let modelDic = dic as! Dictionary<String,Any>
                let model = ZYDownloadModel()
                if let fileName = modelDic["fileName"]  {
                    model.fileName = fileName as? String
                }
                if let fileUrl = modelDic["fileUrl"] {
                    model.fileUrl = fileUrl as? String
                }
                
                if let localPath = modelDic["localPath"] {
                    model.localPath = localPath as? String
                }
                completedmodelAry.append(model)
            }
            print(completedmodelAry)
        }else {
            print("completedAry 找不到")
            completedmodelAry = Array<ZYDownloadModel>()
        }
        
        if let dicAry = NSArray(contentsOfFile: downPath) {
            for dic in dicAry {
                let modelDic = dic as! Dictionary<String,Any>
                let model = ZYDownloadModel()
                if let fileName = modelDic["fileName"]  {
                    model.fileName = fileName as? String
                }
                if let fileUrl = modelDic["fileUrl"] {
                    model.fileUrl = fileUrl as? String
                }
                
                if let resumeData = modelDic["resumeData"] {
                    model.resumeData = resumeData as? Data
                }
                downloadingmodelAry.append(model)
            }
            print(downloadingmodelAry)
        }else {
            print("downloadingmodelAry 找不到")
            downloadingmodelAry = Array<ZYDownloadModel>()
        }
        
    }
    
    // 更新 modelAry
    private func updateModelAry() {

        let comAry = NSMutableArray()
        for model in completedmodelAry {
            var dic = Dictionary<String,Any>()
            dic["fileName"] = model.fileName
            dic["fileUrl"] = model.fileUrl
            dic["localPath"] = model.localPath
            comAry.add(dic)
        }
        
        let downAry = NSMutableArray()
        for model in downloadingmodelAry {
            var dic = Dictionary<String,Any>()
            dic["fileName"] = model.fileName
            dic["fileUrl"] = model.fileUrl
            dic["resumeData"] = model.resumeData
            downAry.add(dic)
        }
        
        if comAry.write(toFile: comPath, atomically: true) {
            print("保存成功")
        }else {
            print("保存失败")
        }
        if downAry.write(toFile: downPath, atomically: true) {
            print("保存成功")
        }else {
            print("保存失败")
        }
        
        setModelAry()
    }
    
    public func getDownloadingModelAry() -> Array<ZYDownloadModel> {
        return self.downloadingmodelAry
    }
    public func getCompletedModelAry() -> Array<ZYDownloadModel> {
        return self.completedmodelAry
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
                // 把新建的model加入downloadingAry
                downloadingmodelAry.append(model)
                
                updateModelAry()
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
    
    // MARK: - URLSessionDownloadDelegate
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        // tmp文件地址
        print("location"+location.path)
        let fileName = (downloadTask.response?.suggestedFilename!)!
        let dirStr  = String.cacheDir("mp4/\(fileName)")()
        print("文件路径:\(dirStr)")
        
            if let model = downloadTask.getModel() {
                do {
                    model.status = ZYDownloadStatus.completed
                    try FileManager.default.moveItem(atPath: location.path, toPath: dirStr)
                    model.localPath = dirStr
                    
                    /**
                    let imgUrlStr = dirStr.split(separator: ".")[0].lowercased()+".jpg" //as! String
                    if let imgUrl = imgUrlStr.toUrl() {
                        if let data = UIImageJPEGRepresentation(UIImage.init(imageLiteralResourceName: dirStr), 0.5) {
                            do {
                                try data.write(to: imgUrl)
                                model.fileImg = imgUrlStr
                            }catch {
                                print("保存视频图片错误")
                            }
                            
                        }else {
                            print("视频中获取图片错误")
                        }
                    }else {
                        print("图片名称转url错误")
                    }
                    */
                    // 把model 放入 已完成
                    completedmodelAry.append(model)
                    
                    // 把model 从 未完成 删除
                    var idx = 0
                    for modelItem in downloadingmodelAry {
                        if modelItem.fileUrl == model.fileUrl {
                            downloadingmodelAry.remove(at: idx)
                            break
                        }
                        idx = idx + 1
                    }
                    updateModelAry()
                } catch  {
                    print("保存文件失败")
                }

            //updateModelAry()
            
        }
        //session.invalidateAndCancel()
    }
    
    // 暂停或完成
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("进入暂停或完成")
        if error != nil {
            if let data = (error! as NSError).userInfo["NSURLSessionDownloadTaskResumeData"] as? Data {
                if let model = (task as! URLSessionDownloadTask).getModel() {
                    model.resumeData = data
                }
            }
        }
    }
    // 获取进度
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let fileName = (downloadTask.response?.suggestedFilename!)!
        if let model = downloadTask.getModel() {
            model.fileName = fileName
            model.progress = String("\(totalBytesWritten) / \(totalBytesExpectedToWrite)")
        }
        print("_____\(totalBytesWritten) / \(totalBytesExpectedToWrite)")
    }

}
