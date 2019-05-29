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
    
    func callLogin(email: String, password: String, completions:@escaping(Data) -> Void) {
        
        let deviceid: String = ""
        let devicemac: String = ""
        
        csiWCF_loginbyEmail(email: email, password: password, deviceid: deviceid, devicemac: devicemac) { (returnCompletionData) in

            completions(returnCompletionData)
        }
    }
    
    func callSearch(inputData:String, client: String, uid: String, c: String, p: Int, psize:Int, apptp: Int, completion:@escaping(Data) -> Void) {
        
        // call the search function in the WCF
        csiWCF_GetSDSSearchResultsPage(inputData: inputData, client: client, uid: uid, c: c, p: p, psize: psize, apptp: apptp) {
            (completionReturnData) in
            
            completion(completionReturnData)
            
//            if completionReturnData.contains("false") {
//                completion("false")
//            } else if completionReturnData.contains("true") {
//
//                completion("true")
//            } else {
//                completion("Error")
//            }
        }
    }
    
    func callCriteriaList(completion:@escaping(String) -> Void) {
        
        //call the search criteria list function in the WCF
        csiWCF_GetSearchCriteriaList(clientid: localclientinfo.clientid, infosafeid: localclientinfo.infosafeid) { (returnCompletionData) in
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

        if rtype == "1" {
            csiWCF_getSDS(clientid: localclientinfo.clientid, uid: localclientinfo.infosafeid, sdsNoGet: localcurrentSDS.sdsNo, apptp: "1", rtype: rtype) { (output) in
                print(output.Base64String as Any)
                completion(output.Base64String)
            }
        }
        else if rtype == "2" {
            csiWCF_getSDS(clientid: localclientinfo.clientid, uid: localclientinfo.infosafeid, sdsNoGet: localcurrentSDS.sdsNo, apptp: "1", rtype: rtype) { (output) in
                
                let strForWeb = """
                    <html>
                    <head>
                    <meta name="viewport" content="width = device - width, initial-scale = 1">
                    <style>
                    body { font-size: 30%; }
                    </style>
                    </head>
                    <body>
                    \(output.html)
                    </body>
                    </html>
                    """
                    completion(strForWeb)
            }
        }
    }
    
}
