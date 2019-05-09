//
//  LoginViewModules.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 8/5/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import Foundation


class logincorresponding {
    
    func callLogin(email: String, password: String) {
        
        print("email is: " + email)
        print("password is:" + password)
        
        
        let deviceid: String = ""
        let devicemac: String = ""
        csiWCF_loginbyEmail(email: email, password: password, deviceid: deviceid, devicemac: devicemac) { (returnData) in
            
            
            if returnData.contains("false") {
                print("Verify failed: \(returnData)")
                
//                DispatchQueue.main.async {
//                  LoginViewController().showAlertWith(title: "Login Failed", message: "Your email address or password is invaild.")
//                }
                
                
            } else {
                print("Success: \n \(returnData) ")
                
//                DispatchQueue.main.async {
//                    LoginViewController().showAlertWith(title: "Login Success", message: "Welcome to CSI!")
//                }
    
            }
        }
    }
    
}
