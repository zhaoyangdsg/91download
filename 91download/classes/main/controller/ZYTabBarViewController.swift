//
//  ZYTabBarViewController.swift
//  91download
//
//  Created by me2 on 2018/1/31.
//  Copyright © 2018年 me2. All rights reserved.
//

import UIKit

class ZYTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setChildVcs()
        someSet()
    }
    
    func setChildVcs() {
        let vc1 = ZYNavViewController(rootViewController: ZYMainViewController())
        let tabitem1 = UITabBarItem(title: "主界面", image: UIImage.init(named: "me_normal") , selectedImage: UIImage.init(named: "me_selected"))
        tabitem1.setTitleTextAttributes( [NSAttributedStringKey.foregroundColor:UIColor.gray], for: UIControlState.normal)
        tabitem1.setTitleTextAttributes( [NSAttributedStringKey.foregroundColor:UIColor.green], for: UIControlState.selected)
        vc1.tabBarItem = tabitem1
        
        let vc2 = ZYNavViewController(rootViewController: ZYProfileViewController())
        let tabitem2 = UITabBarItem(title: "我", image: UIImage.init(named: "project_normal") , selectedImage: UIImage.init(named: "project_selected"))
        tabitem2.setTitleTextAttributes( [NSAttributedStringKey.foregroundColor:UIColor.gray], for: UIControlState.normal)
        tabitem2.setTitleTextAttributes( [NSAttributedStringKey.foregroundColor:UIColor.green], for: UIControlState.selected)
        vc2.tabBarItem = tabitem2
        
        let vc3 = ZYNavViewController(rootViewController: ZYDownloadViewController.init(style: UITableViewStyle.grouped))
        let tabitem3 = UITabBarItem(title: "下载", image: UIImage.init(named: "project_normal") , selectedImage: UIImage.init(named: "project_selected"))
        tabitem3.setTitleTextAttributes( [NSAttributedStringKey.foregroundColor:UIColor.gray], for: UIControlState.normal)
        tabitem3.setTitleTextAttributes( [NSAttributedStringKey.foregroundColor:UIColor.green], for: UIControlState.selected)
        vc3.tabBarItem = tabitem3
        
        self.addChildViewController(vc1)
        self.addChildViewController(vc2)
        self.addChildViewController(vc3)
    }
    
    func someSet() {
        if UserDefaults.standard.array(forKey: "localFileAry") != nil {
            return
        }else {
            var ary = Array<String>()
            UserDefaults.standard.set(ary, forKey: "localFileAry")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
