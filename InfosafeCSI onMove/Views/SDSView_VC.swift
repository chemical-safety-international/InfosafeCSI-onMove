//
//  SDSView_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 5/13/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit
import WebKit

class SDSView_VC: UIViewController {

    @IBOutlet weak var sdsDisplay: WKWebView?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.sdsShowPDF()
        self.sdsShow()
    }

//    func loadPDF(pdfUrl: String) {
//        let url = URL(string: pdfUrl)
//        
//        do {
//            let data = try Data(contentsOf: url!)
//            sdsDisplay.load(data, mimeType: "application/pdf", characterEncodingName: "", baseURL: url!.deletingLastPathComponent())
//        } catch {
//            //handle error
//        }
//    }
  
    func sdsShowPDF() {
        csiWCF_getHTML(clientid: csiclientinfo.clientid, uid: csiclientinfo.infosafeid, sdsNoGet: csicurrentSDS.sdsNo) { (output) in
            
//            let temp = output
//            let data = try Data(contentsOf: temp)
//            let fromDataToString = String(data: data, encoding: .isoLatin1)
//            let fromStringToData = Data(base64Encoded: fromDataToString!, options: .ignoreUnknownCharacters)
            

            var temp = output
            var removedstr:NSString?
            var test:NSString?
            var pdfUrl:String = ""
            
            
            temp = temp.replacingOccurrences(of: "\\\\", with: "\\")
            temp = temp.replacingOccurrences(of: "\\r", with: "\r")
            temp = temp.replacingOccurrences(of: "\\n", with: "\n")
            temp = temp.replacingOccurrences(of: "\\", with: "")
//            temp = temp.replacingOccurrences(of: "u000d", with: "")
//            temp = temp.replacingOccurrences(of: "u000a", with: "")

            //let string = "[{\"form_id\":3465,\"canonical_name\":\"df_SAWERQ\",\"form_name\":\"Activity 4 with Images\",\"form_desc\":null}]"

            
//            print(string)
//
//            let data = string.data(using: .utf8)!
//            do {
//                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
//                {
//                    print(jsonArray) // use the json here
//                } else {
//                    print("bad json")
//                }
//            } catch let error as NSError {
//                print(error)
//            }
//
//
//            do {
//                let decoder = JSONDecoder()
//                let product = try decoder.decode(ViewSDSData.self, from: data)
//
//                print(product)
//            }catch
//            {
//
//            }
            
            let sc = Scanner(string: temp)
                        while (!sc.isAtEnd) {
                            sc.scanUpTo("\"html\": \"", into: &test)
                            sc.scanUpTo("\\u000d\\u000a}\"", into: &removedstr)

//                           let temp2 = String(removedstr!)
//                           let temp3 = String(test!)
//                           print(test as Any)
//                           print(removedstr as Any)
                            pdfUrl = removedstr!.components(separatedBy: "\"html\": \"")[1]
                            //pdfUrl = removedstr! as String
                            print(pdfUrl)
                    }
            
            
//            if let data = NSData(base64Encoded: pdfUrl, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters) as Data? {
//                self.sdsDisplay.load(data, mimeType: "application/pdf", characterEncodingName: "", baseURL: URL(fileURLWithPath: ""))
            
                let pdfData = Data(base64Encoded: pdfUrl, options: .ignoreUnknownCharacters)
                
                // here you can display the pdf on a UIWebView
            self.sdsDisplay!.load(pdfData!,
                             mimeType: "application/pdf",
                             characterEncodingName: "UTF-8",
                             baseURL: URL(fileURLWithPath: ""))

            }
            
        }
    
    func sdsShow() {
        self.showSpinner(onView: self.view)
        csiWCF_VM().callSDS() { (completionReturnData) in
            DispatchQueue.main.async {
                self.removeSpinner()
                self.sdsDisplay!.loadHTMLString(completionReturnData, baseURL: nil)
                //self.sdsDisplay.loadHTMLString(temp, baseURL: nil)
            }
            
        }
    }
}



