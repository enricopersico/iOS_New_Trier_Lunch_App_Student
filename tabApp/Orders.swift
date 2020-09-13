//
//  Orders.swift
//  tabApp
//
//  Created by Enrico Persico on 8/30/20.
//  Copyright © 2020 Enrico Persico. All rights reserved.
//

import UIKit

class Orders: UITableViewCell {

    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var orderTime: UILabel!
    @IBOutlet weak var status: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
