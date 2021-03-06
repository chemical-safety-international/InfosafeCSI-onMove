//
//  Menu_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 12/6/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

class SDSMenu_VC: UIViewController {
    
    
//    var buttonName = [" ", "Core Info.", "Classification", "First Aid", "Transport", "View SDS"]
//    var buttonImage = ["menu-close-cross", "CSI-Core", "CSI-Class", "CSI-Aid", "CSI-Transport", "CSI-ViewSDS"]
    
    var buttonName = ["View SDS", "Core Info.", "Classification", "First Aid", "Transport"]
    var buttonImage = ["CSI-ViewSDS", "CSI-Core", "CSI-Class", "CSI-Aid", "CSI-Transport"]
    
//    var buttonName = ["View SDS"]
//    var buttonImage = ["CSI-ViewSDS"]
    
    var timerForShowScrollIndicator: Timer?

    @IBOutlet weak var menuTable: UITableView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var menuView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuView.layer.cornerRadius = 10
        menuView.backgroundColor = UIColor.init(red: 0.10, green: 0.10, blue: 0.10, alpha: 0.7)
        
        self.menuTable.delegate = self
        self.menuTable.dataSource = self
        
        //remove the line between each cell
        menuTable.separatorStyle = .none
        self.view.backgroundColor = UIColor.clear
        
        //change menu table indicator color
        menuTable.indicatorStyle = UIScrollView.IndicatorStyle.white

        // Do any additional setup after loading the view.
        menuTable.reloadData()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }


    override func viewDidAppear(_ animated: Bool) {
        startTimerForShowScrollIndicator()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        stopTimerForShowScrollIndicator()
    }
    
    @objc func showScrollIndicatorsInContacts() {
        UIView.animate(withDuration: 0.001) {
            self.menuTable.flashScrollIndicators()
        }
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let verticalIndicator = scrollView.subviews.last as? UIImageView
//        verticalIndicator?.backgroundColor = UIColor.white
//    }
    
    func startTimerForShowScrollIndicator() {
        self.timerForShowScrollIndicator = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.showScrollIndicatorsInContacts), userInfo: nil, repeats: true)
    }
    
    func stopTimerForShowScrollIndicator() {
        self.timerForShowScrollIndicator?.invalidate()
        self.timerForShowScrollIndicator = nil
    }
    
    
    
    func menuFunction(index: Int) {
        if buttonName[index] == "View SDS" {
 
            let sdsJump = storyboard?.instantiateViewController(withIdentifier: "SDSView") as? SDSViewPage_VC
            self.navigationController?.pushViewController(sdsJump!, animated: true)
        }
        
        if buttonName[index] == "Core Info." {
//            csiWCF_getCoreInfo(clientid: localclientinfo.clientid, uid: localclientinfo.infosafeid, sdsNoGet: localcurrentSDS.sdsNo, apptp: "1", rtype: "1") { (output) in
//                print(output)
//            }

            let sdsJump = storyboard?.instantiateViewController(withIdentifier: "SDSCore") as? SDSViewCore_VC
            self.navigationController?.pushViewController(sdsJump!, animated: true)

        }
        

        if buttonName[index] == "Classification" {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startSpin"), object: nil)

            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
            csiWCF_VM().callSDS_GHS(sdsno: localcurrentSDS.sdsNo, session: session) { (output) in
                if output.contains("true") {
                    DispatchQueue.main.async {
                        
                        if (localViewSDSGHS.formatcode == "0F" || localViewSDSGHS.formatcode == "0A") {
                            
                            csiWCF_getTransport(clientid: localclientinfo.clientid, uid: localclientinfo.infosafeid, sdsNoGet: localcurrentSDS.sdsNo, apptp: "1", rtype: "1") { (output) in
                            if output.sds != nil {
                                localViewSDSTIADG.road_unno = output.road_unno
                                localViewSDSTIADG.road_dgclass = output.road_dgclass
                                localViewSDSTIADG.road_packgrp = output.road_packgrp
                                localViewSDSTIADG.road_psn = output.road_psn
                                localViewSDSTIADG.road_hazchem = output.road_hazchem
                                
                                DispatchQueue.main.async {
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeSpin"), object: nil)
                                    let sdsJump = self.storyboard?.instantiateViewController(withIdentifier: "SDSGHSN") as? SDSViewCFGHSN_VC
                                    self.navigationController?.pushViewController(sdsJump!, animated: true)
                                }

                                }
                            }
//                            csiWCF_VM().callSDS_Trans() { (output)}

                        } else {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeSpin"), object: nil)
                            let sdsJump = self.storyboard?.instantiateViewController(withIdentifier: "SDSCF") as? SDSViewCF_VC
                            self.navigationController?.pushViewController(sdsJump!, animated: true)
                        }
                    }
                }
            }
        }
        
        if buttonName[index] == "First Aid" {
            
            let sdsJump = storyboard?.instantiateViewController(withIdentifier: "SDSFA") as? SDSViewFA_VC
            self.navigationController?.pushViewController(sdsJump!, animated: true)
        }
        
        if buttonName[index] == "Transport" {
//            csiWCF_VM()
            
            let sdsJump = storyboard?.instantiateViewController(withIdentifier: "SDSTI") as? SDSViewTI_VC
             self.navigationController?.pushViewController(sdsJump!, animated: true)
            
        }
    
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil)
    }
    
}


extension SDSMenu_VC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return buttonName.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as? MenuTableViewCell
        
        cell?.btnLbl.text = buttonName[indexPath.row]
        cell?.btnImg.image = UIImage(named: buttonImage[indexPath.row])
        cell?.btnLbl.textColor = UIColor.white
        cell?.backgroundColor = UIColor.clear

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        menuFunction(index: indexPath.row)
    }
    
    func tableScrollDisable() {
        menuTable.isScrollEnabled = false
    }
    func tableScrollEnable() {
        menuTable.isScrollEnabled = true
    }
    
}

extension SDSMenu_VC : URLSessionDelegate {
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
       //Trust the certificate even if not valid
       let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)

       completionHandler(.useCredential, urlCredential)
    }
}
