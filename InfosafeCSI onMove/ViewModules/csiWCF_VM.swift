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
    
    func callSearch(inputData:String, completion:@escaping(Bool) -> Void) {
        
        localsearchinfo.details = ""
        
        //give values
        
        let client = localclientinfo.clientid
        let uid = localclientinfo.infosafeid
        let c = localcriteriainfo.code
        let p = 1
        let psize = 50
        let apptp = localclientinfo.apptype
        
        
        //call search function
        
        csiWCF_GetSDSSearchResultsPage(inputData: inputData, client: client!, uid: uid!, c: c!, p: p, psize:psize, apptp:apptp!) { (completionReturnData) in
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: completionReturnData, options: []) as? [String: AnyObject]
                
                //print(jsonResponse!)
                
                //var localresult = localsearchinfo()
                localsearchinfo.results = []
                
                
                if let jsonArr1 = jsonResponse!["data"] as? [[String: Any]] {
                    
                    jsonArr1.forEach { info in
                        
                        var ritem = localsearchinfo.item()
                        //var ritemuf = localsearchinfo.uf()
                        
                        
                        
                        if let prodname = info["name"] as? [String: Any] {
                            ritem.prodname = prodname["value"] as? String
                        }
                        if let comname = info["com"] as? [String: Any] {
                            ritem.company = comname["value"] as? String
                        }
                        
                        if let no = info["no"] as? [String: Any] {
                            ritem.sdsno = no["value"] as? String
                        }
                        if let issueData = info["issue"] as? [String: Any] {
                            ritem.issueDate = issueData["value"] as? String
                        }
                        //hanlde user field
                        //ritem.ufs.append(ritemuf)
                        //localresult.results.append(ritem)
                        localsearchinfo.results.append(ritem)
                    }
                }
                
            } catch let parsingError {
                print("Error", parsingError)
            }
            
            if localsearchinfo.results != nil {
                completion(true)
            } else if localsearchinfo.results == nil {

                completion(false)
            }  else {
                completion(false)
            }
//            //handle true or false for search function
//            DispatchQueue.main.async {
//                if localsearchinfo.results != nil {
//
//                    self.removeSpinner()
//                    //                    self.tableDisplay.reloadData()
//                    completion(true)
//
//                } else if localsearchinfo.results == nil {
//                    self.removeSpinner()
//                    let ac = UIAlertController(title: "Search Failed", message: "Please check the network and type the correct infomation search again.", preferredStyle: .alert)
//                    ac.addAction(UIAlertAction(title: "OK", style:  .default))
//                    self.present(ac, animated: true)
//                    completion(false)
//                }  else {
//                    self.removeSpinner()
//                    let ac = UIAlertController(title: "Failed", message: "Server is no response.", preferredStyle: .alert)
//                    ac.addAction(UIAlertAction(title: "OK", style:  .default))
//                    self.present(ac, animated: true)
//                    completion(false)
//                }
//            }
        }
        
//        // call the search function in the WCF
//        csiWCF_GetSDSSearchResultsPage(inputData: inputData, client: client, uid: uid, c: c, p: p, psize: psize, apptp: apptp) {
//            (completionReturnData) in
//
//            completion(completionReturnData)
//
//        }
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
                completion(output.html)
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
                    \(output.html ?? "")
                    </body>
                    </html>
                    """
                    completion(strForWeb)
            }
        }
    }
    
}
