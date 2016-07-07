//
//  ViewController.swift
//  DateCell
//
//  Created by April Lee on 2016/7/1.
//  Copyright © 2016年 april. All rights reserved.
//

import UIKit

private let datePickerTag = 99
private let pickerTag = 88

private let titleKey = "title"
private let dateKey = "date"
private let typeKey = "type"

private let weekRow = 1
private let specialDateRow = 2

private let DatePickerCellID = "DatePickerCell"
private let PickerCellID = "pickerCell"
private let TextCellID = "TextCell"

private let DateCellID = "DateCellID"
private let weekCellID = "weekCellID"

private var isDateCell = false

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, DatePickerCellProtocol, pickerCellProtocol {
    
    @IBOutlet var contentTable: UITableView!
    
    var ItemData : [[String: AnyObject]] = []
    
    let dateFormatter = DateFormatter()
    
    var datePickerIndexPath: IndexPath?
    
    var pickerCellRowHeight: CGFloat = 216
    
    let weekNames = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        ItemData = [[titleKey : "StartDay", dateKey : Date(), typeKey : "date"],
                    [titleKey : "EndDay", dateKey : Date(), typeKey : "date"],
                    [titleKey : "weekday", dateKey: 1, typeKey : "week"]]
        
        registerCellNib()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerCellNib() {
        
        let dateNib = UINib(nibName: DatePickerCellID , bundle: nil)
        let pickerNib = UINib(nibName: PickerCellID, bundle: nil)
        let textNib = UINib(nibName: TextCellID, bundle: nil)
        
        contentTable.register(dateNib, forCellReuseIdentifier: DatePickerCellID)
        contentTable.register(pickerNib, forCellReuseIdentifier: PickerCellID)
        contentTable.register(textNib, forCellReuseIdentifier: TextCellID)
        
        contentTable.dataSource = self
        contentTable.delegate = self
    }

    
    //MARK: check
    
    private func hasInlinePicker() -> Bool {
        return (datePickerIndexPath != nil)
    }
    
    private func indexPathHasPicker(indexPath: IndexPath) -> Bool {
        return (hasInlinePicker() && datePickerIndexPath!.row == indexPath.row)
    }
    
    // The indexPath to check if its cell has a UIDatePicker below it
    private func hasPickerForIndexPath(_ indexPath: IndexPath) -> Bool {
        var hasDatePicker = false
        
        var targetRow = indexPath.row
        targetRow += 1
        
        let checkDatePickerCell = contentTable.cellForRow(at: IndexPath(row: targetRow, section: 1))

        if isDateCell {
            let checkDataPicker = checkDatePickerCell?.viewWithTag(datePickerTag)
            hasDatePicker = (checkDataPicker != nil)
        } else {
            let checkWeekPicker = checkDatePickerCell?.viewWithTag(pickerTag)
            hasDatePicker = (checkWeekPicker != nil)
        }
        

        return hasDatePicker
    }
    
    //MARK: DatePicker
    
    private func displayInlineDatePickerForRowAtIndexPath(indexPath: IndexPath) {
        
        //display the date picker inline with the table content
        contentTable.beginUpdates()
        
        var before = false
        if hasInlinePicker() {
            before = datePickerIndexPath!.row < indexPath.row
        }
        
        let sameCellClicked = (datePickerIndexPath?.row ?? 0) - 1 == indexPath.row
        
        if hasInlinePicker() {
            contentTable.deleteRows(at: [datePickerIndexPath!], with: .fade)
            datePickerIndexPath = nil
        }
        
        if !sameCellClicked {
            //hide the old date picker and display the new one
            let rowToReveal = (before ? indexPath.row - 1 : indexPath.row)
            let indexPathToReveal = IndexPath(row: rowToReveal, section: 1)
            
            toggleDatePickerForSelectedIndexPath(indexPathToReveal)
            datePickerIndexPath = IndexPath(row: indexPathToReveal.row + 1, section: 1)
        }
        
        contentTable.deselectRow(at: indexPath, animated: true)
        
        contentTable.endUpdates()
        
        if isDateCell {
            updateDatePicker()
        }
        
    }
    
    private func toggleDatePickerForSelectedIndexPath(_ indexPath: IndexPath) {
        contentTable.beginUpdates()
        
        let indexPaths = [IndexPath(row: indexPath.row + 1, section: 1)]
        
        //check if 'indexPath' has an attached date picker below it
        if hasPickerForIndexPath(indexPath) {
            // found a picker below it, so remove it 
            contentTable.deleteRows(at: indexPaths, with: .fade)
        } else {
            // didn't find a picker below it, so we should insert it
            contentTable.insertRows(at: indexPaths, with: .fade)
        }
        
        contentTable.endUpdates()
    }
    
    private func updateDatePicker() {
        guard datePickerIndexPath != nil else {
            return
        }
        let associatedDatePickerCell = contentTable.cellForRow(at: datePickerIndexPath!) as! DatePickerCell
        
        guard (associatedDatePickerCell.viewWithTag(datePickerTag)) != nil else {
            return
        }
        
        let itemInfo = ItemData[(datePickerIndexPath!.row - 1)]
        associatedDatePickerCell.datePicker.setDate(itemInfo[dateKey] as! Date, animated: false)
        
    }
    
    
    //MARK: tableView DataSource
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPathHasPicker(indexPath: indexPath) ? pickerCellRowHeight : tableView.rowHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else {
            
            if hasInlinePicker() {
                let numRow = ItemData.count
                return numRow + 1
            } else {
                return (ItemData.count)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var modelRow = indexPath.row
        if (datePickerIndexPath != nil && datePickerIndexPath!.row <= indexPath.row) {
            modelRow -= 1
        }
        let itemInfo = ItemData[modelRow]
        
        if indexPath.section == 0 {
            let cell = createNameCell(indexPath)
            return cell
            
        } else {
            
            if datePickerIndexPath != nil && datePickerIndexPath?.row == indexPath.row {
                if isDateCell {
                    let cell = createDatePickerCell(indexPath)
                    return cell
                } else {
                    let cell = createPickerCell(indexPath)
                    return cell
                }
            } else {
                let cell : UITableViewCell!
                if itemInfo[typeKey] as! String == "date" {
                    cell = createDateCell(indexPath)
                    cell.detailTextLabel?.text = dateFormatter.string(from: itemInfo[dateKey] as! Date)
                } else {
                    cell = createWeekCell(indexPath)
                    let index = itemInfo[dateKey] as! Int
                    cell.detailTextLabel?.text = weekNames[index]
                }
            
                cell.textLabel?.text = itemInfo[titleKey] as? String
                
                
                return cell
            }
        }
    }
    
    func createNameCell(_ indexPath: IndexPath) -> TextCell {
        let cell = contentTable.dequeueReusableCell(withIdentifier: TextCellID, for: indexPath) as! TextCell
        cell.name.placeholder = "name"
        cell.name.delegate = self
        
        return cell
    }
    
    func createDatePickerCell(_ indexPath: IndexPath) -> DatePickerCell {
        let cell = contentTable.dequeueReusableCell(withIdentifier: DatePickerCellID, for: indexPath) as! DatePickerCell
        cell.datePicker.setDate(Date(), animated: false)
        cell.delegate = self
        
        return cell
    }
    
    func createPickerCell(_ indexPath: IndexPath) -> pickerCell {
        let cell = contentTable.dequeueReusableCell(withIdentifier:PickerCellID , for: indexPath) as! pickerCell
        cell.weekPicker.selectRow(0, inComponent: 0, animated: false)
        cell.delegate = self
        
        return cell
    }
    
    func createDateCell(_ indexPath: IndexPath) -> UITableViewCell {
        var cell = contentTable.dequeueReusableCell(withIdentifier: DateCellID)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: DateCellID)
            cell?.selectionStyle = .none
        }
        
        return cell!
    }
    
    func createWeekCell(_ indexPath: IndexPath) -> UITableViewCell {
        var cell = contentTable.dequeueReusableCell(withIdentifier: weekCellID)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: weekCellID)
            cell?.selectionStyle = .none
        }
        
        return cell!
    }
    
    //MARK: tableView Delegate
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = #colorLiteral(red: 0.9090711806, green: 0.9090711806, blue: 0.9090711806, alpha: 1)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        isDateCell = (cell?.reuseIdentifier == DateCellID)
        
        if cell?.reuseIdentifier == DateCellID || cell?.reuseIdentifier == weekCellID {
            displayInlineDatePickerForRowAtIndexPath(indexPath: indexPath)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    
    }

    //MARK: textField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:datePickerCell Protocol
    
    func chagneDate(pickerDate: Date) {
        
        let targetedCellIndexPath: IndexPath
        
        if !hasInlinePicker() {
            return
        }
        
        //inline date picker: update the cell's date "above" the date picker
        targetedCellIndexPath = IndexPath(row: datePickerIndexPath!.row - 1, section: 1)
        
        let cell = contentTable.cellForRow(at: targetedCellIndexPath)
        
        //update our data model
        ItemData[targetedCellIndexPath.row][dateKey] = pickerDate
        
        //update the cell's date string
        cell?.detailTextLabel?.text = dateFormatter.string(from: pickerDate)
    }
    
    //MARK: pickerCell Protocol
    
    func changeWeekday(weekName: String) {
        
        let targetedCellIndexPath: IndexPath
        
        if !hasInlinePicker() {
            return
        }
        
        targetedCellIndexPath = IndexPath(row: datePickerIndexPath!.row - 1, section: 1)
        
        let cell = contentTable.cellForRow(at: targetedCellIndexPath)
        
        let index = weekNames.index(of: weekName)
        ItemData[targetedCellIndexPath.row][dateKey] = index
        
        cell?.detailTextLabel?.text = weekNames[index!]
        
    }

}

