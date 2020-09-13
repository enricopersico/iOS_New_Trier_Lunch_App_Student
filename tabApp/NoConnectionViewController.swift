//
//  NoConnectionViewController.swift
//  tabApp
//
//  Created by Enrico Persico on 8/18/20.
//  Copyright © 2020 Enrico Persico. All rights reserved.
//

import UIKit

class NoConnectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func retryPressed(_ sender: Any) {
        var vc: UIViewController
        if UserDefaults.standard.bool(forKey: "signedIn") {
            vc = storyboard!.instantiateViewController(withIdentifier: "signedIn")
        }
        else {
            vc = storyboard!.instantiateViewController(withIdentifier: "notSignedIn")
        }
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
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
