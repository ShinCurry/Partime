//
//  EditProfileTableViewController.swift
//  Partime
//
//  Created by ShinCurry on 16/2/1.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit


enum SelectionStatus {
    case SelectSelf
    case SelectOther
    case SelectNone
}

/**
 *  Table View Edit View Cell 
 *  isShow Data Struct
 */
struct EditViewControl {
    // (是否可以展开编辑 Cell, 是否显示)
    private let defaultHiddenStatus = [[(false, false)], [(true, false), (false, true), (true, false), (false, true), (true, false), (false, true), (false, false)], [(false, false), (false, false)]]
    
    var currentHiddenStatus: [[(Bool, Bool)]]
    init() {
        currentHiddenStatus = defaultHiddenStatus
    }
    
    mutating func selectionAt(indexPath: NSIndexPath) -> SelectionStatus {
        guard currentHiddenStatus[indexPath.section][indexPath.row].0 else {
            return .SelectNone
        }
        
        guard currentHiddenStatus[indexPath.section][indexPath.row+1].1 else {
            currentHiddenStatus[indexPath.section][indexPath.row+1].1 = true
            return .SelectSelf
        }

        currentHiddenStatus = defaultHiddenStatus
        currentHiddenStatus[indexPath.section][indexPath.row+1].1 = false
        return .SelectOther
        
    }
    
}


class EditProfileTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1.00)
        dateFormatter.dateFormat = "yyyy-M-d"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let selection = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(selection, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var editControl = EditViewControl()
    
    // MARK: - Nickname Properties
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var nicknameTextField: UITextField!

    
    
    // MARK: - Gender Picker Properties
    let gender = ["Male", "Female"]
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var genderPicker: UIPickerView!

    
    // MARK: - Date Picker Properties
    var dateFormatter = NSDateFormatter()
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func dateChanged(sender: UIDatePicker) {
        dateLabel.text = dateFormatter.stringFromDate(datePicker.date)
    }
}

// MARK: - Table View Delegate
extension EditProfileTableViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let status = editControl.selectionAt(indexPath)
        if status == .SelectNone {
            return
        }
        if status == .SelectSelf {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let isHidden = editControl.currentHiddenStatus[indexPath.section][indexPath.row].1
        
        switch (indexPath.section, indexPath.row) {
        // Nickname Cell
        case (1, 1):
            if isHidden {
                nicknameTextField.resignFirstResponder()
            } else {
                nicknameTextField.text = nicknameLabel.text
                nicknameTextField.becomeFirstResponder()
            }
        // Gender Cell
        case (1, 3):
            genderPicker.hidden = isHidden
            if isHidden {
                let selectedRow = (genderLabel.text == "Male" ? 0 : 1)
                genderPicker.selectRow(selectedRow, inComponent: 0, animated: true)
            }
        // Birthday Cell
        case (1, 5):
            datePicker.hidden = isHidden
            if isHidden {
                datePicker.date = dateFormatter.dateFromString(dateLabel.text!)!
            }
        default:
            break
        }
        if isHidden {
            return 0
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
}

// MARK: - Gender Picker Delegate and Datasource
extension EditProfileTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gender.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gender[row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderLabel.text = gender[row]
    }
}

// MARK: - Nickname TextField Delegate
extension EditProfileTableViewController {
    
    @IBAction func editingChanged(sender: UITextField) {
        nicknameLabel.text = nicknameTextField.text
    }
}