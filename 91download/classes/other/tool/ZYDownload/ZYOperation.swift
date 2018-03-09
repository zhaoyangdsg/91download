//
//  ZYOperation.swift
//  91download
//
//  Created by me2 on 2018/3/9.
//  Copyright © 2018年 me2. All rights reserved.
//

import UIKit

extension URLSessionDownloadTask {
    private struct AssociatedKeys {
        static var model = "zy_model"
    }
    func setModel(model:ZYDownloadModel) {
        objc_setAssociatedObject(self, &AssociatedKeys.model, model, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
    }
    func getModel() -> ZYDownloadModel {
        objc_getAssociatedObject(self, &AssociatedKeys.model)
    }
}

class ZYOperation: Operation {
    weak var model:ZYDownloadModel?
    weak var session:URLSession?
    var task:URLSessionDownloadTask?
    
//    override init() {
//        super.init()
//    }
    
    public init(model:ZYDownloadModel ,session:URLSession) {
        super.init()
        self.model = model
        self.session = session
        setTask()
    }
    // 设置task
    private func setTask() {
        if self.model != nil && self.session != nil {
            if let url = model?.fileUrl {
                let request = URLRequest.init(url: URL.init(string: url)!)
                self.task = session?.downloadTask(with: request)
            }
        }
        configTask()
    }
    // 配置task 把model配置给task
    private func configTask() {
        if model != nil {
            task?.setModel(model: model!)
        }
    }
    // 开始
    public func resume() {
        if model != nil && session != nil {
            // 如果状态是complete return 否则 状态都改为running
            if model?.status == ZYDownloadStatus.completed {
                return
            }
            model?.status = ZYDownloadStatus.running
            if model?.resumeData != nil {
                // 有缓存数据
                task = session?.downloadTask(withResumeData: (model?.resumeData)!)
                // 给task 配置model
                configTask()
            }else if task == nil {
                // task 还没有设置 先去设置
                setTask()
            }
            // 调用task原始resume方法
            self.task?.resume()
        }else {
            print("ZYOperation.resume(): model或session为nil")
        }
        
    }
    // 暂停 挂起
    public func suspend() {
        if task != nil {
            weak var weakSelf = self
            task?.cancel(byProducingResumeData: { (data) in
                // 缓存已下载数据
                weakSelf!.model?.resumeData = data
                // 完成后更新status
                DispatchQueue.main.async {
                    weakSelf?.model?.status = ZYDownloadStatus.suspended
                }
            })
            // 调用原始方法
            task?.suspend()
        }
    }
    /** 取消 重写cancel */
    public override func cancel() {
        if let model = self.model {
            model.status = ZYDownloadStatus.completed
        }
        if let task = self.task {
            task.cancel()
        }
        task = nil
        
        super.cancel()
    }
    
    // 结束
    public func finish() {
        
    }
    
    // operation 销毁时 task = nil
    deinit {
        task = nil
    }
}
