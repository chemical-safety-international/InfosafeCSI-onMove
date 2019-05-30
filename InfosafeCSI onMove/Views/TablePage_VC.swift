//
//  TablePage_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 10/5/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

class TablePage_VC: UIViewController, UISearchBarDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    

    @IBOutlet weak var tableDisplay: UITableView!
    
    
    @IBOutlet weak var pickerTextField: UITextField!
    @IBOutlet weak var thePicker: UIPickerView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    var selectedIndex:Bool = false;
    var select = -1
    var rowNo = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        self.tableDisplay.delegate = self
        self.tableDisplay.dataSource = self
        tableDisplay.rowHeight = UITableView.automaticDimension
//        tableDisplay.estimatedRowHeight = 100
        thePicker.isHidden = true
        
        pickerTextField.text = localcriteriainfo.pickerValue
        searchBar.text = localcriteriainfo.searchValue
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        thePicker.isHidden = true
        pickerTextField.endEditing(true)

    }
    
    @objc func loadList(notification: NSNotification) {
        DispatchQueue.main.async {
            self.tableDisplay.reloadData()
        }
    }
    

    
    @IBAction func sdsViewBtnTapped(_ sender: UIButton) {
        
        //get row number
        let buttonRow = sender.tag
        
        let sdsJump = storyboard?.instantiateViewController(withIdentifier: "SDSView") as? SDSView_VC
    
        //csicurrentSDS.sdsNo = csiclientsearchinfo.arrNo[rowNo]
        localcurrentSDS.sdsNo = localsearchinfo.arrNo[buttonRow]
        
        self.navigationController?.pushViewController(sdsJump!, animated: true)
    }
    
    // search bar editing
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return localcriteriainfo.arrName.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickerTextField.text = localcriteriainfo.arrName[row]
        localcriteriainfo.code = localcriteriainfo.arrCode[row]
        pickerTextField.endEditing(true)
        self.thePicker.isHidden = true
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        return localcriteriainfo.arrName[row]
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.pickerTextField {
            self.thePicker.isHidden = false
            textField.endEditing(true)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

         localsearchinfo.arrProductName = []
         localsearchinfo.arrCompanyName = []
         localsearchinfo.arrIssueDate = []
         localsearchinfo.arrDetail = []
         localsearchinfo.arrNo = []
        //create empty arrays
        let searchInPut = searchBar.text!
        
        let client = localclientinfo.clientid
        let uid = localclientinfo.infosafeid
        let c = localcriteriainfo.code
        let p = 1
        let psize = 50
        let apptp = localclientinfo.apptype
        
//        localsearchinfo.init(pcount: <#T##Int?#>, ocount: <#T##Int?#>, lcount: <#T##Int?#>, pageno: <#T##Int?#>, item: <#T##[localsearchinfo.item]?#>)
//        localsearchinfo.resutls = []
        
        //call search function
        self.showSpinner(onView: self.view)
        csiWCF_VM().callSearch(inputData: searchInPut, client: client!, uid: uid!, c: c!, p: p, psize:psize, apptp:apptp!) { (completionReturnData) in
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: completionReturnData, options: []) as? [String: AnyObject]
                
                print(jsonResponse!)
                
                var localresult = localsearchinfo.init()
            
                
                if let jsonArr1 = jsonResponse!["data"] as? [[String: Any]] {
                    
                    jsonArr1.forEach { info in
                        
                        var ritem = localsearchinfo.item()
                        var ritemuf = localsearchinfo.uf()
                   
                        
                        if let prodname = info["name"] as? [String: Any] {
                            localsearchinfo.arrProductName.append(prodname["value"] as! String)
//                            localsearchinfo.resutls[0].sdsno.append(prodname["value"] as! String)
                            ritem.prodname = prodname["value"] as? String
                        }
                        if let comname = info["com"] as? [String: Any] {
                            localsearchinfo.arrCompanyName.append(comname["value"] as! String)
                            ritem.company = comname["value"] as? String
                        }
                        
                        if let no = info["no"] as? [String: Any] {
                            localsearchinfo.arrNo.append(no["value"] as! String)
                            ritem.sdsno = no["value"] as? String
                        }
                        if let issueData = info["issue"] as? [String: Any] {
                            localsearchinfo.arrIssueDate.append(issueData["value"] as! String)
                            ritem.issueDate = issueData["value"] as? Date
                        }
                        //hanlde user field
                        //ritem.ufs.append(ritemuf)
                        localresult.results.append(ritem)
                    }
                    print(localresult.results.count)
                    print(localresult.results[0].company)
                }
                
                //                if let jsonArr2 = jsonResponse!["no"] as? [String: Any] {
                //                    jsonArr2.forEach { sdsno in
                //                        localsearchinfo.item.init(sdsno: sdsno.value as! String)
                //
                //                    }
                //
                //                }
                
                
                
            } catch let parsingError {
                print("Error", parsingError)
            }
//            print("Result: \(localsearchinfo.resutls[0])")
            
            //handle true or false for search function
            DispatchQueue.main.async {
                if localsearchinfo.arrNo != [] {
                    
                    self.removeSpinner()
                    self.tableDisplay.reloadData()
                    
                } else if localsearchinfo.arrNo == [] {
                    self.removeSpinner()
                    let ac = UIAlertController(title: "Search Failed", message: "Please check the network and type the correct infomation search again.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style:  .default))
                    self.present(ac, animated: true)
                }  else {
                    self.removeSpinner()
                    let ac = UIAlertController(title: "Failed", message: "Server is no response.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style:  .default))
                    self.present(ac, animated: true)
                }
            }
        }
    }
    @IBAction func pickerBtnTapped(_ sender: Any) {
        if thePicker.isHidden == false {
            self.thePicker.isHidden = true
        } else if thePicker.isHidden == true {
            self.thePicker.isHidden = false
        }
    }
    
}







extension TablePage_VC: UITableViewDelegate, UITableViewDataSource {
    // non-expandable
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localsearchinfo.arrCompanyName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell
        //csiclientsearchinfo.details = ("Issue date: \(csiclientsearchinfo.arrIssueDate[indexPath.row]) \n SDS No.: \(csiclientsearchinfo.arrNo[indexPath.row])")
        localsearchinfo.details = ("SDS No.: \(localsearchinfo.arrNo[indexPath.row]) \nCompany Name: \(localsearchinfo.arrCompanyName[indexPath.row]) \nIssue Date: \(localsearchinfo.arrIssueDate[indexPath.row])")
        
        cell?.name.text = localsearchinfo.arrProductName[indexPath.row]
        cell?.details.text = localsearchinfo.details
        
        //set row number of button that inside cell when tap
        cell?.sdsBtn.tag = indexPath.row
        cell?.sdsBtn.addTarget(self, action: #selector(sdsViewBtnTapped(_:)), for: .touchUpInside)
        

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.view.endEditing(true)
        
        rowNo = indexPath.row
        
        localcurrentSDS.sdsNo = localsearchinfo.arrNo[rowNo]
        let sdsJump = storyboard?.instantiateViewController(withIdentifier: "SDSView") as? SDSView_VC
        self.navigationController?.pushViewController(sdsJump!, animated: true)
    }
    
    // change the height to expand tableDisplay value
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
        
    }
    
    // swipe to delete the row function
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            localsearchinfo.arrCompanyName.remove(at: indexPath.row)
            localsearchinfo.arrIssueDate.remove(at: indexPath.row)
            localsearchinfo.arrNo.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
}
