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
    
    var localresult = localsearchinfo()
    
    func callLogin(email: String, password: String, completions:@escaping(Data) -> Void) {
        
        let deviceid: String = ""
        let devicemac: String = ""
        
        csiWCF_loginbyEmail(email: email, password: password, deviceid: deviceid, devicemac: devicemac) { (returnCompletionData) in

            completions(returnCompletionData)
        }
    }
    
    func callSearch(inputData:String, completion:@escaping(Bool) -> Void) {
        
        localsearchinfo.details = ""
        
//        var localresult = localsearchinfo()
//        localsearchinfo.results = []
        
        
        //give values
        let client = localclientinfo.clientid
        let uid = localclientinfo.infosafeid
        let c = localcriteriainfo.code
        let apptp = localclientinfo.apptype
        
        let p = localsearchinfo.cpage
        let psize = localsearchinfo.psize
        
        //call search function
        csiWCF_GetSDSSearchResultsPage(inputData: inputData, client: client!, uid: uid!, c: c!, p: p!, psize:psize!, apptp:apptp!) { (completionReturnData) in
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: completionReturnData, options: []) as? [String: AnyObject]
                
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
                        
//                        if let no = info["no"] as? [String: Any] {
//                            ritem.sdsno = no["value"] as? String
//                        }
                        if let issueData = info["issue"] as? [String: Any] {
                            ritem.issueDate = issueData["value"] as? String
                        }
                        if let key = info["key"] as? [String: Any] {
                            ritem.synno = key["value"] as? String
                        }
                        if let unno = info["unno"] as? [String: Any] {
                            ritem.unno = unno["value"] as? String
                        }
                        if let prodtype = info["nametype"] as? [String: Any] {
                            ritem.prodtype = prodtype["value"] as? String
                        }
                        if let pcode = info["code"] as? [String: Any] {
                            ritem.prodcode = pcode["value"] as? String
                        }
                        if let dgclas = info["dgclass"] as? [String: Any] {
                            ritem.dgclass = dgclas["value"] as? String
                        }
                        if let pscode = info["ps"] as? [String: Any] {
                            ritem.ps = pscode["value"] as? String
                        }
                        if let hazCode = info["haz"] as? [String: Any] {
                            ritem.haz = hazCode["value"] as? String
                        }
                        //hanlde user field
                        //ritem.ufs.append(ritemuf)
                        //localresult.results.append(ritem)
                        localsearchinfo.results.append(ritem)
                        print("\(String(describing: ritem.prodname))")
                        CoreDataManager.storeObj(prodname: ritem.prodname ?? "", sdsno: ritem.sdsno ?? "", company: ritem.company ?? "", issueDate: ritem.issueDate ?? "", prodtype: ritem.prodtype ?? "", unno: ritem.unno ?? "", haz: ritem.haz ?? "", dgclass: ritem.dgclass ?? "", prodcode: ritem.prodcode ?? "", ps: ritem.ps ?? "")
                        
//                        CoreDataManager.storeObj(prodname: String(describing:ritem.prodname), sdsno: String(describing:ritem.sdsno), company: String(describing:ritem.company), issueDate: String(describing:ritem.issueDate), prodtype: String(describing:ritem.prodtype), unno: String(describing:ritem.unno), haz: String(describing:ritem.haz), dgclass: String(describing:ritem.dgclass), prodcode: String(describing:ritem.prodcode), ps: String(describing:ritem.ps))
                    }
            }
                self.localresult.result = jsonResponse!["result"] as? Bool
                self.localresult.pcount = jsonResponse!["pcount"] as? Int
                self.localresult.pageno = jsonResponse!["no"] as? Int
                self.localresult.lcount = jsonResponse!["lcount"] as? Int
                self.localresult.ocount = jsonResponse!["ocount"] as? Int
                self.localresult.pagecount = jsonResponse!["pagecount"] as? Int
//                localsearchinfo.pdetails = ("Pcount: \(localresult.pcount ?? 0), Page No.: \(localresult.pageno ?? 0), Lcount: \(localresult.lcount ?? 0), Ocount: \(localresult.ocount ?? 0)")
                localsearchinfo.pamount = ("Primary: \(self.localresult.pcount ?? 0)")
                localsearchinfo.lamount = ("Local: \(self.localresult.lcount ?? 0)")
                localsearchinfo.oamount = ("Other: \(self.localresult.ocount ?? 0)")
                localsearchinfo.pagenoamount = ("\(self.localresult.pageno ?? 0) / \(self.localresult.pagecount ?? 0)")
                localsearchinfo.totalPage = self.localresult.pagecount
                
            } catch let parsingError {
                print("Error", parsingError)
            }
            
            if  self.localresult.pcount != 0 {
                completion(true)
            } else if self.localresult.result == false || self.localresult.pcount == 0 {

                completion(false)
            }  else {
                completion(false)
            }
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
                if output.pdfString != nil {
                    completion(output.pdfString)
                }
                else
                {
                    completion(output.html)
                }
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
