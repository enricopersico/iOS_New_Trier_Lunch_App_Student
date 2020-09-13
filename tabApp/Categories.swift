//
//  Categories.swift
//  tabApp
//
//  Created by Enrico Persico on 8/13/20.
//  Copyright © 2020 Enrico Persico. All rights reserved.
//

import UIKit

class Categories: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
