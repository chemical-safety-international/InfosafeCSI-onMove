//
//  ClientSelect_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 26/10/20.
//  Copyright © 2020 Chemical Safety International. All rights reserved.
//

import UIKit

class ClientSelect_VC: UIViewController {

    @IBOutlet weak var clientListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        getClientList()
//        checkTableViewRowsFit()
        setNavigationbar()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(jumpToSearchPage), name: NSNotification.Name("jumpToSearchPage"), object: nil)
        clientListTableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.isHidden = false

    }
    
//    func checkTableViewRowsFit() {
////        clientListTableView.sizeToFit()
//        if (clientListTableView.contentSize.height < clientListTableView.frame.size.height - 40) {
//            clientListTableView.isScrollEnabled = false;
//         }
//        else {
//            clientListTableView.isScrollEnabled = true;
//         }
//    }

    func setNavigationbar() {
        //change background color
//            //change background color & back button color
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.barTintColor = UIColor(red:0.25, green:0.26, blue:0.26, alpha:1.0)
            self.navigationController?.navigationBar.tintColor = UIColor.white

//            //change navigation bar text color and font
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 23), .foregroundColor: UIColor.white]
            self.navigationItem.title = "Select a Company"
               
    
    }
    
    @objc func jumpToSearchPage() {

        let searchPage = storyboard?.instantiateViewController(withIdentifier: "SearchSelection") as? SearchSelection_VC
        self.navigationController?.pushViewController(searchPage!, animated: true)
        
    }

}

extension ClientSelect_VC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localclientinfo.clientList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "clientListCell", for: indexPath) as? ClientListTableViewCell

        cell?.clientNameLabel.layer.cornerRadius = 8
        cell?.clientNameLabel.layer.borderWidth = 0.5
        cell?.clientNameLabel.layer.borderColor = UIColor.white.cgColor
        //cell?.clientNameLabel.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.9)
        cell?.clientNameLabel.backgroundColor = UIColor(red:0.25, green:0.26, blue:0.26, alpha:1.0).withAlphaComponent(0.5)

        
        if localclientinfo.clientList.isEmpty == false {
            cell?.clientNameLabel.text = localclientinfo.clientList[indexPath.row].clientname
        } else {
            
        }
        
//        cell?.clientNameLabel.sizeToFit()
        return cell!
    }
    
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        localclientinfo.clientid = localclientinfo.clientList[indexPath.row].clientid
        localclientinfo.appointedclient = localclientinfo.clientList[indexPath.row].clientid
        
        let email = locallogininfo.email
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)

//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "jumpToSearchPage"), object: nil)
        self.showSpinner(onView: self.view)
        var otacode: String!
        print(localclientinfo.otacode)
        if (localclientinfo.otacode.isEmpty == false) {
            otacode = localclientinfo.otacode
        } else {
            otacode = ""
        }
        csiWCF_VM().callLoginWithOTACODE(email: email!, password: "", session: session, otacode: otacode) { (completion) in
            
            //here dataResponse received from a network request
            do {
                //here dataResponse received from a network request
                let decoder = JSONDecoder()
                let model = try decoder.decode(outLoginData.self, from:
                    completion) //Decode JSON Response Data
//                print(model)
                
//                localclientinfo.clientid = model.clientid
                localclientinfo.clientmemberid = model.clientmemberid
                localclientinfo.infosafeid = model.infosafeid
                localclientinfo.clientcode = model.clientcode
                localclientinfo.clientlogo = model.clientlogo
                localclientinfo.apptype = model.apptype
//                localclientinfo.errorno = model.errorno
//                localclientinfo.error = model.error
                localclientinfo.retIndexNo = model.retIndexNo
                localclientinfo.retIndexText = model.retIndexText
                localclientinfo.needchooseclient = model.needchooseclient

//                localclientinfo.appointedclient = model.appointedclient
                
//                let result = try JSONDecoder().decode(outLoginMultiClient.self, from: completion)

//                let clientArray = result.relatedclients
//
//                for i in clientArray {
//                    var clientList = clientListItem()
//                    clientList.clientname = i.clientname
//                    clientList.clientid = i.clientid
//                    localclientinfo.clientList.append(clientList)
//                }
                            
                DispatchQueue.main.async {
                    if model.passed == true {
                        self.removeSpinner()

                        if localclientinfo.needchooseclient == true {
                            let loginJump = self.storyboard?.instantiateViewController(withIdentifier: "ClientSelect") as? ClientSelect_VC
                            self.navigationController?.pushViewController(loginJump!, animated: true)
                        } else {
                            
                            let loginJump = self.storyboard?.instantiateViewController(withIdentifier: "SearchPage") as? SearchPage_VC
                            self.navigationController?.pushViewController(loginJump!, animated: true)
                        }
                    } else if model.passed == false {
                        
                        self.removeSpinner()
                        if model.isgeneric == false {
//                            self.checkNonGenericErrorType(errorno: localclientinfo.errorno)
                            if localclientinfo.retIndexText.contains("Blank Password") {
                                
                                locallogininfo.email = email
                                localclientinfo.clientlogo = ""
                                
                                csiWCF_VM().callGetClientLogo(clientID: localclientinfo.appointedclient, session: session) { (completion) in
                                    do {
      
                                        let decoder = JSONDecoder()
                                        let model = try decoder.decode(logoData.self, from:
                                            completion) //Decode JSON Response Data
                        //                print(model)

                                        localclientinfo.clientlogo = model.clientlogo
                                        
                                        let loginJump = self.storyboard?.instantiateViewController(withIdentifier: "LoginPage") as? LoginPage_VC
                                        self.navigationController?.pushViewController(loginJump!, animated: true)
                                        
                                    } catch let parsingError {
                                        print("Error", parsingError)
                                    }
                                }
//                                let loginJump = self.storyboard?.instantiateViewController(withIdentifier: "LoginPage") as? LoginPage_VC
//                                self.navigationController?.pushViewController(loginJump!, animated: true)
                            } else if localclientinfo.retIndexText.contains("Multiple Client") && localclientinfo.needchooseclient == true {
                                let loginJump = self.storyboard?.instantiateViewController(withIdentifier: "ClientSelect") as? ClientSelect_VC
                                self.navigationController?.pushViewController(loginJump!, animated: true)
                            } else if localclientinfo.retIndexNo.contains("E") {
                                self.showAlert(title: "Verify Failed", message: localclientinfo.retIndexText)
                            }
                        } else if model.isgeneric == true {
//                            self.checkGenericErrorType(errorno: localclientinfo.errorno)
                            if localclientinfo.retIndexText.contains("OTA Code Sent") {
                                        let loginJump = self.storyboard?.instantiateViewController(withIdentifier: "OTACODEPage") as? OTACODEPage_VC
                                        self.navigationController?.pushViewController(loginJump!, animated: true)
                            } else if localclientinfo.retIndexNo.contains("E") {
                                self.showAlert(title: "Verify Failed", message: localclientinfo.retIndexText)
                            }
                            
                        } else {
                            self.removeSpinner()
                            self.showAlert(title: "Verify Failed", message: "Email is invaild, please try again.")
                        }
                        
                    } else {
                        self.removeSpinner()
                        self.showAlert(title: "Failed", message: "Server is no response.")
                    }
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
    }
}

extension ClientSelect_VC : URLSessionDelegate {
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
       //Trust the certificate even if not valid
       let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)

       completionHandler(.useCredential, urlCredential)
    }
}
