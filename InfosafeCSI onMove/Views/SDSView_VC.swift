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
        
        
        setNavbar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(errorHandle), name: NSNotification.Name("errorSDSView"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setNavbarShareBtn"), object: nil)
        }
    }
    
    @objc private func errorHandle() {
        self.removeSpinner()
        self.showAlert(title: "Connection failure!", message: "Please check the connection and try again!")
    }
    
    func setNavbar() {
        navigationItem.title = "VIEW SDS"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25), .foregroundColor: UIColor.white]
        
        let btnShare = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareBtnTapped))
        self.navigationItem.rightBarButtonItem = btnShare
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
                
                if (UIDevice.current.userInterfaceIdiom == .pad) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setNavbarShareBtn"), object: nil)
                }
                
                self.removeSpinner()
            }
        } else {

            let rtype : String = "1"
            csiWCF_VM().callSDS(sdsno: localcurrentSDS.sdsNo, rtype : rtype) { (completionReturnData) in
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
    @IBOutlet weak var ciBtn: UIButton!
    @IBOutlet weak var sdsDisplay: WKWebView!
    
    @IBOutlet weak var splitPrintBtn: UIButton!
    @IBOutlet weak var splitShareBtn: UIButton!
    
    @IBOutlet weak var cfBtn: UIButton!
    @IBOutlet weak var faBtn: UIButton!
    @IBOutlet weak var tiBtn: UIButton!
    @IBOutlet weak var viewSDSBtn: UIButton!
    
    @IBOutlet weak var ciLbl: UILabel!
    @IBOutlet weak var cfLbl: UILabel!
    @IBOutlet weak var faLbl: UILabel!
    @IBOutlet weak var tiLbl: UILabel!
    @IBOutlet weak var vsLbl: UILabel!
    

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var GHSContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //        setUpImgforBtns()
        if localcurrentSDS.sdsNo != nil {
//            self.spliteSDSShow()
//            splitPrintBtn.isHidden = true
//            splitShareBtn.isHidden = true
        }
//        splitPrintBtn.isHidden = true
//        splitShareBtn.isHidden = true
//        containerView.isHidden = true
//
//        ciBtn.isHidden = true
//        cfBtn.isHidden = true
//        faBtn.isHidden = true
//        tiBtn.isHidden = true
//        viewSDSBtn.isHidden = true
//
//        ciLbl.isHidden = true
//        cfLbl.isHidden = true
//        faLbl.isHidden = true
//        tiLbl.isHidden = true
//        vsLbl.isHidden = true
        
        menuView.layer.cornerRadius = 15
        sdsDisplay.layer.cornerRadius = 15
        view.layer.cornerRadius = 15
        
//        NotificationCenter.default.addObserver(self, selector: #selector(showSDS), name: NSNotification.Name(rawValue: "showSDS"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(hideContainer), name: NSNotification.Name(rawValue: "hideContainer"), object: nil)
////        NotificationCenter.default.addObserver(self, selector: #selector(errorHandle), name: NSNotification.Name("errorSplitSDSView"), object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(splitLoading), name: NSNotification.Name(rawValue: "splitLoading"), object: nil)
        
        if (UIDevice.current.userInterfaceIdiom == .pad){
            loadGHSScreen()
        }
        
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
    @objc private func showSDS() {
        spliteSDSShow()
        loadGHSScreen()
    }
    
    @objc private func hideContainer() {
        containerView.isHidden = true
    }
    @objc private func splitLoading() {
        self.showSpinner(onView: self.view)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func loadGHSScreen() {
        print("loaded")
        GHSContainer.isHidden = false
        localDeafultData.sdsNo = localsearchinfo.results[0].synno
        localcurrentSDS.sdsNo = localDeafultData.sdsNo
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startSpin"), object: nil)
        csiWCF_VM().callSDS_FA(sdsno: localDeafultData.sdsNo) { (output) in
            if output.contains("true") {
                DispatchQueue.main.async {
                    csiWCF_VM().callSDS_Trans(sdsno: localDeafultData.sdsNo) { (output) in
                        if output.contains("true") {
                            DispatchQueue.main.async {
                                csiWCF_VM().callSDS_GHS(sdsno: localDeafultData.sdsNo) { (output) in
                                    if output.contains("true") {
                                        DispatchQueue.main.async {

                                            csiWCF_getTransport(clientid: localclientinfo.clientid, uid: localclientinfo.infosafeid, sdsNoGet: localDeafultData.sdsNo, apptp: "1", rtype: "1") { (output) in
                                            if output.sds != nil {
//                                                localViewSDSTIADG.road_unno = output.road_unno
//                                                localViewSDSTIADG.road_dgclass = output.road_dgclass
//                                                localViewSDSTIADG.road_packgrp = output.road_packgrp
//                                                localViewSDSTIADG.road_psn = output.road_psn
//                                                localViewSDSTIADG.road_hazchem = output.road_hazchem
//                                                localViewSDSTIADG.road_subrisks = output.road_subrisks

//                                                print("reached here")
                                                DispatchQueue.main.async {
                                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeSpin"), object: nil)
                                                    let sdsJump = self.storyboard?.instantiateViewController(withIdentifier: "SDSGHSN") as? SDSViewCFGHSN_VC
                                            //        self.navigationController?.pushViewController(sdsJump!, animated: true)
                                                    self.addChild(sdsJump!)
                                                    sdsJump!.view.frame = CGRect(x: 0, y: 0, width: self.GHSContainer.frame.size.width, height: self.GHSContainer.frame.size.height)
                                                    self.GHSContainer.addSubview(sdsJump!.view)

                                                    sdsJump!.didMove(toParent: self)
                                                }

                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }else {
                        print("Something wrong!")
                        }
                    }
                }
                
            }else {
                print("Something wrong!")
            }
            
        }
        

    }
    
    func spliteSDSShow() {
//        print("reach spliteSDSShow()")
//        self.showSpinner(onView: self.view)
        
        let pdfArray = CoreDataManager.fetchPDF(targetText: localcurrentSDS.sdsNo)
        
        if pdfArray.count != 0 {
            DispatchQueue.main.async {
                
//                print("\(pdfArray[0].sdsno!)")
                let decodeData = Data(base64Encoded: pdfArray[0].pdfdata!, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
                self.sdsDisplay!.load(decodeData!, mimeType: "application/pdf", characterEncodingName: "UTF-8", baseURL: URL(fileURLWithPath: ""))
                localcurrentSDS.pdfData = decodeData
                
                self.splitPrintBtn.isHidden = false
                self.splitShareBtn.isHidden = false
                
                self.ciBtn.isHidden = false
                self.cfBtn.isHidden = false
                self.faBtn.isHidden = false
                self.tiBtn.isHidden = false
                self.viewSDSBtn.isHidden = false
                
                self.vsLbl.isHidden = false
                self.ciLbl.isHidden = false
                self.cfLbl.isHidden = false
                self.faLbl.isHidden = false
                self.tiLbl.isHidden = false
//                self.removeSpinner()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeSpin"), object: nil)
            }
        } else {
            
            let rtype : String = "1"
            csiWCF_VM().callSDS(sdsno: localcurrentSDS.sdsNo, rtype : rtype) { (completionReturnData) in
                DispatchQueue.main.async {
                    
                    if rtype == "1" {
                        //PDF return string must be base64string
                        let decodeData = Data(base64Encoded: completionReturnData, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
                        self.sdsDisplay!.load(decodeData!, mimeType: "application/pdf", characterEncodingName: "UTF-8", baseURL: URL(fileURLWithPath: ""))
                        localcurrentSDS.pdfData = decodeData
                        
//                        CoreDataManager.storePDF(sdsno: localcurrentSDS.sdsNo, pdfdata: completionReturnData)
                        
                        self.splitPrintBtn.isHidden = false
                        self.splitShareBtn.isHidden = false
                        
                        self.ciBtn.isHidden = false
                        self.cfBtn.isHidden = false
                        self.faBtn.isHidden = false
                        self.tiBtn.isHidden = false
                        self.viewSDSBtn.isHidden = false
                        
                        self.vsLbl.isHidden = false
                        self.ciLbl.isHidden = false
                        self.cfLbl.isHidden = false
                        self.faLbl.isHidden = false
                        self.tiLbl.isHidden = false
//                        self.removeSpinner()
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeSpin"), object: nil)
                    }
                    else if rtype == "2" {
                        self.sdsDisplay!.loadHTMLString(String(describing: completionReturnData), baseURL: nil)
                        
                        self.splitPrintBtn.isHidden = false
                        self.splitShareBtn.isHidden = false
                        
                        self.ciBtn.isHidden = false
                        self.cfBtn.isHidden = false
                        self.faBtn.isHidden = false
                        self.tiBtn.isHidden = false
                        self.viewSDSBtn.isHidden = false
                        
                        self.vsLbl.isHidden = false
                        self.ciLbl.isHidden = false
                        self.cfLbl.isHidden = false
                        self.faLbl.isHidden = false
                        self.tiLbl.isHidden = false
//                        self.removeSpinner()
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeSpin"), object: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func viewSDSBtnTapped(_ sender: Any) {
//        if localcurrentSDS.sdsNo != nil {
////            self.spliteSDSShow()
//            let sdsJump = storyboard?.instantiateViewController(withIdentifier: "SDSCore") as? SDSViewCore_VC
//            self.navigationController?.pushViewController(sdsJump!, animated: true)
//        } else {
//            showAlert(title: "Select product.", message: "Please select product first!")
//        }
        
        containerView.isHidden = false
        
        let sdsJump = storyboard?.instantiateViewController(withIdentifier: "SDSCore") as? SDSViewCore_VC

        addChild(sdsJump!)
        sdsJump!.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
        containerView.addSubview(sdsJump!.view)

        sdsJump!.didMove(toParent: self)
    }
    
    @IBAction func cfBtnTapped(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startSpin"), object: nil)
        containerView.isHidden = false

        csiWCF_VM().callSDS_GHS(sdsno: localcurrentSDS.sdsNo) { (output) in
            if output.contains("true") {
                DispatchQueue.main.async {
                    if (localViewSDSGHS.formatcode == "0F" || localViewSDSGHS.formatcode == "0A") {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeSpin"), object: nil)
                        let sdsJump = self.storyboard?.instantiateViewController(withIdentifier: "SDSGHSN") as? SDSViewCFGHSN_VC
//                        self.navigationController?.pushViewController(sdsJump!, animated: true)
                        
                        self.addChild(sdsJump!)
                        sdsJump!.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
                        self.containerView.addSubview(sdsJump!.view)

                        sdsJump!.didMove(toParent: self)
                    } else {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeSpin"), object: nil)
                        let sdsJump = self.storyboard?.instantiateViewController(withIdentifier: "SDSCF") as? SDSViewCF_VC
//                        self.navigationController?.pushViewController(sdsJump!, animated: true)
                        
                        self.addChild(sdsJump!)
                        sdsJump!.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
                        self.containerView.addSubview(sdsJump!.view)
                    }
                }
            }
        }
    }
    
    
    @IBAction func faBtnTapped(_ sender: Any) {
        containerView.isHidden = false
        
        let sdsJump = storyboard?.instantiateViewController(withIdentifier: "SDSFA") as? SDSViewFA_VC
//        self.navigationController?.pushViewController(sdsJump!, animated: true)
        addChild(sdsJump!)
        sdsJump!.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
        containerView.addSubview(sdsJump!.view)

        sdsJump!.didMove(toParent: self)
    }
    
    @IBAction func tiBtnTapped(_ sender: Any) {
        
        containerView.isHidden = false
        let sdsJump = storyboard?.instantiateViewController(withIdentifier: "SDSTI") as? SDSViewTI_VC
//         self.navigationController?.pushViewController(sdsJump!, animated: true)
        
        addChild(sdsJump!)
        sdsJump!.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
        containerView.addSubview(sdsJump!.view)

        sdsJump!.didMove(toParent: self)
    }
    
    @IBAction func vsBtnTapped(_ sender: Any) {
        
        containerView.isHidden = true
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
