//
//  SearchPage_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 9/5/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

class SearchPage_VC: UIViewController, UISearchBarDelegate {

    //IBOutlet
    @IBOutlet weak var criteriaListTable: UITableView!
    @IBOutlet weak var criteriaListBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.callCriteriaList()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        self.criteriaListTable.delegate = self
        self.criteriaListTable.dataSource = self
        self.searchBar.delegate = self
        criteriaListTable.isHidden = true
        scrollView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func loadList(notification: NSNotification) {
        DispatchQueue.main.async {
            self.criteriaListTable.reloadData()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        guard let firstSub = searchBar.subviews.first else {return}
        firstSub.subviews.forEach{
            ($0 as? UITextField)?.clearButtonMode = .never
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = ""
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        //create empty arrays
        let searchInPut = searchBar.text!
        localsearchinfo.arrCompanyName = []
        localsearchinfo.arrDetail = []
        localsearchinfo.arrNo = []
        
        let client = localclientinfo.clientid
        let uid = localclientinfo.infosafeid
        let c = localcriteriainfo.code
        let p = 1
        let psize = 50
        let apptp = localclientinfo.apptype
        
        
        //call search function
        self.showSpinner(onView: self.view)
        csiWCF_VM().callSearch(inputData: searchInPut, client: client!, uid: uid!, c: c!, p: p, psize:psize, apptp:apptp!) { (completionReturnData) in
            
            //handle true or false for search function
            DispatchQueue.main.async {
                if completionReturnData.contains("true") {
                    
                    self.removeSpinner()
                    let searchJump = self.storyboard?.instantiateViewController(withIdentifier: "TablePage") as? TablePage_VC
                    self.navigationController?.pushViewController(searchJump!, animated: true)
                    
                } else if completionReturnData.contains("false") {
                    self.removeSpinner()
                    let ac = UIAlertController(title: "Search Failed", message: "Please check the network and type the correct infomation search again.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style:  .default))
                    self.present(ac, animated: true)
                }  else if completionReturnData.contains("Error") {
                    self.removeSpinner()
                    let ac = UIAlertController(title: "Failed", message: "Server is no response.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style:  .default))
                    self.present(ac, animated: true)
                }
            }
        }
    }
    
    
    @IBAction func criteriaListBtnTapped(_ sender: Any) {
        if criteriaListTable.isHidden {
            animate(toogle: true)
        } else {
            animate(toogle: false)
        }

    }
    
    func animate(toogle: Bool) {
        if toogle {
            UIView.animate(withDuration: 0.3) {
                self.criteriaListTable.isHidden = false
                self.scrollView.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.criteriaListTable.isHidden = true
                self.scrollView.isHidden = true
            }
        }
    }
    
    func callCriteriaList() {
        csiWCF_VM().callCriteriaList() { (completionReturnData) in
            DispatchQueue.main.async {
                if completionReturnData.contains("true") {
                    self.criteriaListBtn.setTitle("\(localcriteriainfo.arrName[0])", for: .normal)
                } else if completionReturnData.contains("false") {
                    let ac = UIAlertController(title: "Failed", message: "Cannot get the criteria list!", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style:  .default))
                    self.present(ac, animated: true)
                }  else if completionReturnData.contains("Error") {
                    let ac = UIAlertController(title: "Failed", message: "Cannot get the criteria list!", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style:  .default))
                    self.present(ac, animated: true)
                }
            }
        }
    }
    
}


extension SearchPage_VC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localcriteriainfo.arrCode.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "criteriacell", for: indexPath)
        cell.textLabel?.text = localcriteriainfo.arrName[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        criteriaListBtn.setTitle("\(localcriteriainfo.arrName[indexPath.row])", for: .normal)
        localcriteriainfo.code = localcriteriainfo.arrCode[indexPath.row]
        print(localcriteriainfo.arrName[indexPath.row])
        print(localcriteriainfo.arrCode[indexPath.row])
        animate(toogle: false)
    }
}
