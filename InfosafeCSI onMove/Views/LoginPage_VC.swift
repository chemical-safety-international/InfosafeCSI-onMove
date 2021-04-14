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
    
    @IBOutlet weak var loginLogo: UIImageView!
    
    @IBOutlet weak var remember: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        textTest()
        
        //button style
        loginBtn.layer.cornerRadius = 18
        
        
        // Do any additional setup after loading the view.
        self.navigationController!.navigationBar.isHidden = false;
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false;
        self.hideKeyboardWhenTappedAround()
        
        let defaults = UserDefaults.standard
        if (defaults.bool(forKey: "\(localclientinfo.appointedclient ?? "")remeberstatus") == true) {
//            userIDTextField.text = defaults.string(forKey: localclientcoreData.username)
            if defaults.string(forKey: localclientinfo.appointedclient) == localclientinfo.appointedclient {
            passwordTextField.text = defaults.string(forKey: "\(localclientinfo.appointedclient ?? "")\(localclientcoreData.password)")
            let image = UIImage(named: "login-ticked-box")
            remember.setImage(image, for: .normal)
            }
            //set image
//            let imageStr: String? = defaults.string(forKey: localclientcoreData.image)
//            if (imageStr != "" || imageStr?.isEmpty == false) {
//                let image = imageStr!.toImage()
//                loginLogo.image = image
//            }


        } else if (defaults.bool(forKey: "\(localclientinfo.appointedclient ?? "")remeberstatus") == false) {
//            userIDTextField.text = ""
            passwordTextField.text = ""
            
//            let logo = UIImage(named: "CSI-Logo1")
//            loginLogo.image = logo
//
//            let image = UIImage(named: "login-unticked-box")
//            remember.setImage(image, for: .normal)
        }
        
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
//        self.view.backgroundColor = UIColor(red:0.76, green:0.75, blue:0.75, alpha:1.0)
//        self.view.backgroundColor = UIColor.black
        
        NotificationCenter.default.addObserver(self, selector: #selector(errorHandle), name: NSNotification.Name("errorLogin"), object: nil)
        
        setNavigationbar()
        preloadEmail()
        loadLogo()
    }
    
    @objc private func errorHandle() {
        self.removeSpinner()
        self.showAlert(title: "Connection failure!", message: "Please check the connection and try again!")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.isHidden = false
        
//        let defaults = UserDefaults.standard
//        if (defaults.bool(forKey: "remeberstatus") == true) {
//            userIDTextField.text = defaults.string(forKey: localclientcoreData.username)
//            passwordTextField.text = defaults.string(forKey: localclientcoreData.password)
//            let image = UIImage(named: "login-ticked-box")
//            remember.setImage(image, for: .normal)
//
//            //set image
//            let imageStr: String? = defaults.string(forKey: localclientcoreData.image)
//            if (imageStr != "" || imageStr?.isEmpty == false) {
//                let image = imageStr!.toImage()
//                loginLogo.image = image
//            }
////            else {
////                let image = UIImage(named: "CSI-Logo1")
////                loginLogo.image = image
////            }
//
//        } else if (defaults.bool(forKey: "remeberstatus") == false) {
////            userIDTextField.text = ""
//            passwordTextField.text = ""
////            let logo = UIImage(named: "CSI-Logo1")
////            loginLogo.image = logo
//            //print(defaults.string(forKey: localclientcoreData.image) as Any)
//            let imageStr: String? = defaults.string(forKey: localclientcoreData.image)
//            if (imageStr != "" && imageStr != nil && imageStr?.isEmpty == false) {
//                let image = imageStr!.toImage()
//                loginLogo.image = image
//            }
//
//            let image = UIImage(named: "login-unticked-box")
//            remember.setImage(image, for: .normal)
//        }

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

//        self.navigationController?.navigationBar.isHidden = false
//
    }
    
    //load the company logo if it has
    func loadLogo() {

        if localclientinfo.clientlogo != nil && localclientinfo.clientlogo != "" {
                let image = localclientinfo.clientlogo!.toImage()
                loginLogo.image = image
        } else {

            loginLogo.image = UIImage(named: "CSI-Logo1")
        }
    }
    
    func preloadEmail() {
        if locallogininfo.email.isEmpty == false {
            userIDTextField.text = locallogininfo.email
            userIDTextField.isUserInteractionEnabled = false
        }
    }
    
    func setNavigationbar() {
        //change background color
        //change background color & back button color
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.25, green:0.26, blue:0.26, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white

        //change navigation bar text color and font
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 23), .foregroundColor: UIColor.white]
        self.navigationItem.title = "Login"
               
    }
    
//    override open var shouldAutorotate: Bool {
//        return false
//    }
    
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            return .portrait
//        } else {
//            return .all
//        }
//    }
    
    //detect user typing in the text field
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        let defaults = UserDefaults.standard
//        if (defaults.bool(forKey: "remeberstatus") == true) {
//            let defaults = UserDefaults.standard
//            defaults.set("", forKey: localclientcoreData.username)
//            defaults.set("", forKey: localclientcoreData.password)
//            defaults.set("", forKey: localclientcoreData.image)
//            let image = UIImage(named: "login-unticked-box")
//            self.remember.setImage(image, for: .normal)
//            defaults.set(false, forKey: "remeberstatus")
//        }
        
//        loginBtn.isHidden = true
        
//        userIDTextField.enablesReturnKeyAutomatically = true
//        passwordTextField.enablesReturnKeyAutomatically = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let defaults = UserDefaults.standard
        if (defaults.bool(forKey: "\(localclientinfo.appointedclient ?? "")remeberstatus") == true) {
            let defaults = UserDefaults.standard
//            defaults.set("", forKey: localclientcoreData.username)
            defaults.set("", forKey: localclientcoreData.password)
//            defaults.set("", forKey: localclientcoreData.image)
//            let image = UIImage(named: "login-unticked-box")
//            self.remember.setImage(image, for: .normal)
            defaults.set(false, forKey: "\(localclientinfo.appointedclient ?? "")remeberstatus")
        }
        loginBtn.isHidden = false
//        userIDTextField.enablesReturnKeyAutomatically = false
//        passwordTextField.enablesReturnKeyAutomatically = false
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
        if (passwordTextField.text! == "") {
            showAlert(title: "Notice", message: "Password is empty!")
        } else {

            let defaults = UserDefaults.standard
            if (defaults.bool(forKey: "\(localclientinfo.appointedclient ?? "")remeberstatus") == false) {
//                defaults.set(userIDTextField.text!, forKey: localclientcoreData.username)
                defaults.set(localclientinfo.appointedclient, forKey: localclientinfo.appointedclient)
                defaults.set(passwordTextField.text!, forKey: "\(localclientinfo.appointedclient ?? "")\(localclientcoreData.password)")
                let image = UIImage(named: "login-ticked-box")
                remember.setImage(image, for: .normal)
                defaults.set(true, forKey: "\(localclientinfo.appointedclient ?? "")remeberstatus")

            } else if (defaults.bool(forKey: "\(localclientinfo.appointedclient ?? "")remeberstatus") == true) {
                let defaults = UserDefaults.standard
//                defaults.set("", forKey: localclientcoreData.username)
                defaults.set("", forKey: localclientinfo.clientid)
                defaults.set("", forKey: localclientcoreData.password)
//                defaults.set("", forKey: localclientcoreData.image)
                let image = UIImage(named: "login-unticked-box")
                remember.setImage(image, for: .normal)
                defaults.set(false, forKey: "\(localclientinfo.appointedclient ?? "")remeberstatus")
            }
        }
    }
    
    func loginFunction() {
        //call the function with input from viewModule
        var email: String!
        var password: String!
        
        let defaults = UserDefaults.standard
        if (defaults.bool(forKey: "\(localclientinfo.appointedclient ?? "")remeberstatus") == false) {
            email = userIDTextField.text!
            password = passwordTextField.text!
        } else if (defaults.bool(forKey: "\(localclientinfo.appointedclient ?? "")remeberstatus") == true) {
            let defaults = UserDefaults.standard
//            email = defaults.string(forKey: localclientcoreData.username)
            email = userIDTextField.text!
            password = defaults.string(forKey: "\(localclientinfo.appointedclient ?? "")\(localclientcoreData.password)")
        }

        
        self.showSpinner(onView: self.view)
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        
        csiWCF_VM().callLogin(email: email, password: password, session: session) { (completion) in
            
            //here dataResponse received from a network request
            do {
                //here dataResponse received from a network request
                let decoder = JSONDecoder()
                print("Completion:")
                print(completion)
                let model = try decoder.decode(outLoginData.self, from:
                    completion) //Decode JSON Response Data
//                print(model)
                localclientinfo.clientid = model.clientid
                localclientinfo.clientmemberid = model.clientmemberid
                localclientinfo.infosafeid = model.infosafeid
                localclientinfo.clientcode = model.clientcode
                localclientinfo.clientlogo = model.clientlogo
                localclientinfo.apptype = model.apptype
//                localclientinfo.errorno = model.errorno
//                localclientinfo.error = model.error
                localclientinfo.retIndexNo = model.retIndexNo
                localclientinfo.retIndexText = model.retIndexText

                            
                DispatchQueue.main.async {
                    if model.passed == true {
                        self.removeSpinner()
//                        if (localclientinfo.clientlogo != "") {
//                            let defaults = UserDefaults.standard
//                            defaults.set(localclientinfo.clientlogo, forKey: localclientcoreData.image)
//                        }

                        let loginJump = self.storyboard?.instantiateViewController(withIdentifier: "SearchPage") as? SearchPage_VC
                        self.navigationController?.pushViewController(loginJump!, animated: true)
                    } else if model.passed == false {
                        
                        self.removeSpinner()
                        if model.isgeneric == false {
                            if localclientinfo.retIndexNo.contains("E") {
                                self.showAlert(title: "Verify Failed", message: localclientinfo.retIndexText)
                            }
                            
                        } else if (model.isgeneric == true) {
                            if localclientinfo.retIndexNo.contains("E") {
                                self.showAlert(title: "Verify Failed", message: localclientinfo.retIndexText)
                            }
                            
                            
                        } else {
                            self.showAlert(title: "Verify Failed", message: "Email or Password is invaild, please try again.")
                        }
                        
                        //reset status
                        self.passwordTextField.text = ""
                        
//                        let defaults = UserDefaults.standard
//                        defaults.set("", forKey: localclientcoreData.username)
                        defaults.set("", forKey: localclientcoreData.password)
                        
//                        defaults.set("", forKey: localclientcoreData.image)
                        let image = UIImage(named: "login-unticked-box")
                        self.remember.setImage(image, for: .normal)
                        defaults.set(false, forKey: "\(localclientinfo.appointedclient ?? "")remeberstatus")
                        
                    } else {
                        self.removeSpinner()
                        self.showAlert(title: "Failed", message: "Server is no response.")
                        
//                        let defaults = UserDefaults.standard
//                        defaults.set("", forKey: localclientcoreData.username)
                        defaults.set("", forKey: localclientcoreData.password)
//                        defaults.set("", forKey: localclientcoreData.image)
                        let image = UIImage(named: "login-unticked-box")
                        self.remember.setImage(image, for: .normal)
                        defaults.set(false, forKey: "\(localclientinfo.appointedclient ?? "")remeberstatus")
                    }
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
 
    }
    
    func checkNonGenericErrorType(errorno: Int) {
        
        switch errorno {
        case 10002:
            self.removeSpinner()
            self.showAlert(title: "Verify Failed", message: loginNonGenericErrorType.error2)
        case 10003:
            self.removeSpinner()
            self.showAlert(title: "Verify Failed", message: loginNonGenericErrorType.error3)
        case 10004:
            self.removeSpinner()
            self.showAlert(title: "Verify Failed", message: loginNonGenericErrorType.error4)
        case 10005:
            self.removeSpinner()
            self.showAlert(title: "Verify Failed", message: loginNonGenericErrorType.error5)
        case 10006:
            self.removeSpinner()
            self.showAlert(title: "Verify Failed", message: loginNonGenericErrorType.error6)
        case 10007:
            self.removeSpinner()
            self.showAlert(title: "Verify Failed", message: loginNonGenericErrorType.error7)
        case 10008:
            self.removeSpinner()
            self.showAlert(title: "Verify Failed", message: loginNonGenericErrorType.error8)
        default: break
            
        }
        
    }
    
    func checkGenericErrorType(errorno: Int) {
        
        switch errorno {
        case 10020:
            self.removeSpinner()
            self.showAlert(title: "Verify Failed", message: loginGenericErrorType.error61)
        case 10021:
            self.removeSpinner()
            self.showAlert(title: "Verify Failed", message: loginGenericErrorType.error62)
        case 10022:
            self.removeSpinner()
            self.showAlert(title: "Verify Failed", message: loginGenericErrorType.error63)
        case 10023:
            self.removeSpinner()
            self.showAlert(title: "Verify Failed", message: loginGenericErrorType.error66)
        default: break
            
        }
        
    }
    
}


extension LoginPage_VC : URLSessionDelegate {
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
       //Trust the certificate even if not valid
       let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)

       completionHandler(.useCredential, urlCredential)
    }
}

