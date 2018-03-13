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
import MBProgressHUD
import SVProgressHUD
class ZYMainViewController: UIViewController,UIWebViewDelegate {
    let hud:MBProgressHUD = MBProgressHUD()
    var temUrlStr:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        setupSubView()
        webView.loadRequest(URLRequest(url: URL(string: "http://91dizhi.space")!))
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
        //navigationItem.rightBarButtonItem = downloadBarbtn
        
    }
    
    @objc func goback() {
        self.webView.goBack()
    }
    func refresh() {
        self.webView.reload()
    }

    // MARK: - webdelegate
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        SVProgressHUD.show(withStatus: "正在加载网页")
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print(webView.request?.url?.absoluteString)
        webView.scrollView.mj_header.endRefreshing()
        SVProgressHUD.dismiss()
        // 判断是否是观影界面
        if checkIsVideoView() {
            // 判断获取mp4地址
            let urlStr =  getMp4Url()
            if urlStr != nil && urlStr != "" {
                // 如果获取到了MP4地址 停止加载
                webView.stopLoading()
                navigationItem.rightBarButtonItem = downloadBarbtn
                downloadBarbtn.action = #selector(downLoad)
                temUrlStr = urlStr
                
                // 视频留言 videodetails videodetails-content
                let commentJS = "document.getElementById('videodetails').style.display=='none' "
                webView.stringByEvaluatingJavaScript(from: commentJS)
                
                let contentJS = "document.getElementById('videodetails-content').style.display=='none' "
                webView.stringByEvaluatingJavaScript(from: contentJS)
                
                let allJS = "document.documentElement.innerHTML"
                let htmlAll = webView.stringByEvaluatingJavaScript(from: allJS)
                print(htmlAll!)
            }
            
            //let videoHtml = webView.stringByEvaluatingJavaScript(from: videoJS)
        }else {
            temUrlStr = nil
        }
        
    }
    
    private func checkIsVideoView() ->Bool {
        let urlStr = (webView.request?.url?.absoluteString)!
        if NSString.init(string: urlStr).contains("view_video.php?viewkey=") {
            return true
        }
        return false
    }
    
    private func getMp4Url() -> String?  {
        //输出网页内容
        let videoJS = "document.getElementById('vid').innerHTML"
        
        let allJS = "document.documentElement.innerHTML"
        //let htmlAll = webView.stringByEvaluatingJavaScript(from: allJS)
        // vid_html5_api src
        let srcJS = "document.getElementById('vid_html5_api').src"
        let scrStr = webView.stringByEvaluatingJavaScript(from: srcJS)
        print("-----"+scrStr!)
        
        return scrStr
    }
    
    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        let hud = MBProgressHUD.showAdded(to: ZYConstant.kWindow , animated: true)
        hud.mode = MBProgressHUDMode.text
        hud.detailsLabel.font = UIFont.boldSystemFont(ofSize: 15)
        hud.detailsLabel.text = "网页加载出错"
        hud.margin = 10
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: 1)
    }
    
    // MARK: - action
    @objc func downLoad() {
        print("downloading..\(temUrlStr)")
        if temUrlStr != nil {
//           let downloadTool = ZYDownloadTool.shareTool
//            downloadTool.download(urlStr: temUrlStr!)
//            //self.navigationController?.pushViewController(ZYDownloadViewController(), animated: true)
//            self.navigationController?.tabBarController?.selectedIndex = 2
//            downloadTool.delegate = navigationController?.tabBarController?.selectedViewController
            
            let model = ZYDownloadModel.init()
            model.fileUrl = temUrlStr
            ZYDownloadManager.shared.startDownload(with: model)
            
        }
    }
    
    // MARK: - lazy
    
    /** backBtn */
    lazy var backBtn: UIBarButtonItem = {
        let btn = UIBarButtonItem.init(image: UIImage.init(named: "back_T_Nav"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(goback))
        
        return btn
    }()
    /** downBtn */
    lazy var downloadBarbtn: UIBarButtonItem = {
        
        let barBtn = UIBarButtonItem.init(customView: downloadBtn)
        
        return barBtn
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
    
    lazy var downloadBtn: UIButton = {
       let btn = UIButton.init(type: UIButtonType.custom)
        btn.setTitle("下载", for: UIControlState.normal)
        btn.setTitle("", for: UIControlState.disabled)
        btn.setTitleColor(ZYConstant.kItemColor, for: UIControlState.normal)
        btn.addTarget(self, action: #selector(downLoad), for: UIControlEvents.touchUpInside)
        return btn
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
