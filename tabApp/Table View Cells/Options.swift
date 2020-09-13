//
//  Options.swift
//  tabApp
//
//  Created by Enrico Persico on 8/13/20.
//  Copyright © 2020 Enrico Persico. All rights reserved.
//

import UIKit

class Options: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {

    let picker = UIPickerView()
    let toolBar = UIToolbar()
    
    var options = [String]()
    
    @IBOutlet weak var optionField: UITextField!
    @IBOutlet weak var optionName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        picker.delegate = self
        picker.dataSource = self
        let doneButton =  UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneClicked))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.setItems([space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
    }
    
    @objc func doneClicked() {
        optionField.resignFirstResponder()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        optionField.text = options[row]
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }
}
