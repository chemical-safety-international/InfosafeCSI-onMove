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
    var loginData: (String,String,String)!
    var client:String = ""
    var clientmember:String = ""
    var infosafe:String = ""
    
    
    func callLogin(email: String, password: String) ->(String, String, String, Bool) {
        
        print("email is: " + email)
        print("password is:" + password)
        
        var loginStatus: Bool = false
        let deviceid: String = ""
        let devicemac: String = ""
        csiWCF_loginbyEmail(email: email, password: password, deviceid: deviceid, devicemac: devicemac) { (clientid, clientmemberid, infosafeid) in
            
            if clientid == "" {
                print("Verify failed: \n \(loginVarStatus.statusBool)")
                
//                DispatchQueue.main.async {
                  //LoginViewController().showAlertWith(title: "Login Failed", message: "Your email address or password is invaild.")
                    loginStatus = false
//                }
                
                
            } else {
                print("Success login: \n \(loginVarStatus.statusBool)")
                //self.loginData = csiWCF_LoginReturnValueFix(inValue: returnData)
                
//                print(self.loginData as Any)
//                print(loginData)
//                self.loginData = returnData
//                DispatchQueue.main.async {
                    //LoginPage_VC().showAlertWith(title: "Login Success", message: "Welcome to CSI!")
//                    LoginPage_VC().pushPage()
                    loginStatus = true
//                }
                self.client = clientid
                self.clientmember = clientmemberid
                self.infosafe = infosafeid
                
            }
        }
        return (client, clientmember, infosafe, loginStatus)
    }
    
    func callSearch(loginData:(String,String,String), inputData:String) {
        let inputData = "acetone"
        csiWCF_GetSDSSearchResultsPageEx(clientid: loginData.0, clientmemberid: loginData.1, infosafeid: loginData.2, inputData: inputData) {
            (returnData) in

            if returnData.contains("false") {
                print("No data return from search")
            } else {
                print("Success called search: \n \(returnData)")
            }
        }
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
