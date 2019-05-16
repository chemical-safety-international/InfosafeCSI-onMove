//
//  ViewController.swift
//  InfosafeCSI onMove
//
//  Created by Feng Liu on 7/5/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

class LoginPage_VC: UIViewController {

    //IBOutlet
    @IBOutlet weak var userIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
//    func showAlertWith(title: String, message: String) {
//        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style:  .default))
//        self.present(ac, animated: true)
//    }


    //IBAction
    @IBAction func loginBtnTapped(_ sender: Any) {
        
        //call the function with input from viewModule
        let email = userIDTextField.text!
        let password = passwordTextField.text!
        
        self.showSpinner(onView: self.view)
        csiWCF_VM().callLogin(email: email, password: password) { (completion) in
            print(completion)
   
                
                
                //            let ac = UIAlertController(title: "Login success", message: "Welcome", preferredStyle: .alert)
                //            ac.addAction(UIAlertAction(title: "OK", style:  .default))
                //            self.present(ac, animated: true)
                DispatchQueue.main.async {
                             if csiclientinfo.clientloginstatus.contains("true") {
                                self.removeSpinner()
                                let loginJump = self.storyboard?.instantiateViewController(withIdentifier: "SearchPage") as? SearchPage_VC
                                self.navigationController?.pushViewController(loginJump!, animated: true)
                             } else if csiclientinfo.clientloginstatus.contains("false"){
                                self.removeSpinner()
                                let ac = UIAlertController(title: "Verify Failed", message: "Email or Password is invaild, please try again.", preferredStyle: .alert)
                                ac.addAction(UIAlertAction(title: "OK", style:  .default))
                                self.present(ac, animated: true)
                    }
                    self.removeSpinner()
                }
            
                

            //        showAlert()
        }
        
//        run(after:5)
//        {
//        if csiclientinfo.clientloginstatus != "" {
//
//
////            let ac = UIAlertController(title: "Login success", message: "Welcome", preferredStyle: .alert)
////            ac.addAction(UIAlertAction(title: "OK", style:  .default))
////            self.present(ac, animated: true)
//            self.removeSpinner()
//
//            let loginJump = self.storyboard?.instantiateViewController(withIdentifier: "SearchPage") as? SearchPage_VC
//            self.navigationController?.pushViewController(loginJump!, animated: true)
//        } else {
//            let ac = UIAlertController(title: "Verify Failed", message: "Email or Password is invaild, please try again.", preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "OK", style:  .default))
//            self.present(ac, animated: true)
//            }
////        showAlert()
//        }
    }
    
    
    func run(after seconds: Int, completion: @escaping () -> Void) {
        let deadline = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            completion()
        }
    }

}

var vSpinner : UIView?

extension UIViewController {
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
    
    func removeSpinner(){
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}
