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
func csiWCF_GetSDSSearchResultsPage(inputData:String, client: String, uid: String, c:String, p : Int, psize : Int, apptp: Int, completion:@escaping(Data) -> Void) -> (Void) {
 
    //create json data
//    let json: [String: Any] = ["client":client, "uid":uid, "apptp":apptp, "c":c, "v":inputData, "p":p, "psize":psize, "advanced": "0", "advancedsitetype": "3", "advanceditems": ["type": 2, "isgroup": 0, "groups": [], "values": inputData]]
    
//    let json: [String: Any] = ["client":client, "uid":uid, "apptp":"\(apptp)", "c":c, "v":inputData, "p":"\(p)", "psize":"\(psize)", "advanced": "0", "advancedsitetype": "3", "advanceditems": []]
        let json: [String: Any] = ["client":client, "uid":uid, "apptp":apptp, "c":c, "v":inputData, "p":p, "psize":psize, "advanced": "0", "advancedsitetype": "3", "advanceditems": []]
    
//    let pNJson: [String: Any] = ["IsAdvanced":"true", "AdvancedCriteria": [ [ "SearchType": "2", "SearchValues": "", "IsGroup":"false", "Groups": [], "IsMixtrue": false, "Mixtures": "null"], [ "SearchType": "8", "SearchValues": "", "IsGroup": false, "Groups": [], "IsMixtrue": false, "Mixtures": "null"], [ "SearchType": "4", "SearchValues": "", "IsGroup": false, "Groups": [], "IsMixtrue": false, "Mixtures": "null"]]]
    
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    
    //setup url
    let url = URL(string: csiWCF_URLHeader + "GetSDSSearchResultsPage")!
    
    //setup request
    var request = URLRequest(url: url)
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    
    request.httpBody = jsonData
    
//    print(json)
    
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
        
//        let str = String.init(data: dataResponse, encoding: .utf8)
//        print(str as Any)
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
//            let str = String.init(data: dataResponse, encoding: .utf8)
            let decoder = JSONDecoder()
            let cModel = try decoder.decode(outViewSDSGHS.self, from: dataResponse)
//            print(str as Any)
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
//            let str = String.init(data: dataResponse, encoding: .utf8)
            let decoder = JSONDecoder()
            let cModel = try decoder.decode(outViewSDSTI.self, from: dataResponse)
//            print(str as Any)
            completion(cModel)

        } catch let parsingError {
            print("Error", parsingError)
        }
        
        
    }
    task.resume()
}
