//
//  TextCell.swift
//  DateCell
//
//  Created by April Lee on 2016/7/4.
//  Copyright © 2016年 april. All rights reserved.
//

import UIKit

class TextCell: UITableViewCell {

    @IBOutlet var name: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
