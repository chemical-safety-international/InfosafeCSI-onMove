//
//  ViewController.swift
//  InfosafeCSI onMove
//
//  Created by Feng Liu on 7/5/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

class LoginPage_VC: UIViewController, UITextFieldDelegate {

    //IBOutlet
    @IBOutlet weak var userIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController!.navigationBar.isHidden = false;
        self.hideKeyboardWhenTappedAround()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField {
            textField.resignFirstResponder()
            
            //call the function with input from viewModule
            let email = userIDTextField.text!
            let password = passwordTextField.text!
            
            self.showSpinner(onView: self.view)
            csiWCF_VM().callLogin(email: email, password: password) { (completion) in
                
                DispatchQueue.main.async {
                    if completion.contains("true") {
                        self.removeSpinner()
                        let loginJump = self.storyboard?.instantiateViewController(withIdentifier: "SearchPage") as? SearchPage_VC
                        self.navigationController?.pushViewController(loginJump!, animated: true)
                    } else if completion.contains("false"){
                        self.removeSpinner()
                        self.showAlert(title: "Verify Failed", message: "Email or Password is invaild, please try again.")
                        //                        let ac = UIAlertController(title: "Verify Failed", message: "Email or Password is invaild, please try again.", preferredStyle: .alert)
                        //                        ac.addAction(UIAlertAction(title: "OK", style:  .default))
                        //                        self.present(ac, animated: true)
                    } else if completion.contains("Error") {
                        self.removeSpinner()
                        self.showAlert(title: "Failed", message: "Server is no response.")
                        //                        let ac = UIAlertController(title: "Failed", message: "Server is no response.", preferredStyle: .alert)
                        //                        ac.addAction(UIAlertAction(title: "OK", style:  .default))
                        //                        self.present(ac, animated: true)
                    }
                }
            }
            return false
        }

        return true
    }
}

//create a spinner for ViewController
var vSpinner : UIView?

extension UIViewController {
    //start spinner function
    func showSpinner(onView: UIView){
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        vSpinner = spinnerView
    }
    //stop spinner function
    func removeSpinner(){
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style:  .default))
        self.present(ac, animated: true)
    }
}

