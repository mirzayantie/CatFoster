//
//  ViewControllerRegister.swift
//  firebase_auth_example
//
//  Created by khairussani on 26/02/2019.
//  Copyright © 2019 khairussani. All rights reserved.
//

import UIKit
import Firebase

class ViewControllerRegister: UIViewController {
    var handle: AuthStateDidChangeListenerHandle?
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var regBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //regBtn.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // ...
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    
    @IBAction func registerBtn(_ sender: UIButton) {
        guard let username = userName.text else {return}
        guard let password = password.text else {return}
        //regBtn.isEnabled = true
        Auth.auth().createUser(withEmail: username, password: password) { authResult, error in
            if error == nil && authResult != nil {
                print("User created!")
                self.performSegue(withIdentifier: "login", sender: self)
            } else {
                
                let alertController = UIAlertController(title: "Error!", message: "Error \(error!.localizedDescription)", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    

}
