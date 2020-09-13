//
//  ItemsTableViewController.swift
//  tabApp
//
//  Created by Enrico Persico on 8/12/20.
//  Copyright © 2020 Enrico Persico. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ItemsTableViewController: UITableViewController {
    
    var items = [Item]()
    var category: String!
    
    var selectedName: String!
    var selectedCost: String!
    var selectedImage: UIImage!
    var selectedOptionList = [[String: Any]]()
    var imglink: String!
    
    struct Item {
        let name: String
        let url: String
        let cost: Double
        var options = [[String: Any]]()
    }
      
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getItems()
    }
    
    @IBAction func handleRefresh(_ sender: Any) {
        getItems()
    }
    
    func getItems() {
        items.removeAll()
        Firestore.firestore().collection("items").whereField("category", isEqualTo: category!).getDocuments { (snapshot, error) in
        if let err = error {
            print(err)
            let networkError = self.storyboard?.instantiateViewController(withIdentifier: "networkError")
            networkError?.modalPresentationStyle = .fullScreen
            self.present(networkError!, animated: true, completion: nil)
        } else {
            for document in (snapshot?.documents)! {
                let data = document.data()
                let name = data["name"] as! String
                let url = data["imageurl"] as! String
                let cost = data["cost"] as! Double
                let options = data["optns"] as! [[String: Any]]
                let newItem = Item(name: name, url: url, cost: cost, options: options)
                self.items.append(newItem)
            }
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
        }
    }

       // MARK: - Table view data source
       /*
       override func numberOfSections(in tableView: UITableView) -> Int {
           // #warning Incomplete implementation, return the number of sections
           return 0
       }
       */

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           // #warning Incomplete implementation, return the number of rows
        return items.count
    }

       
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath) as! Items
           
           cell.name.text = items[indexPath.row].name
           cell.cost.text = String(format: "$%.2f", items[indexPath.row].cost)
        
           cell.options = items[indexPath.row].options
           
           let url = NSURL(string: items[indexPath.row].url)
           let data = NSData(contentsOf: url! as URL)
           cell.img.image = UIImage(data: data! as Data)
           cell.imgurl = items[indexPath.row].url

           return cell
    }
       
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let cell = tableView.cellForRow(at: indexPath) as! Items
           selectedName = cell.name.text
           selectedCost = cell.cost.text
           selectedImage = cell.img.image
            selectedOptionList = cell.options
           imglink = cell.imgurl
           performSegue(withIdentifier: "itemsTableToItemDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "itemsTableToItemDetails" {
            let controller: ItemDetailsViewController
            controller = segue.destination as! ItemDetailsViewController
            controller.name = selectedName
            controller.cost = selectedCost
            controller.image = selectedImage
            controller.imgurl = imglink
            controller.options = selectedOptionList
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
