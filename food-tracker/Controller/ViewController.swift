//
//  ViewController.swift
//  firebase_auth_example
//
//  Created by khairussani on 26/02/2019.
//  Copyright © 2019 khairussani. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    var handle: AuthStateDidChangeListenerHandle?
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //hide nav
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // ...
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //show nav
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    
    @IBAction func loginBtn(_ sender: UIButton) {
        guard let username = username.text else {return}
        guard let password = password.text else {return}
        Auth.auth().signIn(withEmail: username, password: password) { [weak self] user, error in
            //guard let strongSelf = self else { return }
            //print("strongSelf \(strongSelf)")
            if error == nil && user != nil {
                print("User login!")
                self?.performSegue(withIdentifier: "login", sender: self)
            } else {
                let alertController = UIAlertController(title: "Error!", message: "Error \(error!.localizedDescription)", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                
                self?.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func registerBtn(_ sender: UIButton) {
        //self.performSegue(withIdentifier: "register", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //let receiverVC = segue.destination as! ViewControllerHome
    }
}

