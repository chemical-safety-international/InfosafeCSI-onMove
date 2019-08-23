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
    
    fileprivate var productItemArray = [localSearchData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.searchFunction()
//        CoreDataManager.cleanCoreData()
        self.updateData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func updateData() {
        productItemArray = CoreDataManager.fetchObj()
    }
    
    func searchFunction() {
        
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
        if count == 0 {
            csiWCF_VM().callSearch(inputData: searchInPut) { (completionReturnData) in
                if completionReturnData == true {
                    DispatchQueue.main.async {
                        self.removeSpinner()
//                        let searchJump = self.storyboard?.instantiateViewController(withIdentifier: "TablePage") as? SearchTablePage_VC
//                        self.navigationController?.pushViewController(searchJump!, animated: true)
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
        guard !searchText.isEmpty else {
            productItemArray = CoreDataManager.fetchObj()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            return
        }
        
        productItemArray = CoreDataManager.fetchObj(targetText: searchText)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
    
}
