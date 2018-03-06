//
//  ZYPlayVideoViewController.swift
//  91download
//
//  Created by me2 on 2018/3/6.
//  Copyright © 2018年 me2. All rights reserved.
//

import UIKit
import BMPlayer
class ZYPlayVideoViewController: UIViewController {

    var fileUrlStr:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.addSubview(player)
        player.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(20)
            make.left.right.equalTo(self.view)
            // Note here, the aspect ratio 16:9 priority is lower than 1000 on the line, because the 4S iPhone aspect ratio is not 16:9
            make.height.equalTo(player.snp.width).multipliedBy(9.0/16.0).priority(750)
        }
        
        // Back button event
        player.backBlock = { [unowned self] (isFullScreen) in
            if isFullScreen == true { return }
            let _ = self.navigationController?.popViewController(animated: true)
        }
        guard let fileUrl = fileUrlStr else {
            return
        }
        addVideoSource(fileUrlStr: fileUrl)
    }
    
    func addVideoSource(fileUrlStr: String) {
//        guard let url:URL = )  else {
//            print("资源出错")
//            return
//        }
        let resource = BMPlayerResource(url: URL.init(fileURLWithPath: String.cacheDir(fileUrlStr)()))
        player.setVideo(resource: resource)
        player.autoPlay()
        //Listen to when the player is playing or stopped
        player.playStateDidChange = { (isPlaying: Bool) in
            print("playStateDidChange \(isPlaying)")
        }
        
        //Listen to when the play time changes
        player.playTimeDidChange = { (currentTime: TimeInterval, totalTime: TimeInterval) in
            print("playTimeDidChange currentTime: \(currentTime) totalTime: \(totalTime)")
        }
    }
    
    /** player */
    lazy var player: BMPlayer = {
        let player = BMPlayer()
        
        return player
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
