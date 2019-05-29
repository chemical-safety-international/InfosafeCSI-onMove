//
//  SearchPage_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 9/5/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

class SearchPage_VC: UIViewController, UISearchBarDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{

    

    //IBOutlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cPickView: UITextField!
    @IBOutlet weak var thePicker: UIPickerView!
    @IBOutlet weak var pickerBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.callCriteriaList()
        // Do any additional setup after loading the view.
        self.searchBar.delegate = self
        thePicker.isHidden = true
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.cPickView.endEditing(true)
        thePicker.isHidden = true
        dropArrow()
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        //create empty arrays
        let searchInPut = searchBar.text!
        localsearchinfo.arrCompanyName = []
        localsearchinfo.arrDetail = []
        localsearchinfo.arrNo = []
        
        localcriteriainfo.searchValue = searchInPut
        
        let client = localclientinfo.clientid
        let uid = localclientinfo.infosafeid
        let c = localcriteriainfo.code
        let p = 1
        let psize = 50
        let apptp = localclientinfo.apptype
        
        
        //call search function
        self.showSpinner(onView: self.view)
        csiWCF_VM().callSearch(inputData: searchInPut, client: client!, uid: uid!, c: c!, p: p, psize:psize, apptp:apptp!) { (completionReturnData) in
            
//            var resultData: localsearchinfo!
//
//            resultData.results[0].sdsno = ""
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: completionReturnData, options: []) as? [String: AnyObject]
                
                //print(jsonResponse!)
                
                if let jsonArr1 = jsonResponse!["data"] as? [[String: Any]] {
                    
                    jsonArr1.forEach { info in
//                        if let prodname = info["name"] as? [String: Any] {
//                            prodname.forEach { pn in
//                                if pn.key == "value" {
//                                    localsearchinfo.arrProductName.append(pn.value as! String)
//                                }
//
//                            }
//                        }
                        if let comname = info["com"] as? [String: Any] {
                            comname.forEach { cn in
                                if cn.key == "value" {
                                    localsearchinfo.arrCompanyName.append(cn.value as! String)
                                }
                                
                            }
                            
                        }
                        
                        if let no = info["no"] as? [String: Any] {
                            no.forEach { nocode in
                                    if nocode.key == "value"
                                    {
                                        localsearchinfo.arrNo.append(nocode.value as! String)
                                    }
                                }
                        }
                        
                        
                    }
                    
                }
//                print(localsearchinfo.arrProductName!)
//                print(localsearchinfo.arrCompanyName!)
                
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
            
            
            //handle true or false for search function
            DispatchQueue.main.async {
                if localsearchinfo.arrNo != [] {

                    self.removeSpinner()
                    let searchJump = self.storyboard?.instantiateViewController(withIdentifier: "TablePage") as? TablePage_VC
                    self.navigationController?.pushViewController(searchJump!, animated: true)

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
    
    

    
    
    func callCriteriaList() {
        csiWCF_VM().callCriteriaList() { (completionReturnData) in
            DispatchQueue.main.async {
                if completionReturnData.contains("true") {
                    self.cPickView.text = localcriteriainfo.arrName[0]
                    self.thePicker.reloadAllComponents()
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
    // setup picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return localcriteriainfo.arrName.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.view.endEditing(true)
        self.cPickView.text = localcriteriainfo.arrName[row]
        localcriteriainfo.code = localcriteriainfo.arrCode[row]
        localcriteriainfo.pickerValue = localcriteriainfo.arrName[row]
        dropArrow()
        self.thePicker.isHidden = true

        
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
        if textField == self.cPickView {
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
    
    func dropArrow() {
        let image = UIImage(named: "drop arrow")
        self.pickerBtn.setImage(image, for: .normal)
    }
    
    func upArrow() {
        let image = UIImage(named: "up arrow")
        self.pickerBtn.setImage(image, for: .normal)
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
    
}

