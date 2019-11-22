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
        self.hideKeyboardWhenTappedAround()
        
        let defaults = UserDefaults.standard
        if (defaults.bool(forKey: "remeberstatus") == true) {
            userIDTextField.text = defaults.string(forKey: localclientcoreData.username)
            passwordTextField.text = defaults.string(forKey: localclientcoreData.password)
            let image = UIImage(named: "login-ticked-box")
            remember.setImage(image, for: .normal)

            let imageStr = defaults.string(forKey: localclientcoreData.image)
            if (imageStr != "") {
                let image = imageStr!.toImage()
                loginLogo.image = image
            } else {
                let image = UIImage(named: "CSI-Logo1")
                loginLogo.image = image
            }

        } else if (defaults.bool(forKey: "remeberstatus") == false) {
            userIDTextField.text = ""
            passwordTextField.text = ""
            let logo = UIImage(named: "CSI-Logo1")
            loginLogo.image = logo
            let image = UIImage(named: "login-unticked-box")
            remember.setImage(image, for: .normal)
        }
        
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
//        self.view.backgroundColor = UIColor(red:0.76, green:0.75, blue:0.75, alpha:1.0)
//        self.view.backgroundColor = UIColor.black
        
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
//

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
//    func textFieldDidBeginEditing(_ textField: UITextField) {
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
//    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let defaults = UserDefaults.standard
        if (defaults.bool(forKey: "remeberstatus") == true) {
            let defaults = UserDefaults.standard
            defaults.set("", forKey: localclientcoreData.username)
            defaults.set("", forKey: localclientcoreData.password)
            defaults.set("", forKey: localclientcoreData.image)
            let image = UIImage(named: "login-unticked-box")
            self.remember.setImage(image, for: .normal)
            defaults.set(false, forKey: "remeberstatus")
        }
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
                defaults.set("", forKey: localclientcoreData.image)
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
                        if (localclientinfo.clientlogo != "") {
                            let defaults = UserDefaults.standard
                            defaults.set(localclientinfo.clientlogo, forKey: localclientcoreData.image)
                        }

                        let loginJump = self.storyboard?.instantiateViewController(withIdentifier: "SearchPage") as? SearchPage_VC
                        self.navigationController?.pushViewController(loginJump!, animated: true)
                    } else if model.passed == false {
                        self.removeSpinner()
                        self.showAlert(title: "Verify Failed", message: "Email or Password is invaild, please try again.")
                        self.passwordTextField.text = ""
                        
                        let defaults = UserDefaults.standard
                        defaults.set("", forKey: localclientcoreData.username)
                        defaults.set("", forKey: localclientcoreData.password)
                        defaults.set("", forKey: localclientcoreData.image)
                        let image = UIImage(named: "login-unticked-box")
                        self.remember.setImage(image, for: .normal)
                        defaults.set(false, forKey: "remeberstatus")
                        
                    } else {
                        self.removeSpinner()
                        self.showAlert(title: "Failed", message: "Server is no response.")
                        
                        let defaults = UserDefaults.standard
                        defaults.set("", forKey: localclientcoreData.username)
                        defaults.set("", forKey: localclientcoreData.password)
                        defaults.set("", forKey: localclientcoreData.image)
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
    
//    func textTest() {
////        let path = NSString(string: "~/Pictograms.txt").expandingTildeInPath
////        let fileContent = try?NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)
////        print(fileContent)
//        
//        var items = localpictograms()
//        let bundle = Bundle(for: type(of: self))
//        if let path = bundle.path(forResource: "Pictograms", ofType: "txt") {
//            let contentStr = try? NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)
//            let contentDat = contentStr?.data(using: String.Encoding.utf8.rawValue)
//            let contentDic = try? JSONSerialization.jsonObject(with: contentDat!, options: [])
//            print(contentDic!)
//            
//            let jsonArr = contentDic as? [String: Any]
//            jsonArr!.forEach { info in
//                
//            }
////            contentData.forEach
//        } else {
//            print("failed")
//        }
//    }
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

extension CALayer {
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let border = CALayer()
 
        switch edge {
        case UIRectEdge.top:
//            border.frame = CGRect(x: 0, y: 0, width: self.frame.height, height: thickness)
            border.frame = CGRect(x: 0, y: -2, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
//            border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
            border.frame = CGRect(x: 0, y: self.bounds.height + 2 , width: self.bounds.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor
        
        self.addSublayer(border)
    }
    
}

