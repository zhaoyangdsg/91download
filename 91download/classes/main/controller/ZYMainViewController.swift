//
//  ZYMainViewController.swift
//  91download
//
//  Created by me2 on 2018/1/18.
//  Copyright © 2018年 me2. All rights reserved.
//

import UIKit
import SnapKit
import MJRefresh
class ZYMainViewController: UIViewController,UIWebViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        setupSubView()
        webView.loadRequest(URLRequest(url: URL(string: "https://www.baidu.com")!))
        webView.scrollView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.refresh()
        })
    }
    func setupSubView() {
        setupNav()
        self.view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        

    }
    
    func setupNav() {
//        navigationItem.leftBarButtonItems = [backBtn]
        navigationItem.leftBarButtonItem = backBtn
    }
    
    @objc func goback() {
        self.webView.goBack()
    }
    func refresh() {
        self.webView.reload()
    }

    // MARK: - webdelegate
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.scrollView.mj_header.endRefreshing()
    }
    
    // MARK: - lazy
    
    /** backBtn */
    lazy var backBtn: UIBarButtonItem = {
        let btn =  UIBarButtonItem(title: "后退", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goback))
        return btn
    }()
    
    /** webView */
    lazy var webView: UIWebView = {
        let webView = UIWebView()
        webView.delegate = self
        webView.scalesPageToFit = true
        return webView
    }()

    /** mainView */
    lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        return view 
    }()

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
