//
//  String+Extension.swift
//  91download
//
//  Created by me2 on 2018/3/2.
//  Copyright © 2018年 me2. All rights reserved.
//

import Foundation

extension String {
    /// 快速拼接缓存目录
    func cacheDir() -> String
    {
        let path = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!) as NSString
        return path.appendingPathComponent(self)
    }
    /// 快速拼接文档目录
    func docDir() -> String
    {
        let path = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!) as NSString
        return path.appendingPathComponent(self)
    }
    /// 快速拼接文档目录
    func libDir() -> String
    {
        let path = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!) as NSString
        return path.appendingPathComponent(self)
    }
    
    
    /// 快速拼接临时目录
    func tmpDir() -> String
    {
        let path = NSTemporaryDirectory() as NSString
        return path.appendingPathComponent((self as NSString).lastPathComponent)
    }
    
    /// string 转url
    func toUrl() ->URL? {
        if let url = URL.init(string: self) {
            
            return url
        }
        return nil
    }
}
