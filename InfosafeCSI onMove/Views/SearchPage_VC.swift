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
    @IBOutlet weak var cPickView: UITextField!
    @IBOutlet weak var thePicker: UIPickerView!
    @IBOutlet weak var pickerBtn: UIButton!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var searchBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.callCriteriaList()
        // Do any additional setup after loading the view.
        self.searchbar.delegate = self
        thePicker.isHidden = true
        self.hideKeyboardWhenTappedAround()
        thePicker.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
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
        self.searchBtn.isHidden = false
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchbar.resignFirstResponder()
        searchbar.setShowsCancelButton(false, animated: true)
        self.view.endEditing(true)
        self.searchBtn.isHidden = false
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchbar.setShowsCancelButton(true, animated: true)
        guard let firstSub = searchbar.subviews.first else {return}
        firstSub.subviews.forEach{
            ($0 as? UITextField)?.clearButtonMode = .never
        }
        self.searchBtn.isHidden = true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchbar.setShowsCancelButton(false, animated: true)
        searchbar.text = ""
        searchbar.endEditing(true)
        self.searchBtn.isHidden = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchbar.resignFirstResponder()
        searchFunction()
    }
    @IBAction func searchBtnTapped(_ sender: Any) {
        searchFunction()
    }
    
    func searchFunction() {
        self.showSpinner(onView: self.view)
        let searchInPut = searchbar.text!
        localcriteriainfo.searchValue = searchInPut
        
        csiWCF_VM().callSearch(inputData: searchInPut) { (completionReturnData) in
            if completionReturnData == true {
                DispatchQueue.main.async {
                    self.removeSpinner()
                    let searchJump = self.storyboard?.instantiateViewController(withIdentifier: "TablePage") as? TablePage_VC
                    self.navigationController?.pushViewController(searchJump!, animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    self.removeSpinner()
                    self.showAlert(title: "Failed", message: "Cannot found the search results.")
                }
            }
            
        }
    }
    

    
    
    func callCriteriaList() {
        csiWCF_VM().callCriteriaList() { (completionReturnData) in
            DispatchQueue.main.async {
                if completionReturnData.contains("true") {
                    self.cPickView.text = localcriteriainfo.arrName[0]
                    localcriteriainfo.pickerValue = localcriteriainfo.arrName[0]
                    self.thePicker.reloadAllComponents()
                } else if completionReturnData.contains("false") {
                    self.showAlert(title: "Failed", message: "Cannot get the criteria list!")
                    
                }  else if completionReturnData.contains("Error") {
                    self.showAlert(title: "Failed", message: "Cannot get the criteria list!")
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
            self.view.endEditing(true)
        }

    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.view.endEditing(true)
//        self.cPickView.resignFirstResponder()
//        return false
//    }
    
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

