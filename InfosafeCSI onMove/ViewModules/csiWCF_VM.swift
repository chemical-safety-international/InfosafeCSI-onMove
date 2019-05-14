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
        
//        print("email is: " + email)
//        print("password is:" + password)
        
        
        let deviceid: String = ""
        let devicemac: String = ""
        
        csiWCF_loginbyEmail(email: email, password: password, deviceid: deviceid, devicemac: devicemac) { (outdata) in
            if outdata.contains("true") {
                csiclientinfo.clientloginstatus = true
            } else {
                csiclientinfo.clientloginstatus = false
//                print("Login failed: email or password not correct.")
            }
        }

    }
    
    func callSearch(clientid: String, infosafeid: String, inputData:String) {
        //let input = inputData
        TablePage_VC().beginSearch(clientid: clientid, infosafeid: infosafeid, input: inputData)
    }
    
}
