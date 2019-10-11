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
    
    @IBOutlet weak var shareBtn: UIButton!
    
    fileprivate var pdfArray = [localPDF]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        
        self.sdsShow()
        printBtn.isHidden = true
        shareBtn.isHidden = true
        

        if self.isMovingFromParent {
            WKWebView.clean()
        }
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(errorHandle), name: NSNotification.Name("errorSDSView"), object: nil)
    }
    
    @objc private func errorHandle() {
        self.removeSpinner()
        self.showAlert(title: "Connection failure!", message: "Please check the connection and try again!")
    }
    
    
    func sdsShow() {
        self.showSpinner(onView: self.view)

        let pdfArray = CoreDataManager.fetchPDF(targetText: localcurrentSDS.sdsNo)

        if pdfArray.count != 0 {
            DispatchQueue.main.async {

//                print("\(pdfArray[0].sdsno!)")
                let decodeData = Data(base64Encoded: pdfArray[0].pdfdata!, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
                self.sdsDisplay!.load(decodeData!, mimeType: "application/pdf", characterEncodingName: "UTF-8", baseURL: URL(fileURLWithPath: ""))
                localcurrentSDS.pdfData = decodeData
                self.printBtn.isHidden = false
                self.shareBtn.isHidden = false
                self.removeSpinner()
            }
        } else {

            let rtype : String = "1"
            csiWCF_VM().callSDS(rtype : rtype) { (completionReturnData) in
                DispatchQueue.main.async {

                    if rtype == "1" {
                        //PDF return string must be base64string
                        let decodeData = Data(base64Encoded: completionReturnData, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
                        self.sdsDisplay!.load(decodeData!, mimeType: "application/pdf", characterEncodingName: "UTF-8", baseURL: URL(fileURLWithPath: ""))
                        localcurrentSDS.pdfData = decodeData
                        self.printBtn.isHidden = false
                        self.shareBtn.isHidden = false

                        CoreDataManager.storePDF(sdsno: localcurrentSDS.sdsNo, pdfdata: completionReturnData)
                        self.removeSpinner()
                    }
                    else if rtype == "2" {
                        self.sdsDisplay!.loadHTMLString(String(describing: completionReturnData), baseURL: nil)
                        self.printBtn.isHidden = false
                        self.shareBtn.isHidden = false
                        self.removeSpinner()
                    }
                }
            }
        }
        
    }
    
    
    @IBAction func printBtnTapped(_ sender: Any) {
        printPDF(data: localcurrentSDS.pdfData)
    }
    
    
    @IBAction func shareBtnTapped(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: [localcurrentSDS.pdfData!], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
        
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
    
    @IBOutlet weak var splitPrintBtn: UIButton!
    @IBOutlet weak var splitShareBtn: UIButton!
    
    @IBOutlet weak var coreInfoBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //        setUpImgforBtns()
        if localcurrentSDS.sdsNo != nil {
//            self.spliteSDSShow()
//            splitPrintBtn.isHidden = true
//            splitShareBtn.isHidden = true
        }
        splitPrintBtn.isHidden = true
        splitShareBtn.isHidden = true
        
//        NotificationCenter.default.addObserver(self, selector: #selector(errorHandle), name: NSNotification.Name("errorSplitSDSView"), object: nil)
    }
    
//    @objc private func errorHandle() {
//        self.removeSpinner()
//        self.showAlert(title: "Connection failure!", message: "Please check the connection and try again!")
//    }
    
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
    
    func spliteSDSShow() {
        print("reach spliteSDSShow()")
        self.showSpinner(onView: self.view)
        
        let pdfArray = CoreDataManager.fetchPDF(targetText: localcurrentSDS.sdsNo)
        
        if pdfArray.count != 0 {
            DispatchQueue.main.async {
                
                print("\(pdfArray[0].sdsno!)")
                let decodeData = Data(base64Encoded: pdfArray[0].pdfdata!, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
                self.sdsDisplay!.load(decodeData!, mimeType: "application/pdf", characterEncodingName: "UTF-8", baseURL: URL(fileURLWithPath: ""))
                localcurrentSDS.pdfData = decodeData
                
                self.splitPrintBtn.isHidden = false
                self.splitShareBtn.isHidden = false
                self.removeSpinner()
            }
        } else {
            
            let rtype : String = "1"
            csiWCF_VM().callSDS(rtype : rtype) { (completionReturnData) in
                DispatchQueue.main.async {
                    
                    if rtype == "1" {
                        //PDF return string must be base64string
                        let decodeData = Data(base64Encoded: completionReturnData, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
                        self.sdsDisplay!.load(decodeData!, mimeType: "application/pdf", characterEncodingName: "UTF-8", baseURL: URL(fileURLWithPath: ""))
                        localcurrentSDS.pdfData = decodeData
                        
                        CoreDataManager.storePDF(sdsno: localcurrentSDS.sdsNo, pdfdata: completionReturnData)
                        
                        self.splitPrintBtn.isHidden = false
                        self.splitShareBtn.isHidden = false
                        self.removeSpinner()
                    }
                    else if rtype == "2" {
                        self.sdsDisplay!.loadHTMLString(String(describing: completionReturnData), baseURL: nil)
                        
                        self.splitPrintBtn.isHidden = false
                        self.splitShareBtn.isHidden = false
                        self.removeSpinner()
                    }
                }
            }
        }
    }
    
    @IBAction func viewSDSBtnTapped(_ sender: Any) {
        if localcurrentSDS.sdsNo != nil {
            self.spliteSDSShow()
        }
    }
    
    @IBAction func splitPrintBtnTapped(_ sender: Any) {
        SDSViewPage_VC().printPDF(data: localcurrentSDS.pdfData)
    }
        
    @IBAction func splitShareBtnTapped(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: [localcurrentSDS.pdfData!], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func coreInfoBtnTapped(_ sender: Any) {
        let sdsJump = storyboard?.instantiateViewController(withIdentifier: "SDSCore") as? SDSViewCore_VC
        self.navigationController?.pushViewController(sdsJump!, animated: true)
    }
}




extension WKWebView {
    class func clean() {
        guard #available(iOS 9.0, *) else {return}
        
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in records.forEach {
            record in
            WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            #if DEBUG
            print("WKWebsiteDataStore record deleted:", record)
            #endif
            }
        }
    }
}
