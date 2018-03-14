//
//  ZYDownloadManager.swift
//  91download
//
//  Created by me2 on 2018/3/9.
//  Copyright © 2018年 me2. All rights reserved.
//

// 目前功能: 暂停时才会把model.resumeData保存到plist

import UIKit

class ZYDownloadManager: NSObject,URLSessionDownloadDelegate {
    
    // 所有modelAry
    private var allModelAry = Array<ZYDownloadModel>()
    
    // 下载完成modelAry
    private var completedmodelAry = Array<ZYDownloadModel>()
    
    // 正在下载modelAry
    private var downloadingmodelAry = Array<ZYDownloadModel>()
    //
    private let comPath = "comFilesAry.plist".cacheDir()
    private let downPath = "downingAry.plist".cacheDir()
    private let allModelsPath = "modelsAry.plist".cacheDir()
    
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
    
    // 从沙盒中获取model的列表
    private func getModels(from plistPath: String) -> Array<ZYDownloadModel> {
        if let dicAry = NSArray(contentsOfFile: plistPath)  {
            var temAry = Array<ZYDownloadModel>()
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
                
                if let status = modelDic["status"] as? Int {
                    var sts:ZYDownloadStatus
                    switch status {
                    case 0 : sts = .completed
                        break
                    case 1 : sts = .running
                        break
                    default:
                        sts = .completed
                    }
                    
                    model.status = sts
                }
                
                if let resumeData = modelDic["resumeData"] as? Data {
                    model.resumeData = resumeData
                }
                if let progress = modelDic["progress"]  {
                    model.progress = progress as? String
                }
                
                temAry.append(model)
            }
            print(temAry)
            return temAry
        }else {
            print("\(plistPath) 找不到")
            return Array<ZYDownloadModel>()
        }
    }
    
    /** 把本地的modelAry 保存(更新)到沙盒 */
    func saveModelToPlist(from modelAry: Array<ZYDownloadModel>, to path:String) {
        let tmpAry = NSMutableArray()
        
        for model in modelAry {
            var dic = Dictionary<String,Any>()
            dic["fileName"] = model.fileName
            dic["fileUrl"] = model.fileUrl
            dic["localPath"] = model.localPath
            dic["progress"] = model.progress
            dic["resumeData"] = model.resumeData
            // 只保存 completed running 两种状态
            if model.status != ZYDownloadStatus.completed {
                dic["status"] = 1
            }else {
                dic["status"] = 0
            }
            
            tmpAry.add(dic)
        }
        
        if tmpAry.write(toFile: path, atomically: true) {
            print("保存成功")
        }else {
            print("保存失败")
        }
    }
    /** 设置 modelAry */
    private func  setModelAry() {

        self.completedmodelAry = getModels(from: comPath)
        self.downloadingmodelAry = getModels(from: downPath)
    }

    /// model.status改变时 (除了completed) 更新downloadingAry
    func updateDownAry(with newModel:ZYDownloadModel) {
        var i:Int = 0
        for model in self.downloadingmodelAry {
            if model.fileUrl == newModel.fileUrl {
                self.downloadingmodelAry.remove(at: i)
                self.downloadingmodelAry.append(newModel)
                break
            }
            i = i+1
        }
    }
    
    /// 从modelArray中删除model 如果是 completedAry 还要删除 localpath下的文件
    func removeModel(with model:ZYDownloadModel,isCompleted: Bool) {
        var desAry:Array<ZYDownloadModel>
        if isCompleted {
            if model.localPath != nil && FileManager.default.fileExists(atPath: model.localPath!, isDirectory: nil) {
                do {
                    try FileManager.default.removeItem(atPath: model.localPath!)
                }catch {
                    print("\(model.fileName!) 的本地文件路径出错或文件不存在")
                }
            }
            desAry = self.completedmodelAry
        }else {
            desAry = self.downloadingmodelAry
        }
        // 删除modelAry中的model
        var i:Int = 0
        for tmpModel in desAry {
            if model.fileUrl == tmpModel.fileUrl {
                desAry.remove(at: i)
                break
            }
            i = i+1
        }
       
        
    }

    /// 获取downloadingAry
    public func getDownloadingModelAry() -> Array<ZYDownloadModel> {
        
        return getModels(from: downPath)
    }
    /// 获取completedAry
    public func getCompletedModelAry() -> Array<ZYDownloadModel> {
        return getModels(from: comPath)
    }
    
    /// 把内存的downloadingAry保存到plist
    func saveDownAryToPlist() {
        saveModelToPlist(from: downloadingmodelAry, to: downPath)
    }
    /// 把内存的completedAry保存到plist
    func saveCompleteAryToPlist() {
        saveModelToPlist(from: completedmodelAry, to: comPath)
    }
    /// save两个ary到plist
    func saveBothAryToPlist() {
        saveDownAryToPlist()
        saveCompleteAryToPlist()
    }
    
    // 开始下载
    func startDownload(with model:ZYDownloadModel) {
        if model.status != ZYDownloadStatus.completed {
            
            model.status = ZYDownloadStatus.running
            // 已添加到下载队列
            if model.operation != nil {
                // 直接操作model的operation 继续下载
                model.operation?.resume()
                // 更新downloadingAry中的model
                updateDownAry(with: model)
                 
            }else {
                // 创建新operation 赋给model
                let operation = ZYOperation.init(model: model, session: session)
                model.operation = operation
                // 开始下载
                model.operation?.resume()
                // 把新建的model加入downloadingAry
                downloadingmodelAry.append(model)
                // 保存到plist
                saveDownAryToPlist()
            }
        }
    }
    
    // 继续下载
    func resumeDownload(with model:ZYDownloadModel) {
        if model.status != ZYDownloadStatus.completed {
            // 退出程序再回来的时候
            if model.operation == nil {
                // 创建新operation 赋给model
                let operation = ZYOperation.init(model: model, session: session)
                model.operation = operation
            }
            // 在程序中的时候 
            model.operation?.resume()
            model.status = ZYDownloadStatus.running
            
        }
    }
    
    // 暂停下载
    func pauseDownload(with model:ZYDownloadModel) {
        if model.status != ZYDownloadStatus.completed {
            model.operation?.suspend()
            model.status = ZYDownloadStatus.suspended
            // 把resumeData 保存到plist
            saveDownAryToPlist()
            
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
                model.resumeData = nil
                // 从downingAry 删除model
                removeModel(with: model, isCompleted: false)
                // 把model 放入 已完成
                completedmodelAry.append(model)
            } catch  {
                print("保存文件失败")
            }

        // 保存两个ary到plist
        saveBothAryToPlist()
        
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
            // 更新downloadingAry
            updateDownAry(with: model)
        }
        print("_____\(totalBytesWritten) / \(totalBytesExpectedToWrite)")
    }

}
