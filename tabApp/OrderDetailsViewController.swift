//
//  OrderDetailsViewController.swift
//  tabApp
//
//  Created by Enrico Persico on 8/30/20.
//  Copyright © 2020 Enrico Persico. All rights reserved.
//

import UIKit

class OrderDetailsViewController: UIViewController {

    var id: String!
    var status: String!
    var orderTime: String!
    
    @IBOutlet weak var QRCodeImage: UIImageView!
    @IBOutlet weak var orderTimeLbl: UILabel!
    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let data = id.data(using: String.Encoding.ascii)
        if let qrFilter = CIFilter(name: "CIQRCodeGenerator") {
            qrFilter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            if let scaledQRImage = qrFilter.outputImage?.transformed(by: transform) {
                QRCodeImage.image = UIImage(ciImage: scaledQRImage)
            }
        }
        orderTimeLbl.text = orderTime
        idLbl.text = "ID: " + id
        statusLbl.text = "Status: " + status
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
