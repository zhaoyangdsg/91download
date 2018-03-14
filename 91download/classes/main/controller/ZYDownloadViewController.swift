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
class ZYDownloadViewController: UITableViewController,ZYDownloadToolDelegate {
    func didWriteData(bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
    }
    
    
    var currentProgress = ""
    
    /// 已完成数组
    var cmpAry = Array<ZYDownloadModel>()
    /// 未完成数组
    var downAry = Array<ZYDownloadModel>()

    var localFileAry = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
        addSubview()
        setupNav()
        self.tableView.mj_header.beginRefreshing()
        
//        ZYDownloadTool.shareTool.delegate = self
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
    
    private func setupNav() {
        self.navigationItem.rightBarButtonItem = self.manageBtn
    }
    
    @objc public func testAction() {
        let ary = NSArray.init(contentsOf: "download/plist/test.plist".cacheDir().toUrl()!)
        //let ary = NSArray().type(of: init)(contentsOf: URL.init(fileURLWithPath: "download/plist/test.plist".cacheDir(), isDirectory: true))
        //let ary = NSMutableArray(contentsOfFile: "download/plist/test.plist".cacheDir())
//        print(ary)
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
            self.tableView.mj_header.endRefreshing()
        })
        
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
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        UserDefaults.standard.set(localFileAry, forKey: "localFileAry")
        if section == 0 {
            return downAry.count
        }
        if section == 1 {
            return cmpAry.count
        }

        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if localFileAry.count == 0 {
//            return UITableViewCell()
//        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        let progressLab = UILabel()
        cell.contentView.addSubview(progressLab)
        progressLab.snp.makeConstraints { (make) in
            make.centerY.equalTo(cell)
            make.right.equalTo(cell)
        }
        var model = ZYDownloadModel()
        if indexPath.section == 0 {
            model = ZYDownloadManager.shared.getDownloadingModelAry()[indexPath.row]
        }
        if indexPath.section == 1 {
            model =  ZYDownloadManager.shared.getCompletedModelAry()[indexPath.row]
        }
        cell.textLabel?.text = model.fileName
        progressLab.text = model.progress
        model.progressChangedBlock = { tmpModel in
            print(tmpModel.progress)
            DispatchQueue.main.async {
                progressLab.text = model.progress
            }
            
        }
//        cell.textLabel?.text = localFileAry[indexPath.row]
//        cell.detailTextLabel?.text = currentProgress
        

        return cell
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
            let model = ZYDownloadManager.shared.getDownloadingModelAry()[indexPath.row]
            if model.status == ZYDownloadStatus.suspended {
                model.operation?.resume()
            }else if model.status == ZYDownloadStatus.running {
                model.operation?.suspend()
            }else if model.status == ZYDownloadStatus.completed {
                print("model状态未completed")
            }
        }
        if indexPath.section == 1 {
            let model = ZYDownloadManager.shared.getCompletedModelAry()[indexPath.row]
            if model.localPath != nil {
                let item = AVPlayerItem(url:URL(fileURLWithPath: model.localPath! ))
                let play = AVPlayer(playerItem:item)
                let playController = AVPlayerViewController()
                playController.player = play
                self.present(playController, animated: true, completion: {
                    
                })
            }
            
        }
        
        
        
//        let url = URL.init(fileURLWithPath: String.cacheDir(fileName)())
//        let webView = UIWebView()
//        webView.frame = CGRect.init(x: 0, y: 0, width: 300, height: 200)
//        self.view.addSubview(webView)
//        webView.loadRequest(URLRequest.init(url: url))
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
