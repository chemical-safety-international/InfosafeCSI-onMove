//
//  MultiLoginPage_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 16/12/20.
//  Copyright © 2020 Chemical Safety International. All rights reserved.
//

import UIKit

class MultiLoginPage_VC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var countineButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        countineButton.layer.cornerRadius = 18
        self.navigationItem.title = "Email Check"
        hideKeyboard()
        getRemeberedEmail()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.isHidden = true

    }
    
    func remeberEmail() {
        if emailTextField.text?.isEmpty == false {
            let defaults = UserDefaults.standard
            defaults.set(emailTextField.text!, forKey: localclientcoreData.username)
        }
    }
    
    func getRemeberedEmail() {
        let defaults = UserDefaults.standard
        let remeberedEmail = defaults.string(forKey: localclientcoreData.username)
        if remeberedEmail?.isEmpty == false {
            
            emailTextField.text = remeberedEmail
        }
    }
    

    func emailCheck() {
        var email: String!
        
        email = emailTextField.text
        self.showSpinner(onView: self.view)
        locallogininfo.email = email
        localclientinfo.appointedclient = ""

            //only use for untrust website
//        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        
        let session = URLSession(configuration: .default)
        
        csiWCF_VM().callLoginWithOTACODE(email: email, password: "", session: session, otacode: "") { (completion) in
            
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
                if model.clientlogo == nil {
                    localclientinfo.clientlogo = ""
                } else {
                    localclientinfo.clientlogo = model.clientlogo
                }
                localclientinfo.clientlogo = model.clientlogo
                localclientinfo.apptype = model.apptype
//                localclientinfo.errorno = model.errorno
//                localclientinfo.error = model.error
                localclientinfo.retIndexNo = model.retIndexNo
                localclientinfo.retIndexText = model.retIndexText
                localclientinfo.needchooseclient = model.needchooseclient
                if model.needchooseclient == true {
                    localclientinfo.appointedclient = ""
                    localclientinfo.otacode = ""
                }
                
                
                let result = try JSONDecoder().decode(outLoginMultiClient.self, from: completion)
                localclientinfo.clientList.removeAll()
                
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

                        if localclientinfo.needchooseclient == true && model.isgeneric == true{
                            self.remeberEmail()
                            
                            let defaults = UserDefaults.standard
                            let otaremeberedEmail = defaults.string(forKey: "OTAEmail")
                            if (otaremeberedEmail == self.emailTextField.text) {
                                localclientinfo.otacode = defaults.string(forKey: "OTACode")
//                                print(localclientinfo.otacode ?? "")
                            }
                            
                            let loginJump = self.storyboard?.instantiateViewController(withIdentifier: "ClientSelect") as? ClientSelect_VC
                            self.navigationController?.pushViewController(loginJump!, animated: true)
                        } else if localclientinfo.needchooseclient == true && model.isgeneric == false{
                            self.remeberEmail()
                            let loginJump = self.storyboard?.instantiateViewController(withIdentifier: "SearchPage") as? SearchPage_VC
                            self.navigationController?.pushViewController(loginJump!, animated: true)
                        } else {
                            self.remeberEmail()
                            let loginJump = self.storyboard?.instantiateViewController(withIdentifier: "SearchPage") as? SearchPage_VC
                            self.navigationController?.pushViewController(loginJump!, animated: true)
                        }
                    } else if model.passed == false {
                        
                        self.removeSpinner()
                        if model.isgeneric == false {
//                            self.checkNonGenericErrorType(errorno: localclientinfo.errorno)
                            if localclientinfo.retIndexText.contains("Blank Password") {
                                self.remeberEmail()
                                locallogininfo.email = email
                                let loginJump = self.storyboard?.instantiateViewController(withIdentifier: "LoginPage") as? LoginPage_VC
                                self.navigationController?.pushViewController(loginJump!, animated: true)
                            } else if localclientinfo.retIndexNo.contains("A10002") && localclientinfo.needchooseclient == true {
                                self.remeberEmail()
                                let loginJump = self.storyboard?.instantiateViewController(withIdentifier: "ClientSelect") as? ClientSelect_VC
                                self.navigationController?.pushViewController(loginJump!, animated: true)
                            }  else if localclientinfo.retIndexNo.contains("A10001") {
                                self.remeberEmail()
                                        let loginJump = self.storyboard?.instantiateViewController(withIdentifier: "OTACODEPage") as? OTACODEPage_VC
                                        self.navigationController?.pushViewController(loginJump!, animated: true)
                            } else if localclientinfo.retIndexNo.contains("E") {
                                self.showAlert(title: "Verify Failed", message: localclientinfo.retIndexText)
                            }
                            
                        } else if model.isgeneric == true {
//                            self.checkGenericErrorType(errorno: localclientinfo.errorno)
                            if localclientinfo.needchooseclient == true {
                                self.remeberEmail()
                                
                                let defaults = UserDefaults.standard
                                let otaremeberedEmail = defaults.string(forKey: "OTAEmail\(self.emailTextField.text ?? "")")
                                if (otaremeberedEmail == self.emailTextField.text) {
                                    localclientinfo.otacode = defaults.string(forKey: "OTACode")

                                }
//                                print(otaremeberedEmail)
//                                print(self.emailTextField.text)
//                                print(localclientinfo.otacode)
                                
                                let loginJump = self.storyboard?.instantiateViewController(withIdentifier: "ClientSelect") as? ClientSelect_VC
                                self.navigationController?.pushViewController(loginJump!, animated: true)

                            } else if localclientinfo.retIndexNo.contains("A10001") {
                                self.remeberEmail()
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
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(disKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    //Notify to disKeyboard
    @objc func disKeyboard() {
        emailTextField.endEditing(true)
    }

    @IBAction func continueButtonTapped(_ sender: Any) {
        emailCheck()
    }
    
}

//only use for untrust website
//extension MultiLoginPage_VC : URLSessionDelegate {
//    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//       //Trust the certificate even if not valid
//       let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
//
//       completionHandler(.useCredential, urlCredential)
//    }
//}

extension MultiLoginPage_VC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            textField.resignFirstResponder()
            emailCheck()
            return false
        }
        return true
    }
}
