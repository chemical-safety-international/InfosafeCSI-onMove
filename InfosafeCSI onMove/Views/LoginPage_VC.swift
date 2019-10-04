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
    @IBOutlet weak var loginBtn: UIButton!
    
    
    @IBOutlet weak var remember: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //button style
        loginBtn.layer.cornerRadius = 18

//        userIDTextField.layer.borderWidth = 1.0
//        userIDTextField.layer.cornerRadius = 18
//
//        passwordTextField.layer.borderWidth = 1.0
//        passwordTextField.layer.cornerRadius = 18
        
        
        // Do any additional setup after loading the view.
        self.navigationController!.navigationBar.isHidden = false;
        self.hideKeyboardWhenTappedAround()
        
        let defaults = UserDefaults.standard
        if (defaults.bool(forKey: "remeberstatus") == true) {
            userIDTextField.text = defaults.string(forKey: localclientcoreData.username)
            passwordTextField.text = defaults.string(forKey: localclientcoreData.password)
            let image = UIImage(named: "login-ticked-box")
            remember.setImage(image, for: .normal)
        } else if (defaults.bool(forKey: "remeberstatus") == false) {
            userIDTextField.text = ""
            passwordTextField.text = ""
            let image = UIImage(named: "login-unticked-box")
            remember.setImage(image, for: .normal)
        }
        
//        let deviceType = UIDevice.current.model
//        let deviceType1 = UIDevice.current
//        let deviceType2 = UIDevice.current.localizedModel
//        print(deviceType)
//        print(deviceType1)
//        print(deviceType2)
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(errorHandle), name: NSNotification.Name("errorLogin"), object: nil)

    }
    
    @objc private func errorHandle() {
        self.removeSpinner()
        self.showAlert(title: "Connection failure!", message: "Please check the connection and try again!")
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
            loginFunction()
            return false
        }
        return true
    }
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        loginFunction()
    }
    
    @IBAction func remeberBtnTapped(_ sender: Any) {
        if (userIDTextField.text! == "") {
            showAlert(title: "Notice", message: "Username is empty!")
        } else if (passwordTextField.text! == "") {
            showAlert(title: "Notice", message: "Password is empty!")
        } else {
            let defaults = UserDefaults.standard
            if (defaults.bool(forKey: "remeberstatus") == false) {
                let defaults = UserDefaults.standard
                defaults.set(userIDTextField.text!, forKey: localclientcoreData.username)
                defaults.set(passwordTextField.text!, forKey: localclientcoreData.password)
                let image = UIImage(named: "login-ticked-box")
                remember.setImage(image, for: .normal)
                defaults.set(true, forKey: "remeberstatus")

            } else if (defaults.bool(forKey: "remeberstatus") == true) {
                let defaults = UserDefaults.standard
                defaults.set("", forKey: localclientcoreData.username)
                defaults.set("", forKey: localclientcoreData.password)
                let image = UIImage(named: "login-unticked-box")
                remember.setImage(image, for: .normal)
                defaults.set(false, forKey: "remeberstatus")
            }
        }
    }
    
    func loginFunction() {
        //call the function with input from viewModule
        var email: String!
        var password: String!
        
        let defaults = UserDefaults.standard
        if (defaults.bool(forKey: "remeberstatus") == false) {
            email = userIDTextField.text!
            password = passwordTextField.text!
        } else if (defaults.bool(forKey: "remeberstatus") == true) {
            let defaults = UserDefaults.standard
            email = defaults.string(forKey: localclientcoreData.username)
            password = defaults.string(forKey: localclientcoreData.password)
        }

        
        self.showSpinner(onView: self.view)
        csiWCF_VM().callLogin(email: email, password: password) { (completion) in
            
            //here dataResponse received from a network request
            do {
                //here dataResponse received from a network request
                let decoder = JSONDecoder()
                let model = try decoder.decode(outLoginData.self, from:
                    completion) //Decode JSON Response Data

                localclientinfo.clientid = model.clientid
                localclientinfo.clientmemberid = model.clientmemberid
                localclientinfo.infosafeid = model.infosafeid
                localclientinfo.clientcode = model.clientcode
                localclientinfo.clientlogo = model.clientlogo
                localclientinfo.apptype = model.apptype
                localclientinfo.error = model.error

                
                DispatchQueue.main.async {
                    if model.passed == true {
                        self.removeSpinner()
                        let loginJump = self.storyboard?.instantiateViewController(withIdentifier: "SearchPage") as? SearchPage_VC
                        self.navigationController?.pushViewController(loginJump!, animated: true)
                    } else if model.passed == false {
                        self.removeSpinner()
                        self.showAlert(title: "Verify Failed", message: "Email or Password is invaild, please try again.")
                        self.passwordTextField.text = ""
                        
                        let defaults = UserDefaults.standard
                        defaults.set("", forKey: localclientcoreData.username)
                        defaults.set("", forKey: localclientcoreData.password)
                        let image = UIImage(named: "login-unticked-box")
                        self.remember.setImage(image, for: .normal)
                        defaults.set(false, forKey: "remeberstatus")
                        
                    } else {
                        self.removeSpinner()
                        self.showAlert(title: "Failed", message: "Server is no response.")
                        
                        let defaults = UserDefaults.standard
                        defaults.set("", forKey: localclientcoreData.username)
                        defaults.set("", forKey: localclientcoreData.password)
                        let image = UIImage(named: "login-unticked-box")
                        self.remember.setImage(image, for: .normal)
                        defaults.set(false, forKey: "remeberstatus")
                    }
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
    }
}

//create a spinner for ViewController
var vSpinner : UIView?

extension UIViewController {
    //start spinner function
    func showSpinner(onView: UIView) {
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
        self.view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

    func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style:  .default))
        self.present(ac, animated: true)
    }
}

extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) {
            return UIImage(data: data)
        }
        return nil
    }
}

