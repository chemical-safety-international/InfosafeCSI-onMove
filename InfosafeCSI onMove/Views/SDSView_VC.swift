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
    
    
//    var sdsNo : String = ""
    var strForWeb = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("sds NO. \(String(describing: csicurrentSDS.sdsNo))")
        self.sdsShowPDF()
       // self.sdsShow()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
        getHTML(clientid: csiclientinfo.clientid, uid: csiclientinfo.infosafeid, sdsNoGet: csicurrentSDS.sdsNo) { (output) in
            
//            let temp = output
//            let data = try Data(contentsOf: temp)
//            let fromDataToString = String(data: data, encoding: .isoLatin1)
//            let fromStringToData = Data(base64Encoded: fromDataToString!, options: .ignoreUnknownCharacters)
            
            var temp = output
            var removedstr:NSString?
            var test:NSString?
            var pdfUrl:String = ""
            
            temp = temp.replacingOccurrences(of: "\\\\", with: "\\")
//                        temp = temp.replacingOccurrences(of: "u000d", with: "")
//                        temp = temp.replacingOccurrences(of: "u000a", with: "")
            temp = temp.replacingOccurrences(of: "\\r", with: "\r")
            temp = temp.replacingOccurrences(of: "\\n", with: "\n")
            temp = temp.replacingOccurrences(of: "\\", with: "")
            //print(temp)

            let sc = Scanner(string: temp)
                        while (!sc.isAtEnd) {
                            sc.scanUpTo("\"html\": \"", into: &test)
                            sc.scanUpTo("\n\",u000du000a", into: &removedstr)

//                           let temp2 = String(removedstr!)
//                           let temp3 = String(test!)
//                           print(test as Any)
//                           print(removedstr as Any)
                            pdfUrl = removedstr!.components(separatedBy: "\"html\": \"")[1]
                            //pdfUrl = removedstr! as String
                            print(pdfUrl)
                    }
            
            
            if let data = NSData(base64Encoded: pdfUrl, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters) as Data? {
                self.sdsDisplay.load(data, mimeType: "application/pdf", characterEncodingName: "", baseURL: URL(fileURLWithPath: ""))
            }
            
        }
    }
    
//    func sdsShowPDF() {
//        getHTML(clientid: csiclientinfo.clientid, uid: csiclientinfo.infosafeid, sdsNoGet: csicurrentSDS.sdsNo) { (output) in
//            var temp = output
//            let sc = Scanner(string: temp)
//            var removedstr:NSString?
//            var test:NSString?
//            var pdfUrl:String = ""
//
//            while (!sc.isAtEnd) {
//                sc.scanUpTo("", into: &test)
//                sc.scanUpTo("", into: &removedstr)
//
//                let temp2 = String(removedstr!)
//                let temp3 = String(test!)
//            }
//
//            temp = temp.replacingOccurrences(of: "\\\\", with: "\\")
//            temp = temp.replacingOccurrences(of: "\\n", with: "\n")
//        }
//        }
    
    
//    func sdsShow() {
//        getHTML(clientid: csiclientinfo.clientid, uid: csiclientinfo.infosafeid, sdsNoGet: csicurrentSDS.sdsNo) { (output) in
//            var temp = output
//            temp = temp.replacingOccurrences(of: "\\\\", with: "\\")
//            temp = temp.replacingOccurrences(of: "u000d", with: "")
//            temp = temp.replacingOccurrences(of: "u000a", with: "")
//            temp = temp.replacingOccurrences(of: "\\r", with: "\r")
//            temp = temp.replacingOccurrences(of: "\\n", with: "\n")
//            temp = temp.replacingOccurrences(of: "\\", with: "")
//
//            print(temp)
//
//
//
//            let sc = Scanner(string: temp)
//            var removedstr:NSString?
//            var test:NSString?
//            var wholeHtml:String = ""
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
//
//            let strForWeb = """
//            <html>
//            <head>
//            <meta name="viewport" content="width = device - width, initial-scale = 1">
//            <style>
//            body { font-size: 30%; }
//            </style>
//            </head>
//            <body>
//            \(wholeHtml)
//            </body>
//            </html>
//            """
//
//            DispatchQueue.main.async {
//                self.sdsDisplay.loadHTMLString(strForWeb, baseURL: nil)
//                //self.sdsDisplay.loadHTMLString(temp, baseURL: nil)
//            }
//
//        }
//    }
    

}
