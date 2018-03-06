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
    
    var currentProgress = ""

    

    var localFileAry = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
        addSubview()
        self.tableView.mj_header.beginRefreshing()
        
        ZYDownloadTool.shareTool().delegate = self
    }
    private func loadLocalFile() {
        if let ary = UserDefaults.standard.array(forKey: "localFileAry") {
            localFileAry = ary as! Array<String>
        }
    }
    
    private func addSubview() {
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.loadLocalFile()
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
        })
        
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
    }
    
    
    
    @objc func start() {
        ZYDownloadTool.shareTool().download(urlStr: "")
    }
    @objc func pause() {
        ZYDownloadTool.shareTool().pauseDownload()
    }
    @objc func resume() {
        ZYDownloadTool.shareTool().resumeDownload()
    }
    
    // MARK: - downloaddelegate
    func didWriteData(bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        currentProgress = "\(totalBytesWritten) / \(totalBytesExpectedToWrite)"
        tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: UITableViewRowAnimation.none)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        UserDefaults.standard.set(localFileAry, forKey: "localFileAry")
       
        print(localFileAry.count)
        if localFileAry.count != 0 {
            return localFileAry.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if localFileAry.count == 0 {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = localFileAry[indexPath.row]
        cell.detailTextLabel?.text = currentProgress
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fileName = localFileAry[indexPath.row]
//        let playerController = ZYPlayVideoViewController()
//        self.navigationController?.pushViewController(playerController, animated: true)
//        playerController.fileUrlStr = fileName
        let urlStr = String.cacheDir(fileName)()
        print(urlStr)
        let item = AVPlayerItem(url:URL(fileURLWithPath: urlStr ))
        let play = AVPlayer(playerItem:item)
        let playController = AVPlayerViewController()
        playController.player = play
        self.present(playController, animated: true, completion: {
            
        })
        
        
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
}
