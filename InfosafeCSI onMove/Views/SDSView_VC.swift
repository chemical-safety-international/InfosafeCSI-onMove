//
//  SDSView_VC.swift
//  InfosafeCSI onMove
//
//  Created by Sailing on 5/13/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit
import WebKit

class SDSView_VC: UIViewController {

    @IBOutlet weak var sdsDisplay: WKWebView!
    
    
    var sdsNo = ""
    var strForWeb = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func sdsShow() {
        getHTML(sdsNoGet: sdsNo) { (output) in
            var temp = output
            temp = temp.replacingOccurrences(of: "\\\\", with: "\\")
            temp = temp.replacingOccurrences(of: "u000d", with: "")
            temp = temp.replacingOccurrences(of: "u000a", with: "")
            temp = temp.replacingOccurrences(of: "\\r", with: "\r")
            temp = temp.replacingOccurrences(of: "\\n", with: "\n")
            temp = temp.replacingOccurrences(of: "\\", with: "")
            
            let sc = Scanner(string: temp)
            var removedstr:NSString?
            var test:NSString?
            var wholeHtml:String = ""
            
            while (!sc.isAtEnd) {
                sc.scanUpTo("\"html\": \"", into: &test)
                sc.scanUpTo("\",  \"title\"", into: &removedstr)
                let temp2 = String(describing: removedstr)
                let temp3 = String(describing: test)
                
                wholeHtml = removedstr!.components(separatedBy: "\"html\": \"")[1]
                print("whole HTML is \r\r\r", wholeHtml)
            }
            
            let strForWeb = """
    
            
        }
    }
    
    func getHTML(sdsNoGet: String, completion:@escaping(String) -> Void) -> (Void) {
        let sdsNoGet = sdsNoGet.replacingOccurrences(of: " ", with: "")
        
        let json: [String: Any] = ["client":"CDB_Test", "apptp":"1", "uid":"releski", "sds": sdsNoGet, "regetFormat":"", "f":"", "subf":""]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let url = URL(string: "http://www.csinfosafe.com/CSIMD_WCF/CSI_MD_Service.svc/ViewSDSD")!
        
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
            
            completion(responseString!)
        }
        task.resume()
    }

}
