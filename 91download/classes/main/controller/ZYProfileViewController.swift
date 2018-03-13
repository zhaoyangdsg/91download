//
//  ZYProfileViewController.swift
//  91download
//
//  Created by me2 on 2018/1/31.
//  Copyright © 2018年 me2. All rights reserved.
//

import UIKit

class ZYProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blue
        // Do any additional setup after loading the view.
        let view = UIView()
        self.view.addSubview(view)
        
        prepareStep1()
        
    }
    func prepareStep1() {
        let model1 = ZYDownloadModel.init()
        model1.fileUrl = "www.baidu.com"
        model1.fileName = "model1"
        let model2 = ZYDownloadModel.init()
        model1.fileUrl = "www.google.com"
        model1.fileName = "model2"
       
        var dic1 = Dictionary<String,Any>()
//        let fileUrl = model1.fileUrl
        dic1["fileUrl"] = model1.fileUrl
        dic1["fileName"] = model1.fileName
        dic1["data"] = "sss".data(using: String.Encoding.utf8)
//        let dic2 = NSDictionary.init()//objects: [model2.fileUrl,model2.fileName], forKeys: ["fileUrl" as NSCopying,"fileName" as NSCopying])
//        dic2.setValue(model2.fileUrl!, forKey: "fileUrl")
//        dic2.setValue(model2.fileName!, forKey: "fileName")
//        let dicData1 = NSKeyedArchiver .archivedData(withRootObject: dic1)
//        let dicData2 = NSKeyedArchiver .archivedData(withRootObject: dic2)
//        let mtbAry = NSMutableArray.init()
//        mtbAry.add(dicData1)
//        mtbAry.add(dicData2)
        
//        do {
//            try FileManager.default.createDirectory(atPath: "download/plist/test.plist".cacheDir(), withIntermediateDirectories: true, attributes: nil)
//             print(dic1.write(toFile: "download/plist/test.plist".cacheDir(), atomically: true))
//        } catch {
//            print(error)
//
//        }
        
        let filePath = "data.plist".cacheDir();
        let dataSource = NSMutableArray();
        dataSource.add(dic1);
        
//       let ss = (dic1 as NSDictionary).write(toFile: filePath, atomically: true)
//        print(ss)
    
        // 4、将数据写入文件中
       print( dataSource.write(toFile: filePath, atomically: true))
        
       
        
       
        
        
        
//        print(dic1.write(toFile: "download/plist/test.plist".cacheDir(), atomically: true))
//        print("download/plist/test.plist".cacheDir())
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
