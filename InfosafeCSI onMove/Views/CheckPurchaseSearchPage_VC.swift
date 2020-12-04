//
//  CheckPurchaseSearchPage_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 23/11/20.
//  Copyright © 2020 Chemical Safety International. All rights reserved.
//

import UIKit

class CheckPurchaseSearchPage_VC: UIViewController {
    
    @IBOutlet weak var productNameSearchbar: UISearchBar!
    @IBOutlet weak var productCodeSearchbar: UISearchBar!
    @IBOutlet weak var barcodeSearchbar: UISearchBar!
    
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.hideKeyboard()
        self.setNavigationbar()
        self.setSearchbars()
        self.callCriteria()
        
        localsearchinfo.cpage = 1
        localsearchinfo.psize = 50
    }
    
    func setSearchbars() {
        
        
        //product name searchbar
        productNameSearchbar.set(textColor: .black)
        //searchbar text field color
        productNameSearchbar.setTextField(color: UIColor.white)
        productNameSearchbar.setPlaceholder(textColor: .black)
        productNameSearchbar.setSearchImage(color: .black)
        //camera button setup
        productNameSearchbar.showsBookmarkButton = true
        productNameSearchbar.setImage(UIImage.init(systemName: "camera"), for: .bookmark, state: .normal)
        
        //product code searchbar
        productCodeSearchbar.set(textColor: .black)
        //searchbar text field color
        productCodeSearchbar.setTextField(color: UIColor.white)
        productCodeSearchbar.setPlaceholder(textColor: .black)
        productCodeSearchbar.setSearchImage(color: .black)
        
        //barcode searchbar
        barcodeSearchbar.set(textColor: .black)
        //newCriteria text field color
        barcodeSearchbar.setTextField(color: UIColor.white)
        barcodeSearchbar.setPlaceholder(textColor: .black)
        barcodeSearchbar.setSearchImage(color: .black)
        //camera button setup
        barcodeSearchbar.showsBookmarkButton = true
        barcodeSearchbar.setImage(UIImage.init(systemName: "camera"), for: .bookmark, state: .normal)
    }
    
    func setNavigationbar() {
        //change background color
//        DispatchQueue.main.async {
//
//            //change background color & back button color
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.barTintColor = UIColor(red:0.25, green:0.26, blue:0.26, alpha:1.0)
            self.navigationController?.navigationBar.tintColor = UIColor.white

//            //change navigation bar text color and font
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 23), .foregroundColor: UIColor.white]
            self.navigationItem.title = "Check Before You Purchase"
               
            
//        }
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
    
        if searchBar == barcodeSearchbar {
            let searchJump = self.storyboard?.instantiateViewController(withIdentifier: "ScannerPage") as? Scanner_VC
            self.navigationController?.pushViewController(searchJump!, animated: true)
        } else if searchBar == productNameSearchbar {
            
            let searchJump = self.storyboard?.instantiateViewController(withIdentifier: "OCRScannerPage") as? OCR_VC
            self.navigationController?.pushViewController(searchJump!, animated: true)
        }
        
    }
    
    func searchData() {
        productNameSearchbar.text = productNameSearchbar.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        productCodeSearchbar.text = productCodeSearchbar.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        barcodeSearchbar.text = barcodeSearchbar.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if productNameSearchbar.text!.isEmpty && productCodeSearchbar.text!.isEmpty && barcodeSearchbar.text!.isEmpty {
            
            self.removeSpinner()
            productNameSearchbar.text = ""
            productCodeSearchbar.text = ""
            barcodeSearchbar.text = ""
            
            self.showAlert(title:"", message: "Search content is empty.")
            
        } else if productNameSearchbar.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" && productCodeSearchbar.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" && barcodeSearchbar.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
            self.removeSpinner()
            productNameSearchbar.text = ""
            productCodeSearchbar.text = ""
            barcodeSearchbar.text = ""
            
            self.showAlert(title: "", message: "Search content is empty.")
            
        } else if productNameSearchbar.text!.count < 3 && productNameSearchbar.text!.isEmpty == false {
            
            self.removeSpinner()
            self.showAlert(title: "", message: "Please enter more than 2 characters for product name!")
        
        } else {
            
            self.showSpinner(onView: self.view)
            
            let searchInPut = productNameSearchbar.text!
            let pCodeSeatchInput = productCodeSearchbar.text!
            let barcodeSearchInput = barcodeSearchbar.text!
            
            localcriteriainfo.searchValue = searchInPut
            localcriteriainfo.pcodeSearchValue = pCodeSeatchInput
            localcriteriainfo.barcodeSearchValue = barcodeSearchInput
            
            
            localsearchinfo.results = []
            localsearchinfo.cpage = 1
            
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
            
            csiWCF_VM().callSearch(pnameInputData: searchInPut, supInputData: "", pcodeInputData: pCodeSeatchInput, barcode: barcodeSearchInput, session: session) { (completionReturnData) in
                if completionReturnData == true {
                    DispatchQueue.main.async {
                        self.removeSpinner()
                        let searchJump = self.storyboard?.instantiateViewController(withIdentifier: "CollectionTablePage") as? CheckpurchaseSearchMainPage_VC
                        self.navigationController?.pushViewController(searchJump!, animated: true)
                    }
                } else {
                    DispatchQueue.main.async {
                        if (self.view.bounds.height <= 320) {
//                            print(self.view.bounds.height)
                                self.removeSpinner()
                                self.showAlert(title: "", message: "No Search Result Found.")
                        } else {
//                           print(self.view.bounds.height)
                            self.removeSpinner()

                            self.showAlert(title: "", message: "No Search Result Found.")
                        }
                    }
                }
            }
            
        }
        
        
    }
    
    func callCriteria() {
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        csiWCF_VM().callCriteriaList(session: session) { (completionReturnData) in
            DispatchQueue.main.async {
                if completionReturnData.contains("true") {
                    localcriteriainfo.pickerValue = localcriteriainfo.arrName[0]

                } else if completionReturnData.contains("false") {
                    self.showAlert(title: "Failed", message: "Cannot get the criteria list!")
                    self.searchButton.isEnabled = false
                    
                }  else if completionReturnData.contains("Error") {
                    self.showAlert(title: "Failed", message: "Cannot get the criteria list!")
                    self.searchButton.isEnabled = false
                }
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
        productNameSearchbar.endEditing(true)
        productCodeSearchbar.endEditing(true)
        barcodeSearchbar.endEditing(true)
        
    }

    @IBAction func searchButtonTapped(_ sender: Any) {
        self.searchData()
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


extension CheckPurchaseSearchPage_VC : URLSessionDelegate {
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
       //Trust the certificate even if not valid
       let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)

       completionHandler(.useCredential, urlCredential)
    }
}
