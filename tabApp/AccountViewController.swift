//
//  AccountViewController.swift
//  tabApp
//
//  Created by Enrico Persico on 8/28/20.
//  Copyright © 2020 Enrico Persico. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var userId: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userId.text = UserDefaults.standard.string(forKey: "user")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signOutClicked(_ sender: Any) {
        func backToLogin(alertAction: UIAlertAction) {
            UserDefaults.standard.set(false, forKey: "signedIn")
            let signOut = self.storyboard?.instantiateViewController(withIdentifier: "notSignedIn")
            signOut!.modalPresentationStyle = .fullScreen
            self.present(signOut!, animated: false, completion: nil)
        }
        
        let signOutAlert = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: UIAlertController.Style.alert)
        var defaultAction = UIAlertAction(title: "Sign Out", style: .default, handler: backToLogin)
        signOutAlert.addAction(defaultAction)
        defaultAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        signOutAlert.addAction(defaultAction)
        self.present(signOutAlert, animated: true, completion: nil)
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
