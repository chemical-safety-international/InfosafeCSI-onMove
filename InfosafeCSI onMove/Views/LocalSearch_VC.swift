//
//  LocalSearch_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 21/8/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

class LocalSearch_VC: UIViewController {
    var count = 0

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cleanSearchDataBtn: UIButton!

    
    @IBOutlet weak var sizeLbl: UILabel!

    
    fileprivate var productItemArray = [localSearchData]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.localSearch()
//        CoreDataManager.cleanCoreData()
        self.updateData()
//        self.addPDFCopies()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }


    func updateData() {
        productItemArray = CoreDataManager.fetchObj()
        
        let text = "Total records: \(productItemArray.count)"
//        print(text)
    }

    func localSearch() {
//        print("local search function called")
//        if searchbar.text!.isEmpty {
//            self.removeSpinner()
//            self.showAlert(title: "Failed", message: "Search content empty.")
//
//        } else {
//            self.cPickView.endEditing(true)
//            self.showSpinner(onView: self.view)
//            let searchInPut = searchbar.text!
//            localcriteriainfo.searchValue = searchInPut
//
//            noSearchResultLbl.isHidden = true

            localsearchinfo.results = []
            localsearchinfo.cpage = 1

        let searchInPut = ""
        let supSearchInput = ""
        let pcodeSearchInput = ""
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        
        if count == 0 {
            csiWCF_VM().callSearch(pnameInputData: searchInPut, supInputData: supSearchInput, pcodeInputData: pcodeSearchInput, barcode: "", session: session) { (completionReturnData) in
                if completionReturnData == true {
                    DispatchQueue.main.async {
                        self.removeSpinner()

                        self.updateData()
                    }
                } else {
                    DispatchQueue.main.async {
                        if (self.view.bounds.height <= 320) {
                            //                            print(self.view.bounds.height)
                            self.removeSpinner()
                            self.showAlert(title: "", message: "No Search Result Find.")
                        } else {
                            //                            print(self.view.bounds.height)
                            self.removeSpinner()
                            //                            self.noSearchResultLbl.isHidden = false
                        }
                    }
                }
            }
            count = 1
        } else {
            print("Already stored in core data")
        }

    }
    
    @IBAction func searchBtnTapped(_ sender: Any) {
        let searchText = searchBar.text
//        print(searchText!)
//        guard searchText!.isEmpty else {
//            productItemArray = CoreDataManager.fetchObj()
//            
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//            return
//        }
//        
        productItemArray = CoreDataManager.fetchObj(targetText: searchText)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func cleanBtnTapped(_ sender: Any) {
        DispatchQueue.main.async {
//            CoreDataManager.cleanTempData()
            CoreDataManager.cleanSearchCoreData()
        }
        
    }
    
    @IBAction func sizeBtnTapped(_ sender: Any) {
        CoreDataManager.appSize()
    }
    
    func addPDFCopies() {
        let pdfA = CoreDataManager.fetchPDF(targetText: localcurrentSDS.sdsNo)
        
        if pdfA.count != 0 {
            DispatchQueue.main.async {
                
//                print("\(pdfA[0].sdsno!)")
//                let decodeData = Data(base64Encoded: pdfA[0].pdfdata!, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
        
                for index in 1...10000 {
                    print(index)
                    CoreDataManager.storePDFTest(sdsno: String(index), pdfdata: pdfA[0].pdfdata!)
                }
            }
        }
    }

}

extension LocalSearch_VC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productItemArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "localcell", for: indexPath) as? LocalTableViewCell

        let prodItem = productItemArray[indexPath.row]

        cell?.prodname.text = "PN: \(prodItem.prodname!)"
        cell?.prodcode.text = " \(prodItem.prodcode!)"
        cell?.company.text = " \(prodItem.company!)"
        cell?.dgclass.text = " \(prodItem.dgclass!)"
        cell?.unno.text = " \(prodItem.unno!)"
        cell?.ps.text = " \(prodItem.ps!)"
        cell?.issuedate.text = " \(prodItem.issueDate!)"
        cell?.haz.text = " \(prodItem.haz!)"
//        cell?.prodname.text = "Product name: \(prodItem.prodname!)"

        return cell!
    }
}

extension LocalSearch_VC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        guard !searchText.isEmpty else {
//            productItemArray = CoreDataManager.fetchObj()
//
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//            return
//        }
//
//        productItemArray = CoreDataManager.fetchObj(targetText: searchText)
//
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }

}

extension LocalSearch_VC : URLSessionDelegate {
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
       //Trust the certificate even if not valid
       let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)

       completionHandler(.useCredential, urlCredential)
    }
}
