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
    
    func showAlertWith(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style:  .default))
        self.present(ac, animated: true)
    }

    
    func showAlert() {
        if loginVarStatus.statusBool == true {
            //            DispatchQueue.main.async {
            // LoginPage_VC().showAlertWith(title: "Login Success", message: "Welcome to CSI!")
            let ac = UIAlertController(title: "Login success", message: "Welcome", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style:  .default))
            self.present(ac, animated: true)
            //            }

            let loginJump = storyboard?.instantiateViewController(withIdentifier: "SearchPage") as? SearchPage_VC
            self.navigationController?.pushViewController(loginJump!, animated: true)

        } else {
            let ac = UIAlertController(title: "Verify Failed", message: "Email or Password is invaild, please try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style:  .default))
            self.present(ac, animated: true)
        }
    }
    

    //IBAction
    @IBAction func loginBtnTapped(_ sender: Any) {
        print("Login Button Tapped!")
        
        //call the function with input from viewModule
        let email = userIDTextField.text!
        let password = passwordTextField.text!
        
        //let loginReturnData = csiWCF_VM().callLogin(email: email, password: password)
//        let group = DispatchGroup()
//        group.enter()
        //DispatchQueue.main.async {
        csiWCF_VM().callLogin(email: email, password: password)
 //       print("\(loginVarStatus.client) + \(loginVarStatus.clientmemberid) + \(loginVarStatus.infosafeid))")
        showAlert()
//        print("last data: \n \(loginReturnInfo.0) \n \(loginReturnInfo.1) \n \(loginReturnInfo.2)")
//        run(after: 10) {
//            if loginReturnInfo.3 == true {
//
//                let ac = UIAlertController(title: "Login success", message: "Welcome", preferredStyle: .alert)
//                ac.addAction(UIAlertAction(title: "OK", style:  .default))
//                self.present(ac, animated: true)
//
//
//
//                let loginJump = self.storyboard?.instantiateViewController(withIdentifier: "SearchPage") as? SearchPage_VC
//                self.navigationController?.pushViewController(loginJump!, animated: true)
//            } else {
//                let ac = UIAlertController(title: "Verify Failed", message: "Email or Password is invaild, please try again.", preferredStyle: .alert)
//                ac.addAction(UIAlertAction(title: "OK", style:  .default))
//                self.present(ac, animated: true)
//            }
//        }
        
//            group.leave()
//       //}
//        group.wait()
//
//        group.enter()
//        print("Login status is: \(loginVarStatus.statusBool)")
//
//        group.leave()
    }
    
    func pushPage()  {
        let loginJump = storyboard?.instantiateViewController(withIdentifier: "SearchPage") as? SearchPage_VC
        self.navigationController?.pushViewController(loginJump!, animated: true)
    }
    
    func run(after seconds: Int, completion: @escaping () -> Void) {
        let deadline = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            completion()
        }
    }

}

