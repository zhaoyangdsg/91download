//
//  ZYDownloadingCell.swift
//  91download
//
//  Created by me2 on 2018/3/14.
//  Copyright © 2018年 me2. All rights reserved.
//

import UIKit

class ZYDownloadingCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    init(with model: ZYDownloadModel , identifier: String) {
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: identifier)
        setSubView()
    }
    
    private func setSubView() {
        addSubview(fileNameLab)
        addSubview(progressLab)
        addSubview(statusLab)
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
