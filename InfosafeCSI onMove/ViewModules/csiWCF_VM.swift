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
    
    func callLogin(email: String, password: String, completions:@escaping(String) -> Void) {
        
        let deviceid: String = ""
        let devicemac: String = ""
        
        csiWCF_loginbyEmail(email: email, password: password, deviceid: deviceid, devicemac: devicemac) { (completion) in
            if completion.contains("true") {
                completions("true")
            } else if completion.contains("false"){
                completions("false")
            } else {
                completions("Error")
            }
        }

    }
    
    func callSearch(inputData:String, client: String, uid: String, c: String, p: Int, psize:Int, apptp: Int, completion:@escaping(String) -> Void) {
        
        // call the search function in the WCF
        csiWCF_GetSDSSearchResultsPage(inputData: inputData, client: client, uid: uid, c: c, p: p, psize: psize, apptp: apptp) {
            (completionReturnData) in
            
            if completionReturnData.contains("false") {
                completion("false")
            } else if completionReturnData.contains("true") {
                // get return value and put in every array
//                let returnArray = csiWCF_SearchReturnValueFix(inValue: completionReturnData)
//                
//                csiclientsearchinfo.arrName = returnArray.0 as? [String]
//                csiclientsearchinfo.arrDetail = returnArray.1 as? [String]
//                csiclientsearchinfo.arrNo = returnArray.2 as? [String]
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                completion("true")
            } else {
                completion("Error")
            }
        }
    }
    
    func callCriteriaList(completion:@escaping(String) -> Void) {
        
        //call the search criteria list function in the WCF
        csiWCF_GetSearchCriteriaList(clientid: csiclientinfo.clientid, infosafeid: csiclientinfo.infosafeid) { (returnCompletionData) in
            if returnCompletionData.contains("true") {
                completion("true")
            } else if returnCompletionData.contains("false") {
                completion("false")
            } else {
                completion("Error")
            }
            
        }
        
    }
    
    func callSDS(rtype : String, completion:@escaping(String) -> Void ) {

        
        csiWCF_getHTML(clientid: csiclientinfo.clientid, uid: csiclientinfo.infosafeid, sdsNoGet: csicurrentSDS.sdsNo, apptp: "1", rtype: rtype) { (output) in
            
            if rtype == "1" {
                completion(output)
            }
            else if rtype == "2" {
            let strForWeb = """
                <html>
                <head>
                <meta name="viewport" content="width = device - width, initial-scale = 1">
                <style>
                body { font-size: 30%; }
                </style>
                </head>
                <body>
                \(output)
                </body>
                </html>
                """
                completion(strForWeb)
            }
        }
    }
    
}
