//
//  SDSView_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 5/13/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit
import WebKit

import PDFKit

class SDSViewPage_VC: UIViewController {

    @IBOutlet weak var sdsDisplay: WKWebView?
    
    @IBOutlet weak var printBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.sdsShowPDF()
        self.sdsShow()
        printBtn.isHidden = true
    }
    
    func sdsShow() {
        self.showSpinner(onView: self.view)
        let rtype : String = "1"
        csiWCF_VM().callSDS(rtype : rtype) { (completionReturnData) in
            DispatchQueue.main.async {
                self.removeSpinner()
                
                if rtype == "1" {
                    //PDF return string must be base64string
                    let decodeData = Data(base64Encoded: completionReturnData, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
                    self.sdsDisplay!.load(decodeData!, mimeType: "application/pdf", characterEncodingName: "UTF-8", baseURL: URL(fileURLWithPath: ""))
                    localcurrentSDS.pdfData = decodeData
                    self.printBtn.isHidden = false
                    
                }
                else if rtype == "2" {
                    self.sdsDisplay!.loadHTMLString(String(describing: completionReturnData), baseURL: nil)
                }
            }
            
        }
    }
    @IBAction func printBtnTapped(_ sender: Any) {
        printPDF(data: localcurrentSDS.pdfData)
    }
    
    func printPDF(data: Data) {
        
        if UIPrintInteractionController.canPrint(data) {
            let printInfo = UIPrintInfo(dictionary: nil)
            printInfo.outputType = .general
            
            let printController = UIPrintInteractionController.shared
            printController.printInfo = printInfo
            printController.showsNumberOfCopies = false
            
            printController.printingItem = data
            printController.present(animated: true, completionHandler: nil)
        }
    }
}

extension String {
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}


class SplitView_VC: UIViewController {
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var viewSDSBtn: UIButton!
    @IBOutlet weak var sdsDisplay: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //        setUpImgforBtns()
        if localcurrentSDS.sdsNo != nil {
            self.sdsShow()
        }
        
    }
    
    //    func setUpImgforBtns() {
    //        let img = UIImage(named: "CSI-ViewSDS")
    //        viewSDSBtn.setImage(img, for: .normal)
    //        viewSDSBtn.imageView?.contentMode = .scaleAspectFill
    //    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func sdsShow() {
        self.showSpinner(onView: self.view)
        let rtype : String = "1"
        csiWCF_VM().callSDS(rtype : rtype) { (completionReturnData) in
            DispatchQueue.main.async {
                self.removeSpinner()
                
                if rtype == "1" {
                    //PDF return string must be base64string
                    let decodeData = Data(base64Encoded: completionReturnData, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
                    self.sdsDisplay!.load(decodeData!, mimeType: "application/pdf", characterEncodingName: "UTF-8", baseURL: URL(fileURLWithPath: ""))
                    localcurrentSDS.pdfData = decodeData
                    
                }
                else if rtype == "2" {
                    self.sdsDisplay!.loadHTMLString(String(describing: completionReturnData), baseURL: nil)
                }
            }
            
        }
    }
    
    @IBAction func viewSDSBtnTapped(_ sender: Any) {
        self.sdsShow()
    }
    
}
