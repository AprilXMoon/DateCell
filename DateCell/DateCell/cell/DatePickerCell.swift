//
//  DatePickerCell.swift
//  DateCell
//
//  Created by April Lee on 2016/7/1.
//  Copyright © 2016年 april. All rights reserved.
//

import UIKit

protocol DatePickerCellProtocol {
    func chagneDate(pickerDate: Date)
}

class DatePickerCell: UITableViewCell {

    @IBOutlet var datePicker: UIDatePicker!
    
    var delegate: DatePickerCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    @IBAction func datePickerAction(_ sender: AnyObject) {
        delegate?.chagneDate(pickerDate: datePicker.date)
    }
}
