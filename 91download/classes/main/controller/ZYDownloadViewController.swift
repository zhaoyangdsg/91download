//
//  ZYDownloadViewController.swift
//  91download
//
//  Created by me2 on 2018/3/5.
//  Copyright © 2018年 me2. All rights reserved.
//

import UIKit
import MJRefresh
import AVKit
class ZYDownloadViewController: UITableViewController {
    
    var currentProgress = ""
    
    /// 已完成数组
    var cmpAry = Array<ZYDownloadModel>()
    /// 未完成数组
    var downAry = Array<ZYDownloadModel>()

    var localFileAry = Array<String>()
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubview()
        setupNav()
        self.tableView.mj_header.beginRefreshing()
        self.tableView.rowHeight = 60

    }
    
    private func loadLocalFile() {
        if let ary = UserDefaults.standard.array(forKey: "localFileAry") {
            localFileAry = ary as! Array<String>
        }
    }
    
    private func loadLocalFile2() {
        cmpAry = ZYDownloadManager.shared.getCompletedModelAry()
        downAry = ZYDownloadManager.shared.getDownloadingModelAry()
        print("已完成: \(cmpAry.count)")
        print("未完成: \(downAry.count)")
    }
    
    /// 初始化downAry 把running -> suspend
    func resetDownAryStatusToSuspend() {
        var tmpAry = Array<ZYDownloadModel>()
        for model in downAry {
            model.status = ZYDownloadStatus.suspended
            tmpAry.append(model)
        }
        downAry.replaceSubrange(0..<downAry.count-1, with: tmpAry)
    }
    
    private func setupNav() {
        self.title = "下载管理"
        self.navigationItem.rightBarButtonItem = self.manageBtn
    }
    
    @objc public func testAction() {
        let ary = NSArray.init(contentsOf: "download/plist/test.plist".cacheDir().toUrl()!)

        let lab = UILabel.init()
        lab.text = "download/plist/test.plist".cacheDir()+"______\(ary?.count)"
        lab.numberOfLines = 5
        self.view .addSubview(lab)
        lab.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.left.right.equalTo(self.view)
        }
    }
    private func addSubview() {
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
//            self.loadLocalFile()
            self.loadLocalFile2()
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing ()
        })
        
        
        let headerView = UIView()
        headerView.frame = CGRect.init(x: 0, y: 0, width: 1, height: 40)
        self.tableView.tableHeaderView = headerView
        
        /**
        view.addSubview(startBtn)
        view.addSubview(pauseBtn)
        view.addSubview(resumeBtn)
        
        startBtn.addTarget(self, action: #selector(start), for: UIControlEvents.touchUpInside)
        pauseBtn.addTarget(self, action: #selector(pause), for: UIControlEvents.touchUpInside)
        resumeBtn.addTarget(self, action: #selector(resume), for: UIControlEvents.touchUpInside)
        
        startBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(50)
            make.centerX.equalTo(self.view)
        }
        pauseBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(startBtn.snp.bottom).offset(50)
        }
        resumeBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(pauseBtn.snp.bottom).offset(50)
        }
         */
    }
    
    
    
    @objc func start() {
        ZYDownloadTool.shareTool.download(urlStr: "")
    }
    @objc func pause() {
        ZYDownloadTool.shareTool.pauseDownload()
    }
    @objc func resume() {
        ZYDownloadTool.shareTool.resumeDownload()
    }
    
    // MARK: - downloaddelegate
//    func didWriteData(bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
//        currentProgress = "\(totalBytesWritten) / \(totalBytesExpectedToWrite)"
//        tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: UITableViewRowAnimation.none)
//    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let lab = UILabel()
            lab.text = "正在下载"
            return lab
        }
        if section == 1 {
            let lab = UILabel()
            lab.text = "下载完成"
            return lab
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let view = UIView()
            view.backgroundColor = self.tableView.backgroundColor
            return view
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return downAry.count
        }
        if section == 1 {
            return cmpAry.count
        }

        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellId")as? ZYDownloadingCell
        if cell == nil {
            cell = ZYDownloadingCell.init(style: UITableViewCellStyle.default, identifier: "cellId")
        }
        var model: ZYDownloadModel
        if indexPath.section == 0 {
            model = downAry[indexPath.row]
        } else if indexPath.section == 1 {
            model = cmpAry[indexPath.row]
        }else {
            model = ZYDownloadModel()
        }
        cell?.model = model
        
        model.fileNameChangedBlock = { tmpModel in
            DispatchQueue.main.async {
                cell?.fileNameLab.text = tmpModel.fileName
            }
        }
        
        model.progressChangedBlock = { tmpModel in
            print("下载进度改变_\(tmpModel.progress)")
            DispatchQueue.main.async {
                cell?.progressLab.text = tmpModel.progress
            }
        }
        
        model.statusChangedBlock = { tmpModel in
            print("下载状态改变_\(tmpModel.status)")
            DispatchQueue.main.async {
                if tmpModel.status == ZYDownloadStatus.completed {
                    cell?.statusLab.text = "已下载"
                }else if tmpModel.status == ZYDownloadStatus.running {
                    cell?.statusLab.text = "下载中"
                }else if tmpModel.status == ZYDownloadStatus.suspended {
                    cell?.statusLab.text = "暂停中"
                }else if tmpModel.status == ZYDownloadStatus.failed {
                    cell?.statusLab.text = "下载失败"
                }else {
                    cell?.statusLab.text = "其他状态"
                }
            }
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let fileName = localFileAry[indexPath.row]
//        let playerController = ZYPlayVideoViewController()
//        self.navigationController?.pushViewController(playerController, animated: true)
//        playerController.fileUrlStr = fileName
//        let urlStr = String.cacheDir(fileName)()
//        print(urlStr)
        // 正在下载
        if indexPath.section == 0 {
            let model = self.downAry[indexPath.row]
            if model.status == ZYDownloadStatus.suspended {
                if model.operation != nil {
                    model.operation?.resume()
                }else {
                    ZYDownloadManager.shared.resumeDownload(with: model)
                }
            }else if model.status == ZYDownloadStatus.running {
                if model.operation != nil {
                    model.operation?.suspend()
                }else {
                    ZYDownloadManager.shared.resumeDownload(with: model)
                }
            }else if model.status == ZYDownloadStatus.completed {
                print("model状态:completed")
                let playerController = ZYPlayVideoViewController()
                self.navigationController?.pushViewController(playerController, animated: true)
                playerController.fileUrlStr = model.localPath
            }else {
                ZYDownloadManager.shared.startDownload(with: model)
            }
        }
        if indexPath.section == 1 {
            let model = ZYDownloadManager.shared.getCompletedModelAry()[indexPath.row]
            if model.localPath != nil {
//                let item = AVPlayerItem(url:URL(fileURLWithPath: (model.fileName?.cacheDir())! ))
//                let play = AVPlayer(playerItem:item)
//                let playController = AVPlayerViewController()
//                playController.player = play
//                self.present(playController, animated: true, completion: {
//
//                })
                
                let playerController = ZYPlayVideoViewController()
//                self.navigationController?.pushViewController(playerController, animated: true)
                playerController.fileUrlStr = model.fileName?.cacheDir()
                self.present(playerController, animated: true, completion: nil)
                
            }
            
        }
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
       let deleteAction = UITableViewRowAction.init(style: UITableViewRowActionStyle.default, title: "删除") { (action, indexPath) in
            if indexPath.section == 0 {
                let model = self.downAry[indexPath.row]
                model.operation?.cancel()
                ZYDownloadManager.shared.removeModel(with: model, isCompleted: false)
                self.downAry = ZYDownloadManager.shared.getDownloadingModelAry()
//                ZYDownloadManager.shared.saveDownAryToPlist()
                //tableView.reloadSections(IndexSet.init(integer: 0), with: UITableViewRowAnimation.fade)
            }else {
                let model = self.cmpAry[indexPath.row]
                ZYDownloadManager.shared.removeModel(with: model, isCompleted: true)
                self.cmpAry = ZYDownloadManager.shared.getCompletedModelAry()
                //tableView.reloadSections(IndexSet.init(integer: 1), with: UITableViewRowAnimation.fade)
            }
            tableView.reloadData()
        }
        return [deleteAction]
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /** 开始 */
    lazy var startBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("开始下载", for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.red, for: UIControlState.normal)
        return btn
    }()

    /** 暂停 */
    lazy var pauseBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("暂停下载", for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.red, for: UIControlState.normal)
        return btn
    }()
    
    /** 继续 */
    lazy var resumeBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("继续下载", for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.red, for: UIControlState.normal)
        return btn
    }()
    
    /** 管理 */
    lazy var manageBtn: UIBarButtonItem = {
        
        let btn  = UIBarButtonItem(title: "管理", style: UIBarButtonItemStyle.plain, target: self, action: #selector(testAction))
        return btn
    }()
}
