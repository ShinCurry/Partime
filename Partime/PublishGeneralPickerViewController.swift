//
//  PublishGeneralPickerViewController.swift
//  Partime
//
//  Created by ShinCurry on 16/5/5.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit

enum GenderalPickerType {
    case GenderRequire
    case Location
    case JobType
    case PaymentType
    case None
}

class PublishGeneralPickerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        switch type {
        case .GenderRequire:
            navigationItem.title = "选择性别"
            superLabel.text = gender[0].0
            superController.genderRequireCode = 13
        case .Location:
            navigationItem.title = "选择位置"
            superLabel.text = "北京市 东城区"
            superController.districtCode = "110101"
        case .JobType:
            navigationItem.title = "选择职位类型"
            superLabel.text = jobType[0]
            superController.jobTypeCode = 1
        case .PaymentType:
            navigationItem.title = "选择结算方式"
            superLabel.text = paymentType[0]
            superController.paymentTypeCode = 19
        default:
            break
        }
    }

    @IBOutlet weak var pickerView: UIPickerView!
    
    var superController: PublishEditingTableViewController!
    var superLabel: UILabel!
    
    var type: GenderalPickerType = .None
    
    
    // DataSource
    let gender = [("不限", 13), ("男", 11), ("女", 12)]
    let jobType = ["传单派发", "促销导购", "话务客服", "礼仪模特", "老师家教", "服务员", "问卷调查", "审核录入", "地推拉访", "其它"]
    let paymentType = ["日结", "周结", "完工结"]
    
    var value = ""
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

// MARK: - Picker Delegate and Datasource
extension PublishGeneralPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        switch type {
        case .GenderRequire:
            return 1
        case .Location:
            return 3
        case .JobType:
            return 1
        case .PaymentType:
            return 1
        default:
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch type {
        case .GenderRequire:
            return gender.count
        case .JobType:
            return jobType.count
        case .PaymentType:
            return paymentType.count
        case .Location:
            let selectInComponent0 = pickerView.selectedRowInComponent(0)
            
            let provinces = Location.allPlaces.array!
            if component == 0 {
                return provinces.count
            }
            let cities = provinces[selectInComponent0]["sub"].array!
            let selectInComponent1 = pickerView.selectedRowInComponent(1)
            if component == 1 {
                return cities.count
            }
            let counties = cities[selectInComponent1]["sub"].array!
            return counties.count
        default:
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch type {
        case .GenderRequire:
            return gender[row].0
        case .JobType:
            return jobType[row]
        case .PaymentType:
            return paymentType[row]
        case .Location:
            let selectInComponent0 = pickerView.selectedRowInComponent(0)
            
            let province = Location.allPlaces.array!
            if component == 0 {
                return province[row]["value"]["name"].stringValue
            }
            let selectInComponent1 = pickerView.selectedRowInComponent(1)
            let city = province[selectInComponent0]["sub"].array!
            if component == 1 {
                return city[row]["value"]["name"].stringValue
            }
            let county = city[selectInComponent1]["sub"].array!
            return county[row]["name"].stringValue
        default:
            return ""
        }
        
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch type {
        case .GenderRequire:
            superLabel.text = gender[row].0
            superController.genderRequireCode = gender[row].1
        case .JobType:
            superLabel.text = jobType[row]
            superController.jobTypeCode = row+1
        case .PaymentType:
            superLabel.text = paymentType[row]
            superController.paymentTypeCode = row+19
        case .Location:
            let selectInComponent0 = pickerView.selectedRowInComponent(0)
            let selectInComponent1 = pickerView.selectedRowInComponent(1)
            let selectInComponent2 = pickerView.selectedRowInComponent(2)
            if component == 0 {
                pickerView.selectRow(0, inComponent: 1, animated: true)
                pickerView.reloadComponent(1)
                /**
                 * selectRow(row: Int, inComponent: Int, animated: Bool) 需要手动调用
                 * pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
                 */
                self.pickerView(pickerView, didSelectRow: 0, inComponent: 1)
            } else if component == 1 {
                pickerView.selectRow(0, inComponent: 2, animated: true)
                pickerView.reloadComponent(2)
                self.pickerView(pickerView, didSelectRow: 0, inComponent: 2)
            } else {
                let province = Location.allPlaces.array![selectInComponent0]
                let city = province["sub"].array![selectInComponent1]
                let district = city["sub"].array![selectInComponent2]
                
                superLabel.text = "\(city["value"]["name"].stringValue) \(district["name"].stringValue)"
                print(superLabel?.text)
                superController.provinceCode = province["code"].stringValue
                superController.cityCode = city["code"].stringValue
                superController.districtCode = district["code"].stringValue
            }
        default:
            break
        }
        
    }
}