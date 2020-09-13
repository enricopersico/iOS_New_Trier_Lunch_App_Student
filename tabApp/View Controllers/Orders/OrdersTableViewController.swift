//
//  OrdersTableViewController.swift
//  tabApp
//
//  Created by Enrico Persico on 8/29/20.
//  Copyright © 2020 Enrico Persico. All rights reserved.
//

import UIKit
import FirebaseFirestore

class OrdersTableViewController: UITableViewController {
       
    var selectedId: String!
    var selectedStatus: String!
    var selectedOrderTime: String!
    var orders = [Order]()

    struct Order {
        var id: String
        var occurred_at: NSDate
        var status: String
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getOrders()
    }
    
    @IBAction func handleRefresh(_ sender: Any) {
        getOrders()
    }
    
    func getOrders() {
        orders.removeAll()
        Firestore.firestore().collection("orders").whereField("user", isEqualTo: UserDefaults.standard.string(forKey: "user")!).getDocuments { (snapshot, error) in
        if let err = error {
            print(err)
            let networkError = self.storyboard?.instantiateViewController(withIdentifier: "networkError")
            networkError?.modalPresentationStyle = .fullScreen
            self.present(networkError!, animated: true, completion: nil)
        } else {
            for document in (snapshot?.documents)! {
                let id = document.documentID
                let data = document.data()
                let status = data["status"] as! String
                let occurred_at = (data["occurred_at"] as! Timestamp).dateValue() as NSDate
                let newOrder = Order(id: id, occurred_at: occurred_at, status: status)
                if status != "Discarded" {self.orders.append(newOrder)}
            }
            //let halfOrders = Array(self.orders[0..<self.orders.count/2])
            //print(halfOrders)
            //self.orders = halfOrders
            self.orders.sort { (lhs: Order, rhs: Order) in
                return lhs.occurred_at.timeIntervalSince1970 > rhs.occurred_at.timeIntervalSince1970
            }
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
        }
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }

       
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "order", for: indexPath) as! Orders

        cell.id.text = orders[indexPath.row].id
        
        let status = orders[indexPath.row].status
        cell.status.text = status
        switch status {
        case "Unprepared":
            cell.status.textColor = UIColor.red
        case "Awaiting Payment":
            cell.status.textColor = UIColor.yellow
        case "Complete":
            cell.status.textColor = UIColor.green
        default:
            cell.status.textColor = UIColor.black
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm a MM/dd/yyyy"
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        let occurred_atAsTime = orders[indexPath.row].occurred_at as Date
        let occurred_atAsString = dateFormatter.string(from: occurred_atAsTime)
        cell.orderTime.text = "Ordered At: " + occurred_atAsString
        
        return cell
    }
       
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! Orders
        selectedId = cell.id.text
        selectedStatus = cell.status.text
        selectedOrderTime = cell.orderTime.text
        performSegue(withIdentifier: "ordersTableToOrderDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ordersTableToOrderDetails" {
            let controller: OrderDetailsViewController
            controller = segue.destination as! OrderDetailsViewController
            controller.id = selectedId
            controller.status = selectedStatus
            controller.orderTime = selectedOrderTime
        }
    }
}
