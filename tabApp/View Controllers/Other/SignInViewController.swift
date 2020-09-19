//
//  SignInViewController.swift
//  tabApp
//
//  Created by Enrico Persico on 8/17/20.
//  Copyright © 2020 Enrico Persico. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    /*
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        view.frame.origin.y -= 85
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    */
    @IBAction func signInBtnClicked(_ sender: Any) {
        let _: Void = Firestore.firestore().collection("users").whereField("type", isEqualTo: "student").whereField("username", isEqualTo: username.text!).whereField("password", isEqualTo: password.text!).getDocuments { (snapshot, error) in
        if let err = error {
            print(err)
        } else {
            if (snapshot?.documents)!.count == 1 {
                Auth.auth().signInAnonymously() { (authResult, error) in
                    guard let uid = authResult?.user else {return}
                    UserDefaults.standard.set(true, forKey: "signedIn")
                    UserDefaults.standard.set(self.username.text!, forKey: "user")
                    self.performSegue(withIdentifier: "signIn", sender: self)
                }
            }
            else {
                let signInAlert = UIAlertController(title: "Wrong Username/Password", message: "Please reenter your username and password.", preferredStyle: UIAlertController.Style.alert)
                let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                signInAlert.addAction(defaultAction)
                self.present(signInAlert, animated: true, completion: nil)
            }
        }
        }
    }
}
