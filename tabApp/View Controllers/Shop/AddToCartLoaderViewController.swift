//
//  AddToCartLoaderViewController.swift
//  tabApp
//
//  Created by Enrico Persico on 8/15/20.
//  Copyright © 2020 Enrico Persico. All rights reserved.
//

import UIKit
import FirebaseFirestore

class AddToCartLoaderViewController: UIViewController {

    @IBOutlet weak var checkmark: UIImageView!
    @IBOutlet weak var buffer: UIActivityIndicatorView!
    @IBOutlet weak var continueShopping: UIButton!
    @IBOutlet weak var textLbl: UILabel!
    
    var name: String!
    var imgurl: String!
    var cost: String!
    var quantity: Int!
    var optionsCount: Int!
    var selectedOptions = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.popToRootViewController(animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        continueShopping.isHidden = true
        var newCost = cost!
        newCost.remove(at: newCost.startIndex)
        let costsDbl = Double(newCost)! * Double(quantity)
        
        var finalOptions = [[AnyHashable: Any]]()
        let optionStrings = Array<String>(selectedOptions.prefix(optionsCount * 2))
        print(optionStrings)
        var i = 0
        while i < optionStrings.count {
            let newOptionName = optionStrings[i]
            i += 1
            let newOptionSelection = optionStrings[i]
            finalOptions.append(["name": newOptionName, "selection": newOptionSelection])
            i += 1
        }
         
        let _: Void = Firestore.firestore().collection("users").whereField("username", isEqualTo: UserDefaults.standard.string(forKey: "user")!).getDocuments { (querySnapshot, err) in
        if let err = err {
            print(err)
            let networkError = self.storyboard?.instantiateViewController(withIdentifier: "networkError")
            networkError?.modalPresentationStyle = .fullScreen
            self.present(networkError!, animated: true, completion: nil)
        } else {
            var tag = 0
            for document in querySnapshot!.documents {
                let data = document.data()
                var cart = data["cart"] as? [[String: Any]] ?? [[String: Any]]()
                for item in cart {
                    if (item["name"] as! String) == self.name {tag += 1}
                }
                let newItem = [
                    "cost": costsDbl,
                    "name": self.name!,
                    "options": finalOptions,
                    "image": self.imgurl!,
                    "quantity": self.quantity!,
                    "tag": tag
                ] as [String : Any]
                cart.append(newItem)
                document.reference.updateData(["cart": cart])
            }
            self.textLbl.isHidden = false
            self.buffer.isHidden = true
            self.continueShopping.isEnabled = true
            self.continueShopping.isHidden = false
            self.checkmark.isHidden = false
        }
        }
    }
    
    @IBAction func continueShoppingClicked(_ sender: Any) {
        navigationController?.popToRootViewController(animated: false)
        self.tabBarController?.selectedIndex = 0
    }
}
