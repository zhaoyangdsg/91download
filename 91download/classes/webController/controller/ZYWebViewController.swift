//
//  ZYWebViewController.swift
//  91download
//
//  Created by me2 on 2018/1/18.
//  Copyright © 2018年 me2. All rights reserved.
//

import UIKit

class ZYWebViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    private func setSubView() {
        self.view.addSubview(webView)
//        webView.frame = CGRect.init(origin: CGPoint.zero, size: CGSize(width: <#T##CGFloat#>, height: <#T##CGFloat#>))
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /** webView */
    lazy var webView: UIWebView = {
        let webView = UIWebView()
        return webView
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
