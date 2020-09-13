//
//  ItemDetailsViewController.swift
//  tabApp
//
//  Created by Enrico Persico on 8/13/20.
//  Copyright © 2020 Enrico Persico. All rights reserved.
//

import UIKit

class ItemDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
    @IBOutlet weak var costLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var cost: String!
    var name: String!
    var imgurl: String!
    var image: UIImage!
    
    var options = [[String: Any]]()
    var optionLabels = [UILabel]()
    var userSelectionFields = [UITextField]()
    var selectedOptions = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "option", for: indexPath) as! Options
        
        cell.optionName.text = options[indexPath.row]["name"] as? String
        cell.options = options[indexPath.row]["option_list"] as! [String]
        cell.optionField.inputView = cell.picker
        cell.optionField.inputAccessoryView = cell.toolBar
        
        optionLabels.append(cell.optionName)
        userSelectionFields.append(cell.optionField)
        
        return cell
    }
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        costLbl.text = cost
        nameLbl.text = name
        img.image = image
    }

    @IBOutlet weak var quantity: UITextField!
    @IBOutlet weak var stepper: UIStepper!
    
    @IBAction func stepperTouched(_ sender: Any) {
        quantity.text = String(Int(stepper.value) + 1)
    }
    
    @IBAction func addToCartBtnPressed(_ sender: Any) {
        var requirementsMet = true
        for index in 0..<userSelectionFields.count {
            print(optionLabels[index].text!)
            print(userSelectionFields[index].text!)
            if userSelectionFields[index].text! == "REQUIRED" {
                requirementsMet = false
            }
            selectedOptions.append(optionLabels[index].text!)
            selectedOptions.append(userSelectionFields[index].text!)
        }
        if requirementsMet {
            if Int(quantity.text!)! <= 10 {
                performSegue(withIdentifier: "addToCart", sender: self)
            }
            else {
                let tooManyItemsAlert = UIAlertController(title: "Too Many Items", message: "You may only order 10 of an item", preferredStyle: UIAlertController.Style.alert)
                let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                tooManyItemsAlert.addAction(defaultAction)
                self.present(tooManyItemsAlert, animated: true, completion: nil)
            }
        } else {
            selectedOptions.removeAll()
            let userSelectionAlert = UIAlertController(title: "You Have Not Selected All Options", message: "You have to choose all the required options.", preferredStyle: UIAlertController.Style.alert)
            let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            userSelectionAlert.addAction(defaultAction)
            self.present(userSelectionAlert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addToCart" {
            let controller: AddToCartLoaderViewController
            controller = segue.destination as! AddToCartLoaderViewController
            controller.name = name
            controller.cost = cost
            controller.quantity = Int(quantity.text!)
            controller.imgurl = imgurl
            controller.selectedOptions = selectedOptions
            controller.optionsCount = options.count
            selectedOptions.removeAll()
        }
    }

}
