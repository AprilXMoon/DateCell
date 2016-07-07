//
//  pickerCell.swift
//  DateCell
//
//  Created by April Lee on 2016/7/1.
//  Copyright © 2016年 april. All rights reserved.
//

import UIKit

protocol pickerCellProtocol {
    func changeWeekday(weekName: String)
}

class pickerCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet var weekPicker: UIPickerView!
    
    var delegate: pickerCellProtocol?
    
    let weekNames = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        weekPicker.dataSource = self
        weekPicker.delegate = self

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: PickerView DateSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return weekNames.count
    }
    
    //MARK: PickerView Delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return weekNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.changeWeekday(weekName: weekNames[row])
    }

}
