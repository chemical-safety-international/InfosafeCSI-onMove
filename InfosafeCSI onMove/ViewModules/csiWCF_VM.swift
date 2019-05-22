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
    
    func callSearch(inputData:String, completion:@escaping(String) -> Void) {
        
        // call the search function in the WCF
        csiWCF_GetSDSSearchResultsPageEx(inputData: inputData) {
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
    
    func callSDS( completion:@escaping(String) -> Void ) {
        
        csiWCF_getHTML(clientid: csiclientinfo.clientid, uid: csiclientinfo.infosafeid, sdsNoGet: csicurrentSDS.sdsNo) { (output) in
            
            var temp = output
            temp = temp.replacingOccurrences(of: "\\\\", with: "\\")
            temp = temp.replacingOccurrences(of: "u000d", with: "")
            temp = temp.replacingOccurrences(of: "u000a", with: "")
            temp = temp.replacingOccurrences(of: "\\r", with: "\r")
            temp = temp.replacingOccurrences(of: "\\n", with: "\n")
            temp = temp.replacingOccurrences(of: "\\", with: "")
            
            
            //            let sc = Scanner(string: temp)
            //            var removedstr:NSString?
            //            var test:NSString?
            //            var wholeHtml:String = temp
            //
            //            while (!sc.isAtEnd) {
            //                sc.scanUpTo("\"html\": \"", into:&test)
            //                // sc.scanUpTo("\",  \"title\"", into: &removedstr)
            //                sc.scanUpTo("\",  \"title\"", into: &removedstr)
            //                let temp2 = String(describing: removedstr)
            //                let temp3 = String(describing: test)
            //
            //                wholeHtml = removedstr!.components(separatedBy: "\"html\": \"")[1]
            //                //                print("html is \r\r\r\r", temp2)
            //                //                print("title is :\r\r\r\r", temp3)
            //                //print("whole HTML is \r\r\r", wholeHtml)
            //            }
            
            let strForWeb = """
            <html>
            <head>
            <meta name="viewport" content="width = device - width, initial-scale = 1">
            <style>
            body { font-size: 30%; }
            </style>
            </head>
            <body>
            \(temp)
            </body>
            </html>
            """
            completion(strForWeb)
        }
    }
    
}
