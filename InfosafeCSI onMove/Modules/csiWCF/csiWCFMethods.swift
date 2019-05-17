//
//  WCFMethods.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 7/5/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import Foundation

var csiWCF_oldURLHeader = "http://www.csinfosafe.com/CSIMD_WCF/CSI_MD_Service.svc/"
var csiWCF_goldURLHeader = "http://gold/CSIMD_WCF/CSI_MD_Service.svc/"


// Call the WCF function: 'loginbyEami' with email, password, deviceid, devicemac and return the data from WCF
//WCF for LoginByEamil
func csiWCF_loginbyEmail(email:String, password:String, deviceid:String, devicemac:String, completion: @escaping (String) -> Void) -> (Void)
{

    
    //create a json type string
    let json: [String: Any] = ["email":email, "password":password, "deviceid":deviceid, "devicemac":devicemac]
    
    //serialiazation of json string
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    
    //*create URL string point to wcf method* should be changed after setting up core data
    let url = URL(string: csiWCF_goldURLHeader + "loginbyEmail2")!

    //create request
    var request = URLRequest(url: url)
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"

    //insert json string to the request
    request.httpBody = jsonData

////    print(request)
//    //create a session to call wcf method
//    let task = URLSession.shared.dataTask(with: request) { data, response, error in if let error = error {
//        // print out error
//        print("Error:", error)
//        return
//        }
    
        //guard let url = URL(string: csiWCF_URLHeader + "loginbyEmail2") else {return}
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                print(jsonResponse) //Response result
                
                do {
                    //here dataResponse received from a network request
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(LoginData.self, from:
                        dataResponse) //Decode JSON Response Data
                    print(model)
                    csiclientinfo.clientid = model.clientid
                    csiclientinfo.clientmemberid = model.clientmemberid
                    csiclientinfo.infosafeid = model.infosafeid
                    if model.passed == true {
                        completion("true")
                    } else if model.passed == false {
                        completion("false")
                    }
                } catch let parsingError {
                    print("Error", parsingError)
                }
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
        
//        print("json:", json)
        
        //get the return data
        //guard let data = data else {return}
//        let responseString = String(data: data, encoding: .utf8)
//        completion(responseString!)
//
//        if (responseString?.contains("true"))! {
//            print(responseString as Any)
//
//            let clientinfo = csiWCF_LoginReturnValueFix(inValue: responseString!)
//            csiclientinfo.clientid = clientinfo.0
//            csiclientinfo.clientmemberid = clientinfo.1
//            csiclientinfo.infosafeid = clientinfo.2
//        } else {
//            csiclientinfo.clientid = ""
//            csiclientinfo.clientloginstatus = "false"
//        }
//
    
   // }
    
    //start the task
    //task.resume()
}

//Call the WCF function: 'GetSDSSearchResultsPageEx' with input data
func csiWCF_GetSDSSearchResultsPageEx(clientid:String, infosafeid:String, inputData:String, completion:@escaping(String) -> Void) -> (Void) {
    
    let client = clientid
    let uid = infosafeid
    
    //create json data
    let json: [String: Any] = ["client":client, "uid":uid, "apptp":"1", "c":"", "v":inputData, "p":"1", "psize":"50"]
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    
    //setup url
    let url = URL(string: csiWCF_oldURLHeader + "GetSDSSearchResultsPageEx")!
    
    //setup request
    var request = URLRequest(url: url)
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    
    request.httpBody = jsonData
    
    //create task
    let task = URLSession.shared.dataTask(with: request) { data, response, error in if let error = error {
            print("Error:", error)
            return
        }
        
        guard let data = data else {return}
        let responseString = String(data: data, encoding: .utf8)
        completion(responseString!)
 //       print(responseString as Any)
        
    }
    //start task
    task.resume()
    
}

func csiWCF_getHTML(clientid: String, uid: String, sdsNoGet: String, completion:@escaping(String) -> Void) -> (Void) {
    let sdsNoGet = sdsNoGet.replacingOccurrences(of: " ", with: "")
    
    let json: [String: Any] = ["client":clientid, "apptp":"1", "uid":uid, "sds": sdsNoGet, "regetFormat":"1", "f":"", "subf":""]
    print(json)
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    
    let url = URL(string: csiWCF_oldURLHeader + "ViewSDS")!
    
    var request = URLRequest(url:url)
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    
    request.httpBody = jsonData
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in if let error = error {
        print("Error:", error)
        return
        }
        
        guard let data = data else { return }
        let responseString = String(data:data, encoding: .utf8)
//        let responseString = data
//        print(responseString as Any)
        
        completion(responseString!)
    }
    task.resume()
}

//Create the WCF function: 'LoginReturnValueFix' with inValue
//func csiWCF_LoginReturnValueFix(inValue:String) -> (String,String,String){
////    print(" returnValueFix traggled")
//    
//    var clientid: String = ""
//    var clientmemberid: String = ""
//    var infosafeid: String = ""
//    var scText: NSString?
//    var tempValue = inValue
//    
//    
//    tempValue = tempValue.replacingOccurrences(of: "\\", with: "")
//    tempValue = tempValue.replacingOccurrences(of: "\"", with: "")
//    
////    print("tempValue: \n \(tempValue)")
//    let sc = Scanner(string: tempValue)
//    
//    while (!sc.isAtEnd) {
//        sc.scanUpTo("clientid:", into: nil)
//        sc.scanUpTo(",", into: &scText)
//        clientid = scText!.components(separatedBy: ":")[1]
//        
//        sc.scanUpTo("clientmemberid:", into: nil)
//        sc.scanUpTo(",", into: &scText)
//        clientmemberid = scText!.components(separatedBy: ":")[1]
//        
//        sc.scanUpTo("infosafeid:", into: nil)
//        sc.scanUpTo(",", into: &scText)
//        infosafeid = scText!.components(separatedBy: ":")[1]
//        break
//    }
////    print("resutlt: \n \(clientid) \n \(clientmemberid) \n \(infosafeid)")
//    
//    return (clientid,clientmemberid,infosafeid)
//}


func csiWCF_SearchReturnValueFix(inValue:String) -> (Array<Any>, Array<Any>, Array<Any>) {
    
    var temp = inValue
    temp = temp.replacingOccurrences(of: "\\", with: "")
    temp = temp.replacingOccurrences(of: "u000d", with: "")
    temp = temp.replacingOccurrences(of: "u000a", with: "")
    temp = temp.replacingOccurrences(of: "\"", with: "")
    
    var nameArray: Array<String> = []
    var detailsArray: Array<String> = []
    var sdsNoArray: Array<String> = []
    
    var scText:NSString?
    var name:String
    var no:String
    var com:String
    var issue:String
    var code:String
    var unno:String
    var detailText:String
    
    let sc = Scanner(string: temp)
    
    while(!sc.isAtEnd) {
        sc.scanUpTo("name: {        ", into:nil)
        sc.scanUpTo(",", into: &scText)
        name = scText!.components(separatedBy: ":")[2]
        //            print(name)
        nameArray.append(name)
        
        sc.scanUpTo("no: {        ", into:nil)
        sc.scanUpTo(",", into: &scText)
        no = scText!.components(separatedBy: ":")[2]
        sdsNoArray.append(no)
        //
        sc.scanUpTo("com: {        ", into:nil)
        sc.scanUpTo(",", into: &scText)
        com = scText!.components(separatedBy: ":")[2]
        
        sc.scanUpTo("issue: {        ", into:nil)
        sc.scanUpTo(",", into: &scText)
        issue = scText!.components(separatedBy: ":")[2]
        
        sc.scanUpTo("code: {        ", into:nil)
        sc.scanUpTo(",", into: &scText)
        code = scText!.components(separatedBy: ":")[2]
        
        sc.scanUpTo("unno: {        ", into:nil)
        sc.scanUpTo(",", into: &scText)
        unno = scText!.components(separatedBy: ":")[2]
        
        detailText = "\rCompany:" + com + "\rSDS NO.:" + no + "\rIssue Date:" + issue + "\rProduct Code:" + code + "\rUNNO:" + unno
        //            print(detailText)
        detailsArray.append(detailText)
    }
    
    if (nameArray.isEmpty){
        nameArray = []
        detailsArray = []
        sdsNoArray = []
        return(nameArray, detailsArray, sdsNoArray)
    } else {
        
        nameArray.removeLast()
        detailsArray.removeLast()
        //        print(sdsNoArray)
        sdsNoArray.removeLast()
        
        return(nameArray, detailsArray, sdsNoArray)
    }
}
