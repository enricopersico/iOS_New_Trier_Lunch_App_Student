//
//  CategoriesTableViewController.swift
//  tabApp
//
//  Created by Enrico Persico on 8/12/20.
//  Copyright © 2020 Enrico Persico. All rights reserved.
//

import UIKit
import FirebaseFirestore

class CategoriesTableViewController: UITableViewController {
    
    var categories = [Category]()
    var userSelection: String!
    
    struct Category {
        let name: String
        let url: String
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCategories()
    }
    
    @IBAction func handleRefresh(_ sender: Any) {
        getCategories()
    }
    
    func getCategories() {
        categories.removeAll()
        Firestore.firestore().collection("categories").getDocuments { (snapshot, error) in
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
                let newCategory = Category(name: name, url: url)
                self.categories.append(newCategory)
            }
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
        }
    }
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "category", for: indexPath) as! Categories
        
        cell.name.text = categories[indexPath.row].name
        
        let url = NSURL(string: categories[indexPath.row].url)
        guard let data = NSData(contentsOf: url! as URL) else {
            let networkError = self.storyboard?.instantiateViewController(withIdentifier: "networkError")
            networkError?.modalPresentationStyle = .fullScreen
            self.present(networkError!, animated: true, completion: nil)
            return cell
        }
        cell.img.image = UIImage(data: data as Data)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! Categories
        userSelection = cell.name.text
        performSegue(withIdentifier: "categoriesToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "categoriesToItems" {
            let controller = segue.destination as! ItemsTableViewController
            controller.category = self.userSelection
        }
    }
}
