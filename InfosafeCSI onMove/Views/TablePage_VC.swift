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
    @IBOutlet weak var pickerBtn: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    
    
    
    var selectedIndex:Bool = false;
    var select = -1
    var rowNo = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        self.tableDisplay.delegate = self
        self.tableDisplay.dataSource = self
        
//        tableDisplay.estimatedRowHeight = 100
        thePicker.isHidden = true
//        tableDisplay.rowHeight = UITableView.automaticDimension
        pickerTextField.text = localcriteriainfo.pickerValue
        searchBar.text = localcriteriainfo.searchValue
        self.hideKeyboardWhenTappedAround()
        self.countLabel.text = localsearchinfo.pdetails
        self.tableDisplay.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.isHidden = true
        tableDisplay.estimatedRowHeight = 145
        tableDisplay.rowHeight = UITableView.automaticDimension
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        self.navigationController?.navigationBar.isHidden = false
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        thePicker.isHidden = true
        pickerTextField.endEditing(true)
        dropArrow()

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
    
        localcurrentSDS.sdsNo = localsearchinfo.results[buttonRow].sdsno
        
        self.navigationController?.pushViewController(sdsJump!, animated: true)
    }
    
    // search bar editing
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        self.view.endEditing(true)
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
        dropArrow()
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        return localcriteriainfo.arrName[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.bold)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = localcriteriainfo.arrName[row]
        return pickerLabel!
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.pickerTextField {
            if self.thePicker.isHidden == false {
                self.thePicker.isHidden = true
                dropArrow()
            } else if thePicker.isHidden == true {
                self.thePicker.isHidden = false
                upArrow()
            }
            
            textField.endEditing(true)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.showSpinner(onView: self.view)
        let searchInPut = searchBar.text!
        
        csiWCF_VM().callSearch(inputData: searchInPut) { (completionReturnData) in
            if completionReturnData == true {
                DispatchQueue.main.async {
                    self.removeSpinner()
                    self.countLabel.text = localsearchinfo.pdetails
                    self.tableDisplay.reloadData()
                }
            } else if completionReturnData == false{
                DispatchQueue.main.async {
                    self.removeSpinner()
                    self.showAlert(title: "Failed", message: "Cannot found the search results.")
                }
            }
            
        }
        
    }
    
    @IBAction func pickerBtnTapped(_ sender: Any) {
        if thePicker.isHidden == false {
            self.thePicker.isHidden = true
            dropArrow()
        } else if thePicker.isHidden == true {
            self.thePicker.isHidden = false
            upArrow()
        }
    }
    
    func dropArrow() {
        let image = UIImage(named: "drop arrow")
        self.pickerBtn.setImage(image, for: .normal)
    }
    
    func upArrow() {
        let image = UIImage(named: "up arrow")
        self.pickerBtn.setImage(image, for: .normal)
    }
    
}


extension TablePage_VC: UITableViewDelegate, UITableViewDataSource {
    // non-expandable
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localsearchinfo.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell

        localsearchinfo.details = ("SDS No.: \(localsearchinfo.results[indexPath.row].sdsno ?? "") \nCompany Name: \(localsearchinfo.results[indexPath.row].company ?? "") \nIssue Date: \( localsearchinfo.results[indexPath.row].issueDate ?? "") \nSynonyms No.: \(localsearchinfo.results[indexPath.row].synno ?? "") \nUNNo: \(localsearchinfo.results[indexPath.row].unno ?? "") \nName Type: \(localsearchinfo.results[indexPath.row].prodtype ?? "")")
        
        cell?.name.text = localsearchinfo.results[indexPath.row].prodname
        cell?.details.text = localsearchinfo.details
        
        //set row number of button that inside cell when tap
        cell?.sdsBtn.tag = indexPath.row
        cell?.sdsBtn.addTarget(self, action: #selector(sdsViewBtnTapped(_:)), for: .touchUpInside)
        

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.view.endEditing(true)
        
        rowNo = indexPath.row
        
        localcurrentSDS.sdsNo = localsearchinfo.results[rowNo].synno
        let sdsJump = storyboard?.instantiateViewController(withIdentifier: "SDSView") as? SDSView_VC
        self.navigationController?.pushViewController(sdsJump!, animated: true)
    }
    
    // change the height to expand tableDisplay value
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 135

    }
    
    // swipe to delete the row function
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            localsearchinfo.results.remove(at: indexPath.row)
//            localsearchinfo.arrIssueDate.remove(at: indexPath.row)
//            localsearchinfo.arrNo.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
}
