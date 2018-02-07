//
//  ZYConstant.swift
//  91download
//
//  Created by me2 on 2018/2/7.
//  Copyright © 2018年 me2. All rights reserved.
//

import UIKit

class ZYConstant:NSObject{
    static let kWindow = UIApplication.shared.keyWindow!
    static let kScreenWidth = UIScreen.main.bounds.size.width
    static let kScreenHeigth = UIScreen.main.bounds.size.height
    static let isiPhoneX:Bool = {
        if kScreenHeigth == 812 {
            return true
        }else {
            return false
        }
        }()
    
   static let kItemColor = getColor(red: 43, green: 180, blue: 99, alpha: 1)

     class func getColor( red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat) ->UIColor {
        return UIColor.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
}

