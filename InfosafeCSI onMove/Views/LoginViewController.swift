//
//  ViewController.swift
//  InfosafeCSI onMove
//
//  Created by Feng Liu on 7/5/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    //IBOutlet
    @IBOutlet weak var userIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func showAlertWith(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style:  .default))
        present(ac, animated: true)
    }
    

    //IBAction
    @IBAction func loginBtnTapped(_ sender: Any) {
        print("Login Button Tapped!")
        
        //call the function with input from viewModule
        let email = userIDTextField.text!
        let password = passwordTextField.text!
        
        logincorresponding().callLogin(email: email, password: password)
        
    }
    
}

