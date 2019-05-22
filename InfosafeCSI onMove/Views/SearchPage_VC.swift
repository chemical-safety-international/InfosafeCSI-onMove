//
//  SearchPage_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 9/5/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

class SearchPage_VC: UIViewController {

    var loginDataSet:(String,String,String) = ("","","")
    //IBOutlet
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var criteriaListTable: UITableView!
    @IBOutlet weak var criteriaListBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.callCriteriaList()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        self.criteriaListTable.delegate = self
        self.criteriaListTable.dataSource = self
        criteriaListTable.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func loadList(notification: NSNotification) {
        DispatchQueue.main.async {
            self.criteriaListTable.reloadData()
        }
    }

    @IBAction func searchBtnTapped(_ sender: Any) {
        
        //create empty arrays
        let searchInPut = searchTextField.text!
        csiclientsearchinfo.arrName = []
        csiclientsearchinfo.arrDetail = []
        csiclientsearchinfo.arrNo = []
        
        //call search function
        self.showSpinner(onView: self.view)
        csiWCF_VM().callSearch(clientid: csiclientinfo.clientid, infosafeid: csiclientinfo.infosafeid, inputData: searchInPut) { (completionReturnData) in
            
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
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.criteriaListTable.isHidden = true
            }
        }
    }
    
    func callCriteriaList() {
        csiWCF_VM().callCriteriaList() { (completionReturnData) in
            DispatchQueue.main.async {
                if completionReturnData.contains("true") {

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
        return csicriteriainfo.arrCode.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "criteriacell", for: indexPath)
        cell.textLabel?.text = csicriteriainfo.arrName[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        criteriaListBtn.setTitle("\(csicriteriainfo.arrName[indexPath.row])", for: .normal)
        csicriteriainfo.code = csicriteriainfo.arrCode[indexPath.row]
        print(csicriteriainfo.arrName[indexPath.row])
        print(csicriteriainfo.arrCode[indexPath.row])
        animate(toogle: false)
    }
    
    
    
    
}
