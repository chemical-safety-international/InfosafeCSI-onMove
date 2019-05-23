//
//  WCFMethods.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 7/5/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import Foundation

//var csiWCF_URLHeader = "http://www.csinfosafe.com/CSIMD_WCF/CSI_MD_Service.svc/"
var csiWCF_URLHeader = "http://gold/CSIMD_WCF/CSI_MD_Service.svc/"


// Call the WCF function: 'loginbyEami' with email, password, deviceid, devicemac and return the data from WCF
//WCF for LoginByEamil
func csiWCF_loginbyEmail(email:String, password:String, deviceid:String, devicemac:String, completion: @escaping (String) -> Void) -> (Void)
{

    
    //create a json type string
    let json: [String: Any] = ["email":email, "password":password, "deviceid":deviceid, "devicemac":devicemac]
    
    //serialiazation of json string
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    
    //*create URL string point to wcf method* should be changed after setting up core data
    let url = URL(string: csiWCF_URLHeader + "loginbyEmail")!

    //create request
    var request = URLRequest(url: url)
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"

    //insert json string to the request
    request.httpBody = jsonData
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard let dataResponse = data,
            error == nil else {
                print(error?.localizedDescription ?? "Response Error")
                return }

        //here dataResponse received from a network request
        do {
            //here dataResponse received from a network request
            let decoder = JSONDecoder()
            let model = try decoder.decode(LoginData.self, from:
                dataResponse) //Decode JSON Response Data
            csiclientinfo.clientid = model.clientid
            csiclientinfo.clientmemberid = model.clientmemberid
            csiclientinfo.infosafeid = model.infosafeid
            csiclientinfo.clientcode = model.clientcode
            csiclientinfo.apptype = model.apptype
            
            if model.passed == true {
                completion("true")
            } else if model.passed == false {
                completion("false")
            } else {
                completion("Error")
            }
        } catch let parsingError {
            print("Error", parsingError)
        }
    }
    task.resume()
}

//Call the WCF function: 'GetSDSSearchResultsPageEx' with input data
func csiWCF_GetSDSSearchResultsPage(inputData:String, client: String, uid: String, c:String, p : Int, psize : Int, apptp: Int, completion:@escaping(String) -> Void) -> (Void) {
 
    //create json data
    let json: [String: Any] = ["client":client, "uid":uid, "apptp":apptp, "c":c, "v":inputData, "p":p, "psize":psize]
    
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    
    //setup url
    let url = URL(string: csiWCF_URLHeader + "GetSDSSearchResultsPage")!
    
    //setup request
    var request = URLRequest(url: url)
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    
    request.httpBody = jsonData
    
    //create task

    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard let dataResponse = data,
            error == nil else {
                print(error?.localizedDescription ?? "Response Error")
                return }
        do{
            
            //use JSONSerialization
            let jsonResponse = try JSONSerialization.jsonObject(with:
                dataResponse, options: []) as? [String: AnyObject]

            //print(jsonResponse!)
            

            if let jsonArr1 = jsonResponse!["data"] as? [[String: Any]] {

                jsonArr1.forEach { info in
                    if let com = info["com"] as? [String: Any] {
                        com.forEach { companyName in

                            if companyName.key == "value"
                            {
                                csiclientsearchinfo.arrCompanyName.append(companyName.value as! String)
                            }
                        }
                    }
                    
//                    if let name = info["name"] as? [String: Any] {
//                        name.forEach { pName in
//                                if pName.key == "value"
//                                {
//                                    csiclientsearchinfo.arrProductName.append(pName.value as! String)
//                                }
//                            }
//                        print(csiclientsearchinfo.arrProductName!)
//                    }
                    if let no = info["no"] as? [String: Any] {
                        no.forEach { nocode in
                                if nocode.key == "value"
                                {
                                    csiclientsearchinfo.arrNo.append(nocode.value as! String)
                                }
                            }

                    }
                    
                }
                if csiclientsearchinfo.arrCompanyName != [] {
                    completion("true")
                } else {
                    completion("false")
                }
                print(csiclientsearchinfo.arrCompanyName!)
                print(csiclientsearchinfo.arrNo!)
                }
 
            
            
        } catch let parsingError {
            print("Error", parsingError)
        }
    }
    //start task
    task.resume()
    
}

//Call the WCF function: 'GetSearchCriteriaList'
func csiWCF_GetSearchCriteriaList(clientid:String, infosafeid:String, completion:@escaping(String) -> Void) -> (Void) {
    
    let client = clientid
    let uid = infosafeid
    
    
    //create json data
    let  json:[String:Any] = ["ClientCode":client, "AppType":"1", "UserID":uid]
    
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    
    print(json)
    //setup url
    let url = URL(string: csiWCF_URLHeader + "GetSearchCriteriaList")!
    
    //setup request
    var request = URLRequest(url: url)
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    
    request.httpBody = jsonData
    
    //create task

    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard let dataResponse = data,
            error == nil else {
                print(error?.localizedDescription ?? "Response Error")
                return }
            
            do {
                //here dataResponse received from a network request
                let decoder = JSONDecoder()
                let model = try decoder.decode(CriteriaData.self, from:
                    dataResponse) //Decode JSON Response Data
                

                //Store and seprate the return data
                for noCount in model.items {
                    
                    csicriteriainfo.arrCode.append(noCount.code)
                    csicriteriainfo.arrName.append(noCount.name)
                }
                csicriteriainfo.code = model.items[0].code
                if csicriteriainfo.arrName != [] {
                    completion("true")
                } else {
                    completion("false")
                }

            } catch let parsingError {
                print("Error", parsingError)
            }
    }
    //start task
    task.resume()
    
}

func csiWCF_getHTML(clientid: String, uid: String, sdsNoGet: String, completion:@escaping(String) -> Void) -> (Void) {
    
    let json: [String: Any] = ["client":clientid, "apptp":"1", "uid":uid, "sds": sdsNoGet, "regetFormat":"1", "f":"", "subf":""]
    print(json)
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    
    let url = URL(string: csiWCF_URLHeader + "ViewSDS")!
    
    var request = URLRequest(url:url)
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    
    request.httpBody = jsonData
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard let dataResponse = data,
            error == nil else {
                print(error?.localizedDescription ?? "Response Error")
                return }


        
        do {
            let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options: []) as? [String: Any]
            
            print(jsonResponse!)
            
            let decoder = JSONDecoder()
            let model = try decoder.decode(ViewSDSData.self, from: dataResponse)
            
            completion(model.html)


        } catch let parsingError {
            print("Error", parsingError)
        }
        
        
//        guard let data = data else { return }
//        let responseString = String(data:data, encoding: .utf8)
////        let responseString = data
////        print(responseString as Any)
//
//        completion(responseString!)
    }
    task.resume()
    
}



//func csiWCF_SearchReturnValueFix(inValue:String) -> (Array<Any>, Array<Any>, Array<Any>) {
//
//    var temp = inValue
//    temp = temp.replacingOccurrences(of: "\\", with: "")
//    temp = temp.replacingOccurrences(of: "u000d", with: "")
//    temp = temp.replacingOccurrences(of: "u000a", with: "")
//    temp = temp.replacingOccurrences(of: "\"", with: "")
//
//    var nameArray: Array<String> = []
//    var detailsArray: Array<String> = []
//    var sdsNoArray: Array<String> = []
//
//    var scText:NSString?
//    var name:String
//    var no:String
//    var com:String
//    var issue:String
//    var code:String
//    var unno:String
//    var detailText:String
//
//    let sc = Scanner(string: temp)
//
//    while(!sc.isAtEnd) {
//        sc.scanUpTo("name: {        ", into:nil)
//        sc.scanUpTo(",", into: &scText)
//        name = scText!.components(separatedBy: ":")[2]
//        //            print(name)
//        nameArray.append(name)
//
//        sc.scanUpTo("no: {        ", into:nil)
//        sc.scanUpTo(",", into: &scText)
//        no = scText!.components(separatedBy: ":")[2]
//        sdsNoArray.append(no)
//        //
//        sc.scanUpTo("com: {        ", into:nil)
//        sc.scanUpTo(",", into: &scText)
//        com = scText!.components(separatedBy: ":")[2]
//
//        sc.scanUpTo("issue: {        ", into:nil)
//        sc.scanUpTo(",", into: &scText)
//        issue = scText!.components(separatedBy: ":")[2]
//
//        sc.scanUpTo("code: {        ", into:nil)
//        sc.scanUpTo(",", into: &scText)
//        code = scText!.components(separatedBy: ":")[2]
//
//        sc.scanUpTo("unno: {        ", into:nil)
//        sc.scanUpTo(",", into: &scText)
//        unno = scText!.components(separatedBy: ":")[2]
//
//        detailText = "\rCompany:" + com + "\rSDS NO.:" + no + "\rIssue Date:" + issue + "\rProduct Code:" + code + "\rUNNO:" + unno
//        //            print(detailText)
//        detailsArray.append(detailText)
//    }
//
//    if (nameArray.isEmpty){
//        nameArray = []
//        detailsArray = []
//        sdsNoArray = []
//        return(nameArray, detailsArray, sdsNoArray)
//    } else {
//
//        nameArray.removeLast()
//        detailsArray.removeLast()
//        //        print(sdsNoArray)
//        sdsNoArray.removeLast()
//
//        return(nameArray, detailsArray, sdsNoArray)
//    }
//}
