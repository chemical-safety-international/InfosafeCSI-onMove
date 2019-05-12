//
//  LoginViewModules.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 8/5/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import Foundation
import UIKit


class csiWCF_VM: UIViewController {
    
    //create var
    var loginDataSet: (String, String, String) = ("","","")
    
    func callLogin(email: String, password: String) {
        
        print("email is: " + email)
        print("password is:" + password)
        
        
        let deviceid: String = ""
        let devicemac: String = ""
        
 //       let group = DispatchGroup()
//        group.enter()
//       csiWCF_loginbyEmail(email: email, password: password, deviceid: deviceid, devicemac: devicemac)
        csiWCF_loginbyEmail(email: email, password: password, deviceid: deviceid, devicemac: devicemac) { (outdata) in
            if outdata.contains("true") {
                self.loginDataSet = csiWCF_LoginReturnValueFix(inValue: outdata)
                
            let loginJump = self.storyboard?.instantiateViewController(withIdentifier: "SearchPage") as? SearchPage_VC
            self.navigationController?.pushViewController(loginJump!, animated: true)
            } else {
                print("Login failed: email or password not correct.")
            }
//            print("\(clientid), \(clientmemberid), \(infosafeid)")
//            if loginVarStatus.statusBool == false {
//                print("Verify failed: \n \(loginVarStatus.statusBool)")
        
//                DispatchQueue.main.async {
                  //LoginViewController().showAlertWith(title: "Login Failed", message: "Your email address or password is invaild.")
//                }
                
                
//            } else {
//                print("Success login: \n \(loginVarStatus.statusBool)")
                //self.loginData = csiWCF_LoginReturnValueFix(inValue: returnData)
                
//                print(self.loginData as Any)
//                print(loginData)
//                self.loginData = returnData
//                DispatchQueue.main.async {
                    //LoginPage_VC().showAlertWith(title: "Login Success", message: "Welcome to CSI!")
//                    LoginPage_VC().pushPage()

//                }
        
            }
//        }
//        group.leave()
    }
    
    func callSearch(loginData:(String,String,String), inputData:String) {
        let inputData = "acetone"
        TablePage_VC().beginSearch(loginData: loginData, input: inputData)
        }
    
//    func showAlert() {
//        if loginVarStatus.statusBool.contains("true") {
//            //            DispatchQueue.main.async {
//            // LoginPage_VC().showAlertWith(title: "Login Success", message: "Welcome to CSI!")
//            let ac = UIAlertController(title: "Login success", message: "Welcome", preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "OK", style:  .default))
//            LoginPage_VC().present(ac, animated: true)
//            //            }
//
//            let loginJump = storyboard?.instantiateViewController(withIdentifier: "SearchPage") as? SearchPage_VC
//            self.navigationController?.pushViewController(loginJump!, animated: true)
//
//        } else {
//            let ac = UIAlertController(title: "Verify Failed", message: "Email or Password is invaild, please try again.", preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "OK", style:  .default))
//            LoginPage_VC().present(ac, animated: true)
//        }
//    }
    
}
