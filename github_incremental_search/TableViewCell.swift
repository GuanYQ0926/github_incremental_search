//
//  TableViewCell.swift
//  github_incremental_search
//
//  Created by Yuqing Guan on 2017/06/20.
//  Copyright © 2017 Yuqing Guan. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
