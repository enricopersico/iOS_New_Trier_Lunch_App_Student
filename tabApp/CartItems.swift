//
//  CartItems.swift
//  tabApp
//
//  Created by Enrico Persico on 8/19/20.
//  Copyright © 2020 Enrico Persico. All rights reserved.
//

import UIKit
import FirebaseFirestore

class CartItems: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var itemTag: Int!
    var imgurl: String!
    var itemName: String!
    var options = [[String : Any]]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
}
