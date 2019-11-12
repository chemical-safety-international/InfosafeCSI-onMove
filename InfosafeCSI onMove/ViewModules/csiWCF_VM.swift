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
    
    func callSearch(pnameInputData:String, supInputData: String, pcodeInputData: String, completion:@escaping(Bool) -> Void) {
//        CoreDataManager.cleanSearchCoreData()
//        print("callsearch called successfully")
        localsearchinfo.details = ""
        
        self.localresult.lcount = 0
        self.localresult.ocount = 0
        self.localresult.pcount = 0
        self.localresult.totalcount = 0
        
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
        csiWCF_GetSDSSearchResultsPage(pnameInputData: pnameInputData, supInputData: supInputData, pcodeInputData: pcodeInputData, client: client!, uid: uid!, c: c!, p: p!, psize:psize!, apptp:apptp!) { (completionReturnData) in

            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: completionReturnData, options: []) as? [String: AnyObject]
                print(jsonResponse as Any)
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

                            if ritem.prodtype == "P" {
                                self.localresult.pcount += 1
                            } else if ritem.prodtype == "L" {
                                self.localresult.lcount += 1
                            }else if ritem.prodtype == "O" {
                                self.localresult.ocount += 1
                            }
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
                        
                        ritem.Com_Country = info["scountry"] as? String
                        ritem.GHS_Pictogram = info["sdsghspic"] as? String
                        //hanlde user field
                        //ritem.ufs.append(ritemuf)
                        //localresult.results.append(ritem)
                        localsearchinfo.results.append(ritem)

// save search data to the core data
//                        DispatchQueue.main.async {
//                            CoreDataManager.storeObj(prodname: ritem.prodname ?? "", sdsno: ritem.sdsno ?? "", company: ritem.company ?? "", issueDate: ritem.issueDate ?? "", prodtype: ritem.prodtype ?? "", unno: ritem.unno ?? "", haz: ritem.haz ?? "", dgclass: ritem.dgclass ?? "", prodcode: ritem.prodcode ?? "", ps: ritem.ps ?? "", GHS_Pictogram: ritem.GHS_Pictogram ?? "", Com_Country: ritem.Com_Country ?? "")
//                        }

                    
                    }
                    let firstSDS = jsonArr1[0]["key"] as? [String: Any]
                    localDeafultData.sdsNo =  firstSDS!["value"] as? String
//                    print(localDeafultData.sdsNo)
            }
                self.localresult.result = jsonResponse!["result"] as? Bool
//                self.localresult.pcount = jsonResponse!["pcount"] as? Int
                self.localresult.pageno = jsonResponse!["no"] as? Int
//                self.localresult.lcount = jsonResponse!["lcount"] as? Int
//                self.localresult.ocount = jsonResponse!["ocount"] as? Int
                self.localresult.pagecount = jsonResponse!["pagecount"] as? Int
                
                

//                localsearchinfo.pamount = ("Primary: \(self.localresult.pcount ?? 0)")
//                localsearchinfo.lamount = ("Local: \(self.localresult.lcount ?? 0)")
//                localsearchinfo.oamount = ("Other: \(self.localresult.ocount ?? 0)")
                localsearchinfo.pamount = ("Primary: \(self.localresult.pcount ?? 0)")
                localsearchinfo.lamount = ("Local: \(self.localresult.lcount ?? 0)")
                localsearchinfo.oamount = ("Other: \(self.localresult.ocount ?? 0)")
                localsearchinfo.pagenoamount = ("\(self.localresult.pageno ?? 0) / \(self.localresult.pagecount ?? 0)")
                localsearchinfo.totalPage = self.localresult.pagecount
                


                
                
            } catch let parsingError {
                print("Error", parsingError)
            }
//            print(self.localresult)
            if  self.localresult.pagecount != 0 {
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

        if (localcurrentSDS.sdsNo == "" || localcurrentSDS.sdsNo == nil) {
            localcurrentSDS.sdsNo = localDeafultData.sdsNo
        }

        if rtype == "1" {
            csiWCF_getSDS(clientid: localclientinfo.clientid, uid: localclientinfo.infosafeid, sdsNoGet: localcurrentSDS.sdsNo, apptp: "1", rtype: rtype) { (output) in
                if output.pdfString != nil {
                    completion(output.pdfString)
                }
                else if output.pdfString == nil
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
    
    func callSDS_Core(completion:@escaping(String) -> Void) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startSpin"), object: nil)
        csiWCF_getCoreInfo(clientid: localclientinfo.clientid, uid: localclientinfo.infosafeid, sdsNoGet: localcurrentSDS.sdsNo, apptp: "1", rtype: "1") { (output) in
            if output.sds != nil {
                
                // change string to date format
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"

                let issueD = dateFormatter.date(from: output.issuedate)
                let expirD = dateFormatter.date(from: output.expirydate)
                
                //convert date to string with current local timezone
                let issueDat = DateFormatter.localizedString(from: issueD!, dateStyle: .medium, timeStyle: .none)
                let expirDat = DateFormatter.localizedString(from: expirD!, dateStyle: .medium, timeStyle: .none)
                
                //store data to local
                localViewSDSCore.prodname = output.prodname
                localViewSDSCore.company = output.company
                localViewSDSCore.dg = output.dg
                localViewSDSCore.emcont = output.emcont
                localViewSDSCore.expirydate = expirDat
                localViewSDSCore.hs = output.hs
                localViewSDSCore.issuedate = issueDat
                localViewSDSCore.ps = output.ps
                localViewSDSCore.prodcode = output.prodcode
                localViewSDSCore.recomuse = output.recomuse
                localViewSDSCore.sds = output.sds
                localViewSDSCore.unno = output.unno
                    
                completion("true")

            } else {
                completion("false")
            }
        }
    }
    
    func callSDS_GHS(completion:@escaping(String) -> Void) {

        if (localcurrentSDS.sdsNo == "" || localcurrentSDS.sdsNo == nil) {
            localcurrentSDS.sdsNo = localDeafultData.sdsNo
        }
        
        csiWCF_getClassification(clientid: localclientinfo.clientid, uid: localclientinfo.infosafeid, sdsNoGet: localcurrentSDS.sdsNo, apptp: "1", rtype: "1") { (output) in
            if output.sds != nil {
                localViewSDSGHS.formatcode = output.formatcode
                localViewSDSGHS.picArray = []
//                print(localViewSDSGHS.picArray.count)
                if (localViewSDSGHS.formatcode == "0F" || localViewSDSGHS.formatcode == "0A") {
                    
                    localViewSDSGHS.classification = output.classification
                    localViewSDSGHS.dg = output.dg
                    localViewSDSGHS.hstate = output.hstate
                    localViewSDSGHS.ps = output.ps
                    localViewSDSGHS.pstate = output.pstate
//                    print(output.pstate)
                    localViewSDSGHS.pic = output.pic
                    localViewSDSGHS.rphrase = output.rphrase
                    localViewSDSGHS.sds = output.sds
                    localViewSDSGHS.sphrase = output.sphrase
                    localViewSDSGHS.ps_general = output.ps_general
                    localViewSDSGHS.ps_storage = output.ps_storage
                    localViewSDSGHS.ps_disposal = output.ps_disposal
                    localViewSDSGHS.ps_response = output.ps_response
                    localViewSDSGHS.ps_prevention = output.ps_prevention
                    
                    if (localViewSDSGHS.pic.isEmpty == false) {
                        localViewSDSGHS.picArray = localViewSDSGHS.pic.components(separatedBy: ",")

                    }
                } else {
                    localViewSDSCF.classification = output.classification
                    localViewSDSCF.dg = output.dg
                    localViewSDSCF.hstate = output.hstate
                    localViewSDSCF.pic = output.pic
                    localViewSDSCF.ps = output.ps
                    localViewSDSCF.sds = output.sds
                    localViewSDSCF.sphrase = output.sphrase
                    localViewSDSCF.rphrase = output.rphrase

                }
                
                completion("true")
            } else {
                
                
                completion("false")
            }
        }
    }
    
    
    func callSDS_FA(completion:@escaping(String) -> Void) {
        
        if (localcurrentSDS.sdsNo == "" || localcurrentSDS.sdsNo == nil) {
            localcurrentSDS.sdsNo = localDeafultData.sdsNo
        }
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startSpin"), object: nil)
        csiWCF_getFirstAid(clientid: localclientinfo.clientid, uid: localclientinfo.infosafeid, sdsNoGet: localcurrentSDS.sdsNo, apptp: "1", rtype: "1") { (output) in
            if output.sds != nil {
                
                
                //store data to local
                localViewSDSFA.sds = output.sds
                localViewSDSFA.inhalation = output.inhalation
                localViewSDSFA.ingestion = output.ingestion
                localViewSDSFA.skin = output.skin
                localViewSDSFA.eye = output.eye
                localViewSDSFA.fafacilities = output.fafacilities
                localViewSDSFA.advdoctor = output.advdoctor
                    
                completion("true")

            } else {
                completion("false")
            }
        }
    }
    
    func callSDS_Trans(completion:@escaping(String) -> Void) {
        
        if (localcurrentSDS.sdsNo == "" || localcurrentSDS.sdsNo == nil) {
            localcurrentSDS.sdsNo = localDeafultData.sdsNo
        }
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startSpin"), object: nil)

        csiWCF_getTransport(clientid: localclientinfo.clientid, uid: localclientinfo.infosafeid, sdsNoGet: localcurrentSDS.sdsNo, apptp: "1", rtype: "1") { (output) in
            if output.sds != nil {
                
//                print(output)
                //store data to local
                //ADG
                localViewSDSTIADG.road_unno = output.road_unno
                localViewSDSTIADG.road_dgclass = output.road_dgclass
                localViewSDSTIADG.road_subrisks = output.road_subrisks
                localViewSDSTIADG.road_packgrp = output.road_packgrp
                localViewSDSTIADG.road_psn = output.road_psn
                localViewSDSTIADG.road_hazchem = output.road_hazchem
                localViewSDSTIADG.road_epg = output.road_epg
                localViewSDSTIADG.road_ierg = output.road_ierg
                localViewSDSTIADG.road_packmethod = output.road_packmethod
                //IMDG
                localViewSDSTIIMDG.imdg_unno = output.imdg_unno
                localViewSDSTIIMDG.imdg_dgclass = output.imdg_dgclass
                localViewSDSTIIMDG.imdg_subrisks = output.imdg_subrisks
                localViewSDSTIIMDG.imdg_packgrp = output.imdg_packgrp
                localViewSDSTIIMDG.imdg_psn = output.imdg_psn
                localViewSDSTIIMDG.imdg_ems = output.imdg_ems
                localViewSDSTIIMDG.imdg_mp = output.imdg_mp
                //IATA
                localViewSDSTIIATA.iata_unno = output.iata_unno
                localViewSDSTIIATA.iata_dgclass = output.iata_dgclass
                localViewSDSTIIATA.iata_subrisks = output.iata_subrisks
                localViewSDSTIIATA.iata_packgrp = output.iata_packgrp
                localViewSDSTIIATA.iata_psn = output.iata_psn
                localViewSDSTIIATA.iata_symbol = output.iata_symbol
                

                    
                completion("true")

            } else {
                completion("false")
            }
        }
    }
    
}
