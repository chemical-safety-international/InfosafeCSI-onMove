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
        self.sdsShow()
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
        getHTML(clientid: csiclientinfo.clientid, uid: csiclientinfo.infosafeid, sdsNoGet: csicurrentSDS.sdsNo) { (output) in
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
                sc.scanUpTo("\"html\": \"", into:&test)
                sc.scanUpTo("\",  \"title\"", into: &removedstr)
                let temp2 = String(describing: removedstr)
                let temp3 = String(describing: test)
                
                wholeHtml = removedstr!.components(separatedBy: "\"html\": \"")[1]
                //print("whole HTML is \r\r\r", wholeHtml)
            }
            
            let strForWeb = """
            <html>
            <head>
            <meta name="viewport" content="width = device - width, initial-scale = 1">
            <style>
            body { font-size: 30%; }
            </style>
            </head>
            <body>
            \(wholeHtml)
            </body>
            </html>
            """
            
            DispatchQueue.main.async {
                self.sdsDisplay.loadHTMLString(strForWeb, baseURL: nil)
                //self.sdsDisplay.loadHTMLString(temp, baseURL: nil)
            }
            
        }
    }
    

}
