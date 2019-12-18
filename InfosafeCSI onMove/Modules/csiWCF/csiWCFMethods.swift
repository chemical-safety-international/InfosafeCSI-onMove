//
//  WCFMethods.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 7/5/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import Foundation

var csiWCF_URLHeader = "http://www.csinfosafe.com/CSIMD_WCF/CSI_MD_Service.svc/"
//var csiWCF_URLHeader = "http://gold/CSIMD_WCF/CSI_MD_Service.svc/"


// Call the WCF function: 'loginbyEami' with email, password, deviceid, devicemac and return the data from WCF
//WCF for LoginByEamil
func csiWCF_loginbyEmail(email:String, password:String, deviceid:String, devicemac:String, completion: @escaping (Data) -> Void) -> (Void)
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
                
                DispatchQueue.main.async {
                    //send the notification to searchPage_VC
                    NotificationCenter.default.post(name: Notification.Name("errorLogin"), object: nil)
                }
                
                return }
        completion(dataResponse)
    }
    task.resume()
}



//Call the WCF function: 'GetSDSSearchResultsPageEx' with input data
func csiWCF_GetSDSSearchResultsPage(pnameInputData:String, supInputData: String, pcodeInputData: String,  client: String, uid: String, c:String, p : Int, psize : Int, apptp: Int, completion:@escaping(Data) -> Void) -> (Void) {
 
    //create json data
    var advanced: String = "0"
    var type: String = "2"
    var singleValue: String = ""
    var advanArray: [Any] = []
    
    let pnameStr = pnameInputData.trimmingCharacters(in: .whitespacesAndNewlines)
    let supStr = supInputData.trimmingCharacters(in: .whitespacesAndNewlines)
    let pcodeStr = pcodeInputData.trimmingCharacters(in: .whitespacesAndNewlines)
    
    
//    if (pnameStr.isEmpty == false && supStr.isEmpty == true && pcodeStr.isEmpty == true) {
//        advanced = "0"
//        type = "2"
//        singleValue = pnameStr
//    } else if (pnameStr.isEmpty == true && supStr.isEmpty == false && pcodeStr.isEmpty == true) {
//        advanced = "0"
//        type = "4"
//        singleValue = supStr
//
//    } else if (pnameStr.isEmpty == true && supStr.isEmpty == true && pcodeStr.isEmpty == false) {
//        advanced = "0"
//        type = "8"
//        singleValue = pcodeStr
//    } else {
//        advanced = "1"
//    }
//
//    if (pnameStr.isEmpty == false || supStr.isEmpty == false || pcodeStr.isEmpty == false && localcriteriainfo.type1.isEmpty == false) {
//        advanced = "1"
//    }
    



    
//    var add1: [String: Any]!
//    if localcriteriainfo.type1.isEmpty == false {
//
//    } else {
//        add1 = ["type": "", "isgroup": "0", "groups": [], "values": []]
//    }
//
//    var add2: [String: Any]!
//    if localcriteriainfo.type2.isEmpty == false {
//
//    } else {
//        add2 = ["type": "", "isgroup": "0", "groups": [], "values": []]
//    }
//
//    var add3: [String: Any]!
//    if localcriteriainfo.type3.isEmpty == false {
//
//    } else {
//        add3 = ["type": "", "isgroup": "0", "groups": [], "values": []]
//    }

    //add value to the array
    if(pnameStr.isEmpty == false) {
        type = "2"
        singleValue = "0" + pnameStr
        let pName: [String: Any] = ["type": "2", "isgroup": "0", "groups": [], "values": [singleValue]]
        advanArray.append(pName)
    }
    
    if(supStr.isEmpty == false) {
        type = "4"
        singleValue = "0" + supStr
        let sup: [String: Any] = ["type": "4", "isgroup": "0", "groups": [], "values": [singleValue]]
        advanArray.append(sup)
    }
    
    if(pcodeStr.isEmpty == false) {
        type = "8"
        singleValue = "0" + pcodeStr
        let pcode: [String: Any] = ["type": "8", "isgroup": "0", "groups": [], "values": [singleValue]]
        advanArray.append(pcode)
    }
    
    //set for more criterias' values added into the array
    if(localcriteriainfo.type1.isEmpty == false) {
        let add1: [String: Any] = ["type": localcriteriainfo.type1!, "isgroup": "0", "groups": [], "values": [localcriteriainfo.value1]]
        advanArray.append(add1)
    }
    
    if(localcriteriainfo.type2.isEmpty == false) {
        let add2: [String: Any] = ["type": localcriteriainfo.type2!, "isgroup": "0", "groups": [], "values": [localcriteriainfo.value2]]
        advanArray.append(add2)
    }
    
    if(localcriteriainfo.type3.isEmpty == false) {
        let add3: [String: Any] = ["type": localcriteriainfo.type3!, "isgroup": "0", "groups": [], "values": [localcriteriainfo.value3]]
        advanArray.append(add3)
    }
    
    //if array count is more than one  will use multi-search (current all use)
    if (advanArray.count > 1) {
        advanced = "1"
    } else {
        advanced = ""
        singleValue.remove(at: singleValue.startIndex)
    }

    //create json string
    let json: [String: Any] = ["client":client, "uid":uid, "apptp":apptp, "c":type, "v":singleValue, "p":p, "psize":psize, "advanced": advanced, "advancedsitetype": "3", "advanceditems": advanArray]
    
    let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
    
    //setup url
    let url = URL(string: csiWCF_URLHeader + "GetSDSSearchResultsPage")!
    
    //setup request
    var request = URLRequest(url: url)
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    
    request.httpBody = jsonData
    
    
//    print(localcriteriainfo.arrName)
//    print(localcriteriainfo.arrCode)
//    print(advanArray)
    print(json)
    
    //create task
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard let dataResponse = data,
            error == nil else {
                print(error?.localizedDescription ?? "Response Error")
                
                DispatchQueue.main.async {
                    //send the notification to searchPage_VC
                    NotificationCenter.default.post(name: Notification.Name("errorSearch"), object: nil)
                }

                return }
        
        let str = String.init(data: dataResponse, encoding: .utf8)
        print(str as Any)
        completion(dataResponse)
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
                let model = try decoder.decode(outCriteriaData.self, from:
                    dataResponse) //Decode JSON Response Data


                //Store and seprate the return data
                for noCount in model.items {

                    localcriteriainfo.arrCode.append(noCount.code)
                    localcriteriainfo.arrName.append(noCount.name)
                }
                localcriteriainfo.code = model.items[0].code

                print(localcriteriainfo.arrCode)
                print(localcriteriainfo.arrName)
                if localcriteriainfo.arrName != [] {
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

func csiWCF_getSDS(clientid: String, uid: String, sdsNoGet: String, apptp : String, rtype: String, completion:@escaping(outViewSDSData) -> Void) -> (Void) {

    let json: [String: Any] = ["client":clientid, "apptp": apptp, "uid":uid, "sds": sdsNoGet, "rtype" : rtype, "regetFormat":"1", "f":"", "subf":""]
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
                DispatchQueue.main.async {
                    //send the notification to searchPage_VC
                    NotificationCenter.default.post(name: Notification.Name("errorSDSView"), object: nil)
                }
                return }

        do {
            let decoder = JSONDecoder()
            let model = try decoder.decode(outViewSDSData.self, from: dataResponse)
            
//            let str = String.init(data: dataResponse, encoding: .utf8)
//            print(str as Any)
            
            completion(model)

        } catch let parsingError {
            print("Error", parsingError)
        }
        
        
    }
    task.resume()
}

func csiWCF_getCoreInfo(clientid: String, uid: String, sdsNoGet: String, apptp : String, rtype: String, completion:@escaping(outViewSDSCore) -> Void) -> (Void) {

    let json: [String: Any] = ["client":clientid, "apptp": apptp, "uid":uid, "sds": sdsNoGet, "rtype" : rtype, "regetFormat":"1", "f":"", "subf":""]
    let jsonData = try? JSONSerialization.data(withJSONObject: json)

    let url = URL(string: csiWCF_URLHeader + "ViewSDS_Core")!
    
    var request = URLRequest(url:url)
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    
    request.httpBody = jsonData
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard let dataResponse = data,
            error == nil else {
                print(error?.localizedDescription ?? "Response Error")
//                DispatchQueue.main.async {
//                    //send the notification to searchPage_VC
//                    NotificationCenter.default.post(name: Notification.Name("errorSDSView"), object: nil)
//                }
                return }

        do {
//            let str = String.init(data: dataResponse, encoding: .utf8)
            let decoder = JSONDecoder()
            let cModel = try decoder.decode(outViewSDSCore.self, from: dataResponse)

            completion(cModel)

        } catch let parsingError {
            print("Error", parsingError)
        }
        
        
    }
    task.resume()
}

func csiWCF_getClassification(clientid: String, uid: String, sdsNoGet: String, apptp : String, rtype: String, completion:@escaping(outViewSDSGHS) -> Void) -> (Void) {

    let json: [String: Any] = ["client":clientid, "apptp": apptp, "uid":uid, "sds": sdsNoGet, "rtype" : rtype, "regetFormat":"1", "f":"", "subf":""]
    let jsonData = try? JSONSerialization.data(withJSONObject: json)

    let url = URL(string: csiWCF_URLHeader + "ViewSDS_Classification")!
    
    var request = URLRequest(url:url)
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    
    request.httpBody = jsonData
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard let dataResponse = data,
            error == nil else {
                print(error?.localizedDescription ?? "Response Error")
//                DispatchQueue.main.async {
//                    //send the notification to searchPage_VC
//                    NotificationCenter.default.post(name: Notification.Name("errorSDSView"), object: nil)
//                }
                return }

        do {

            let decoder = JSONDecoder()
            let cModel = try decoder.decode(outViewSDSGHS.self, from: dataResponse)
            
            let str = String.init(data: dataResponse, encoding: .utf8)
            print(str as Any)
            
            completion(cModel)

        } catch let parsingError {
            print("Error", parsingError)
        }
        
        
    }
    task.resume()
}

func csiWCF_getFirstAid(clientid: String, uid: String, sdsNoGet: String, apptp : String, rtype: String, completion:@escaping(outViewSDSFA) -> Void) -> (Void) {

    let json: [String: Any] = ["client":clientid, "apptp": apptp, "uid":uid, "sds": sdsNoGet, "rtype" : rtype, "regetFormat":"1", "f":"", "subf":""]
    let jsonData = try? JSONSerialization.data(withJSONObject: json)

    let url = URL(string: csiWCF_URLHeader + "ViewSDS_FirstAid")!
    
    var request = URLRequest(url:url)
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    
    request.httpBody = jsonData
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard let dataResponse = data,
            error == nil else {
                print(error?.localizedDescription ?? "Response Error")
//                DispatchQueue.main.async {
//                    //send the notification to searchPage_VC
//                    NotificationCenter.default.post(name: Notification.Name("errorSDSView"), object: nil)
//                }
                return }

        do {
//            let str = String.init(data: dataResponse, encoding: .utf8)
            let decoder = JSONDecoder()
            let cModel = try decoder.decode(outViewSDSFA.self, from: dataResponse)
//            print(str as Any)
            completion(cModel)

        } catch let parsingError {
            print("Error", parsingError)
        }
        
        
    }
    task.resume()
}


func csiWCF_getTransport(clientid: String, uid: String, sdsNoGet: String, apptp : String, rtype: String, completion:@escaping(outViewSDSTI) -> Void) -> (Void) {

    let json: [String: Any] = ["client":clientid, "apptp": apptp, "uid":uid, "sds": sdsNoGet, "rtype" : rtype, "regetFormat":"1", "f":"", "subf":""]
    let jsonData = try? JSONSerialization.data(withJSONObject: json)

    let url = URL(string: csiWCF_URLHeader + "ViewSDS_Transport")!
    
    var request = URLRequest(url:url)
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    
    request.httpBody = jsonData
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard let dataResponse = data,
            error == nil else {
                print(error?.localizedDescription ?? "Response Error")
//                DispatchQueue.main.async {
//                    //send the notification to searchPage_VC
//                    NotificationCenter.default.post(name: Notification.Name("errorSDSView"), object: nil)
//                }
                return }

        do {

            let decoder = JSONDecoder()
            let cModel = try decoder.decode(outViewSDSTI.self, from: dataResponse)
            
            let str = String.init(data: dataResponse, encoding: .utf8)
            print(str as Any)
            
            completion(cModel)

        } catch let parsingError {
            print("Error", parsingError)
        }
        
        
    }
    task.resume()
}
