//
//  MultipleLoginPage_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 13/11/20.
//  Copyright © 2020 Chemical Safety International. All rights reserved.
//

import UIKit

class OTACODEPage_VC: UIViewController {

    @IBOutlet weak var otacodeTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        localclientinfo.otacode = ""
        loginButton.layer.cornerRadius = 18
        setNavigationbar()
        hideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.isHidden = false

    }
    
    func setNavigationbar() {
        //change background color
//            //change background color & back button color
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.barTintColor = UIColor(red:0.25, green:0.26, blue:0.26, alpha:1.0)
            self.navigationController?.navigationBar.tintColor = UIColor.white

//            //change navigation bar text color and font
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 23), .foregroundColor: UIColor.white]
            self.navigationItem.title = "OTA Code"
               
    
    }
    
    func sendOTACode() {
        var otacode: String!
        
        otacode = otacodeTextField.text
        self.showSpinner(onView: self.view)
        localclientinfo.otacode = otacode
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        
        localclientinfo.clientList.removeAll()
        
        csiWCF_VM().callLoginWithOTACODE(email: locallogininfo.email, password: "", session: session, otacode: otacode) { (completion) in
            
            //here dataResponse received from a network request
            do {
                //here dataResponse received from a network request
                let decoder = JSONDecoder()
                let model = try decoder.decode(outLoginData.self, from:
                    completion) //Decode JSON Response Data
//                print(model)
                localclientinfo.clientid = model.clientid
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
                            
 
                let result = try JSONDecoder().decode(outLoginMultiClient.self, from: completion)

                if result.relatedclients?.count ?? [].count > 0 {
                    let clientArray = result.relatedclients
                    
                    for i in clientArray! {
                        var clientList = clientListItem()
                        clientList.clientname = i.clientname
                        clientList.clientid = i.clientid
                        localclientinfo.clientList.append(clientList)
                    }
                }

                
                
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
                        if localclientinfo.retIndexNo.contains("E") {
                            self.showAlert(title: "Verify Failed", message: localclientinfo.retIndexText)
                        } else if localclientinfo.retIndexText.contains("Multiple Client") && localclientinfo.needchooseclient == true {
                            let loginJump = self.storyboard?.instantiateViewController(withIdentifier: "ClientSelect") as? ClientSelect_VC
                            self.navigationController?.pushViewController(loginJump!, animated: true)
                        }

                    } else if localclientinfo.retIndexText.contains("Blank Password") {
                        
                        let loginJump = self.storyboard?.instantiateViewController(withIdentifier: "LoginPage") as? LoginPage_VC
                        self.navigationController?.pushViewController(loginJump!, animated: true)
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
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(disKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    //Notify to disKeyboard
    @objc func disKeyboard() {
        otacodeTextField.endEditing(true)
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        sendOTACode()
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

}


extension OTACODEPage_VC : URLSessionDelegate {
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
       //Trust the certificate even if not valid
       let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)

       completionHandler(.useCredential, urlCredential)
    }
}

extension OTACODEPage_VC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == otacodeTextField {
            textField.resignFirstResponder()
            sendOTACode()
            return false
        }
        return true
    }
}
