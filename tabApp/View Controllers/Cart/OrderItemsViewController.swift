//
//  OrderItemsViewController.swift
//  tabApp
//
//  Created by Enrico Persico on 8/26/20.
//  Copyright © 2020 Enrico Persico. All rights reserved.
//

import UIKit
import FirebaseFirestore

class OrderItemsViewController: UIViewController {
    
    @IBOutlet weak var goToOrders: UIButton!
    @IBOutlet weak var buffer: UIActivityIndicatorView!
    @IBOutlet weak var textLbl: UILabel!
    @IBOutlet weak var checkmark: UIImageView!
    
    var cartItems = [CartViewController.cartItem]()
    var items = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.popToRootViewController(animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        goToOrders.isHidden = true
        for item in cartItems {
            let newItem:[String: Any] = ["cost": item.cost, "name": item.name, "quantity": item.qty, "options": item.options]
            items.append(newItem)
        }
        Firestore.firestore().collection("orders").document().setData([
            "user": UserDefaults.standard.string(forKey: "user")!,
            "items": items,
            "status": "Unprepared",
            "worked_on_by": "N/A",
            "occurred_at": NSDate.now
        ]) { err in
        if let err = err {
            print(err)
            let networkError = self.storyboard?.instantiateViewController(withIdentifier: "networkError")
            networkError?.modalPresentationStyle = .fullScreen
            self.present(networkError!, animated: true, completion: nil)
        } else {
            self.textLbl.isHidden = false
            self.buffer.isHidden = true
            self.goToOrders.isEnabled = true
            self.goToOrders.isHidden = false
            self.checkmark.isHidden = false
            self.items.removeAll()
        }
        }
        Firestore.firestore().collection("users").whereField("type", isEqualTo: "student").whereField("username", isEqualTo: UserDefaults.standard.string(forKey: "user")!).getDocuments { (snapshot, error) in
            if error != nil {
            let networkError = self.storyboard?.instantiateViewController(withIdentifier: "networkError")
            networkError?.modalPresentationStyle = .fullScreen
            self.present(networkError!, animated: true, completion: nil)
        } else {
            for document in (snapshot?.documents)! {
                document.reference.updateData(["cart": []])
            }
        }
        }
    }
    
    @IBAction func goToOrdersClicked(_ sender: Any) {
        self.tabBarController?.selectedIndex = 2
    }
    
}
