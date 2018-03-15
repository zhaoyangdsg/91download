//
//  ZYDownloadingCell.swift
//  91download
//
//  Created by me2 on 2018/3/14.
//  Copyright © 2018年 me2. All rights reserved.
//

import UIKit

class ZYDownloadingCell: UITableViewCell {

    var model:ZYDownloadModel?
    {
        didSet {
            self.fileNameLab.text = model?.fileName
            self.progressLab.text = model?.progress
            if model?.status == ZYDownloadStatus.completed {
                statusLab.text = "已下载"
            }else if model?.status == ZYDownloadStatus.running {
                statusLab.text = "下载中"
            }else if model?.status == ZYDownloadStatus.suspended {
                statusLab.text = "暂停中"
            }else {
                statusLab.text = "其他状态"
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    init(style: UITableViewCellStyle , identifier: String) {
        super.init(style: style, reuseIdentifier: identifier)
        setSubView()
    }
    
    private func setSubView() {
        addSubview(fileNameLab)
        addSubview(progressLab)
        addSubview(statusLab)
        
        fileNameLab.snp.makeConstraints { (make) in
            make.left.top.equalTo(self)
            make.width.height.equalTo(self).multipliedBy(0.7)
        }
        
        progressLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(fileNameLab)
            make.top.equalTo(fileNameLab.snp.bottom)
            make.bottom.equalTo(self)
        }
        
        statusLab.snp.makeConstraints { (make) in
            make.right.top.bottom.equalTo(self)
            make.left.equalTo(fileNameLab.snp.right)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /** fileNameLab */
    lazy var fileNameLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 13)
        return lab
    }()
    
    /** progressLab */
    lazy var progressLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 12)
        return lab
    }()
    
    /** status */
    lazy var statusLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 15)
        return lab
        
    }()
    
    
    
}
