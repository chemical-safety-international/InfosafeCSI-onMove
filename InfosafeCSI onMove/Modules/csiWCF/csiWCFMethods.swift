//
//  WCFMethods.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 7/5/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import Foundation

// Call the WCF function: 'loginbyEami' with email, password, deviceid, devicemac and return the data from WCF
func csiWCF_loginbyEmail(email:String, password:String, deviceid:String, devicemac:String, completion:@escaping(String, String, String) -> Void) -> (Void)
{
    //WCF for LoginByEamil
    
//    var statusCheck:String = ""
    //create a json type string
    let json: [String: Any] = ["email":email, "password":password, "deviceid":deviceid, "devicemac":devicemac]
    
    //serialiazation of json string
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    
    //*create URL string point to wcf method* should be changed after setting up core data
    let url = URL(string: "http://gold/CSIMD_WCF/CSI_MD_Service.svc/loginbyEmail")!
    
    //create request
    var request = URLRequest(url: url)
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    
    //insert json string to the request
    request.httpBody = jsonData
    
    print(request)
    //create a session to call wcf method
    let task = URLSession.shared.dataTask(with: request) { data, response, error in if let error = error {
        // print out error
        print("Error:", error)
        return
        }
        
        print("json:", json)
        
        //get the return data
        guard let data = data else {return}
        let responseString = String(data: data, encoding: .utf8)
        
        if responseString!.contains("true") {
            let loginInfo = csiWCF_LoginReturnValueFix(inValue: responseString!)
            let clientid = loginInfo.0
            let clientmemberid = loginInfo.1
            let infosafeid = loginInfo.2
           // statusCheck = "true"
            loginVarStatus.statusBool = "true"
            
            completion(clientid, clientmemberid, infosafeid)
        } else {
           // statusCheck = "false"
            completion("", "", "")
            loginVarStatus.statusBool = "false"
        }
        
    }
    
    //start the task
    task.resume()
}

//Call the WCF function: 'GetSDSSearchResultsPageEx' with input data
func  csiWCF_GetSDSSearchResultsPageEx(clientid:String, clientmemberid:String, infosafeid:String, inputData:String, completion:@escaping(String) -> Void) -> (Void) {
    
    let client = clientid
    let uid = infosafeid
    
    //let json: [String: Any] = ["client":"CDB_Test", "uid":"releski", "apptp":"1", "c":"", "v":"acetone", "p":"1", "psize":"50"]
    let json: [String: Any] = ["client":client, "uid":uid, "apptp":"1", "c":"", "v":inputData, "p":"1", "psize":"50"]
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    
    let url = URL(string: "http://gold/CSIMD_WCF/CSI_MD_Service.svc/GetSDSSearchResultsPageEx")!
    
    var request = URLRequest(url: url)
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    
    request.httpBody = jsonData
    
    print(request)
    let task = URLSession.shared.dataTask(with: request) { data, response, error in if let error = error {
            print("Error:", error)
            return
        }
        
        guard let data = data else {return}
        let responseString = String(data: data, encoding: .utf8)
        
        print(responseString as Any)
        completion(responseString!)
    }
    
    task.resume()
    
}


//Create the WCF function: 'LoginReturnValueFix' with inValue
func csiWCF_LoginReturnValueFix(inValue:String) -> (String,String,String){
    print(" returnValueFix traggled")
    
    var clientid: String = ""
    var clientmemberid: String = ""
    var infosafeid: String = ""
    var scText: NSString?
    var tempValue = inValue
    
    
    tempValue = tempValue.replacingOccurrences(of: "\\", with: "")
    tempValue = tempValue.replacingOccurrences(of: "\"", with: "")
    
    print("tempValue: \n \(tempValue)")
    let sc = Scanner(string: tempValue)
    
    while (!sc.isAtEnd) {
        sc.scanUpTo("clientid:", into: nil)
        sc.scanUpTo(",", into: &scText)
        clientid = scText!.components(separatedBy: ":")[1]
        
        sc.scanUpTo("clientmemberid:", into: nil)
        sc.scanUpTo(",", into: &scText)
        clientmemberid = scText!.components(separatedBy: ":")[1]
        
        sc.scanUpTo("infosafeid:", into: nil)
        sc.scanUpTo(",", into: &scText)
        infosafeid = scText!.components(separatedBy: ":")[1]
        break
    }
    print("resutlt: \n \(clientid) \n \(clientmemberid) \n \(infosafeid)")
    
    return (clientid,clientmemberid,infosafeid)
}
