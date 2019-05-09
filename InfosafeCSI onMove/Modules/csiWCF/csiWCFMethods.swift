//
//  WCFMethods.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 7/5/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import Foundation

// Call the WCF function: 'loginbyEami' with email, password, deviceid, devicemac and return the data from WCF
func csiWCF_loginbyEmail(email:String, password:String, deviceid:String, devicemac:String, completion:@escaping(String) -> Void) -> (Void)
{
    //WCF for LoginByEamil
    
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
        
        //return from this function
        completion(responseString!)
    }
    
    //start the task
    task.resume()
}

//Call the WCF function: 'GetSDSSearchResultsPageEx' with input data
//func  csiWCF_GetSDSSearchResultsPageEx(inputData:String) -> String {
//    <#function body#>
//}


//Call the WCF function: 'ReturnValueFix' with inValue
//func csiWCF_ReturnValueFix(inValue:String) -> String{
//
//}
