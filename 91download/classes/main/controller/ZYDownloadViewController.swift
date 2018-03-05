//
//  ZYDownloadViewController.swift
//  91download
//
//  Created by me2 on 2018/3/5.
//  Copyright © 2018年 me2. All rights reserved.
//

import UIKit

class ZYDownloadViewController: UITableViewController {

    var localFileAry = Array<ZYDownloadTool.downloadedObj>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        addSubview()
        if let ary = UserDefaults.standard.array(forKey: "localFileAry") {
            localFileAry = ary as! Array<ZYDownloadTool.downloadedObj>
            
            
            
        }
    }
    
    private func addSubview() {
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
        cell.textLabel?.text = localFileAry[indexPath.row].name
        // Configure the cell...

        return cell
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
