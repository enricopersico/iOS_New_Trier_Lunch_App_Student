//
//  CartViewController.swift
//  tabApp
//
//  Created by Enrico Persico on 9/12/20.
//  Copyright © 2020 Enrico Persico. All rights reserved.
//

import UIKit
import FirebaseFirestore

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var items = [cartItem]()
    var selectedName: String!
    var selectedCost: String!
    var imglink: String!
    var cartTotal: Double = 0
    var selectedImage: UIImage!
    var selectedOptionList = [[String: Any]]()
    
    let refreshControl = UIRefreshControl()
    
    struct cartItem {
        let name: String
        let img: String
        let cost: Double
        let qty: Int
        let options: [[String : Any]]
        let tag: Int
    }
    
    @IBOutlet weak var cartLbl: UILabel!
    @IBOutlet weak var costLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartItem") as! CartItems
        
        cell.name.text = items[indexPath.row].name
        cell.cost.text = String(format: "$%.2f", items[indexPath.row].cost)
        cell.quantity.text = "Quantity: " + String(items[indexPath.row].qty)
        cell.itemTag = items[indexPath.row].tag
        cell.options = items[indexPath.row].options
        
        cell.deleteBtn.addTarget(self, action: #selector(deleteItem), for: UIControl.Event.touchUpInside)
        cell.imgurl = items[indexPath.row].img
        let imageUrl = URL(string: items[indexPath.row].img)!
            
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageUrl) else {return}
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                cell.img.image = image
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CartItems
        selectedCost = cell.cost.text
        selectedName = cell.name.text
        selectedImage = cell.img.image
        imglink = cell.imgurl
        Firestore.firestore().collection("items").whereField("name", isEqualTo: selectedName!).getDocuments { (querySnapshot, error) in
        if let err = error {
            print(err)
            let networkError = self.storyboard?.instantiateViewController(withIdentifier: "networkError")
            networkError?.modalPresentationStyle = .fullScreen
            self.present(networkError!, animated: true, completion: nil)
        } else {
            for document in querySnapshot!.documents {
                let data = document.data()
                self.selectedOptionList = data["optns"] as! [[String : Any]]
                self.performSegue(withIdentifier: "cartToItemDetails", sender: self)
            }
        }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCart()
        updateLabels()
    }
    
    @objc func deleteItem(_ sender: UIButton) {
        let senderTag = sender.tag
        let tag = items[senderTag].tag
        let name = items[senderTag].name
        items.removeAll()
        Firestore.firestore().collection("users").whereField("username", isEqualTo: UserDefaults.standard.string(forKey: "user")!).getDocuments { (querySnapshot, error) in
        if let err = error {
            print(err)
            let networkError = self.storyboard?.instantiateViewController(withIdentifier: "networkError")
            networkError?.modalPresentationStyle = .fullScreen
            self.present(networkError!, animated: true, completion: nil)
        } else {
            for document in querySnapshot!.documents {
                let data = document.data()
                let oldCart = data["cart"] as? [[String: Any]] ?? [[String: Any]]()
                var newCart = [[String: Any]]()
                for item in oldCart {
                    if (item["tag"] as! Int) == tag && (item["name"] as! String) == name {} else {
                        newCart.append([
                            "name": item["name"] as! String,
                            "image": item["image"] as! String,
                            "cost": item["cost"] as! Double,
                            "quantity": item["quantity"] as! Int,
                            "options": item["options"] as! [[String: Any]],
                            "tag": item["tag"] as! Int
                        ])
                        self.items.append(cartItem(
                            name: item["name"] as! String,
                            img: item["image"] as! String,
                            cost: item["cost"] as! Double,
                            qty: item["quantity"] as! Int,
                            options: item["options"] as! [[String: Any]],
                            tag: item["tag"] as! Int
                        ))
                    }
                }
                document.reference.updateData(["cart": newCart])
            }
            self.tableView.reloadData()
            self.updateLabels()
        }
        }
    }
    
    @objc func loadCart() {
        items.removeAll()
        Firestore.firestore().collection("users").whereField("username", isEqualTo: UserDefaults.standard.string(forKey: "user")!).getDocuments { (querySnapshot, error) in
        if let err = error {
            print(err)
            let networkError = self.storyboard?.instantiateViewController(withIdentifier: "networkError")
            networkError?.modalPresentationStyle = .fullScreen
            self.present(networkError!, animated: true, completion: nil)
        } else {
            for document in querySnapshot!.documents {
                let data = document.data()
                let cart = data["cart"] as? [[String: Any]] ?? [[String: Any]]()
                for item in cart {
                    self.items.append(cartItem(
                        name: item["name"] as! String,
                        img: item["image"] as! String,
                        cost: item["cost"] as! Double,
                        qty: item["quantity"] as! Int,
                        options: item["options"] as! [[String: Any]],
                        tag: item["tag"] as! Int
                    ))
                }
                document.reference.updateData(["cart": cart])
            }
            self.tableView.reloadData()
            self.updateLabels()
            self.refreshControl.endRefreshing()
        }
        }
    }

    func updateLabels() {
        cartTotal = 0
        for item in items {
            cartTotal += item.cost
        }
        cartLbl.text = "Cart(\(items.count))"
        costLbl.text = String(format: "$%.2f", cartTotal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl.addTarget(self, action: #selector(self.loadCart), for: .valueChanged)
        tableView.refreshControl = refreshControl
        // Do any additional setup after loading the view.
    }
    
    @IBAction func placeOrderClicked(_ sender: Any) {
        if items.count != 0 {
            performSegue(withIdentifier: "cartToOrder", sender: self)
        } else {
            let userSelectionAlert = UIAlertController(title: "Cart Empty", message: "You cannot order an empty count.", preferredStyle: UIAlertController.Style.alert)
            let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            userSelectionAlert.addAction(defaultAction)
            self.present(userSelectionAlert, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "cartToOrder" {
            let controller: OrderItemsViewController
            controller = segue.destination as! OrderItemsViewController
            controller.cartItems = items
        } else {
            let controller: ItemDetailsViewController
            controller = segue.destination as! ItemDetailsViewController
            controller.cost = selectedCost
            controller.image = selectedImage
            controller.name = selectedName
            controller.options = selectedOptionList
            controller.imgurl = imglink
        }
    }

}
