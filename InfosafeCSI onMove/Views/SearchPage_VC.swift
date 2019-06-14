//
//  SearchPage_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 9/5/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

class SearchPage_VC: UIViewController {

    

    //IBOutlet
    @IBOutlet weak var cPickView: UITextField!
    @IBOutlet weak var pickerBtn: UIButton!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var searchBtn: UIButton!
    
    @IBOutlet weak var logoffBtn: UIButton!
    
    // create picker view
    let criPicker = UIPickerView()
    
    var selectedRow: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load the criteria list for picker
        self.callCriteriaList()
        
        //button style
        logoffBtn.layer.cornerRadius = 5
        searchBtn.layer.cornerRadius = 5
        pickerBtn.layer.cornerRadius = 10
        cPickView.layer.cornerRadius = 10
        
        // change textfield height
        var frame = self.cPickView.frame
        frame.size.height = 35
        self.cPickView.frame = frame
        self.cPickView.delegate = self
        
        
        
        self.searchbar.delegate = self
    
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        
        //setup picker & toolbar
        createPicker()
        createToolbar()
        
        hideKeyboard()
        
        localsearchinfo.cpage = 1
        localsearchinfo.psize = 50
        
    }
    
    // custom picker view
    func createPicker() {

        criPicker.delegate = self
        criPicker.dataSource = self
        cPickView.inputView = criPicker

        
    }
    
    //create & custom tool bar for picker view
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPick))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        cPickView.inputAccessoryView = toolBar
    }
    
    // disable swipe to go back
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    //hide the navigation bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    @IBAction func searchBtnTapped(_ sender: Any) {
        searchFunction()
    }
    
    func searchFunction() {
        self.showSpinner(onView: self.view)
        let searchInPut = searchbar.text!
        localcriteriainfo.searchValue = searchInPut
        
        localsearchinfo.results = []
        
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

                } else if completionReturnData.contains("false") {
                    self.showAlert(title: "Failed", message: "Cannot get the criteria list!")
                    
                }  else if completionReturnData.contains("Error") {
                    self.showAlert(title: "Failed", message: "Cannot get the criteria list!")
                }
            }
        }
    }
    
//    func dropArrow() {
//        let image = UIImage(named: "combox-down-arrow")
//        self.pickerBtn.setImage(image, for: .normal)
//    }
//
//    func upArrow() {
//        let image = UIImage(named: "combox-up-arrow")
//        self.pickerBtn.setImage(image, for: .normal)
//    }
    
    @IBAction func pickerBtnTapped(_ sender: Any) {
//        if thePicker.isHidden == false {
//            self.thePicker.isHidden = true
//            dropArrow()
//
//
//        } else if thePicker.isHidden == true {
//            self.thePicker.isHidden = false
//            upArrow()
//
//        }
    }
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(disKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func disKeyboard() {
        searchbar.endEditing(true)
    }
    
}


extension SearchPage_VC: UITextFieldDelegate {
    // disable user to copy or paste in the text field
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
}


extension SearchPage_VC: UISearchBarDelegate {
    
    //Search bar setup

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
}


extension SearchPage_VC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // setup picker
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return localcriteriainfo.arrName.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        self.cPickView.text = localcriteriainfo.arrName[row]
        selectedRow = row
        localcriteriainfo.code = localcriteriainfo.arrCode[row]
        localcriteriainfo.pickerValue = localcriteriainfo.arrName[row]
        
        // updating the attribute of selected row
        criPicker.reloadAllComponents()
        
//        dropArrow()
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return localcriteriainfo.arrName[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()

            pickerLabel?.textAlignment = .center
            
            // custom the text of selected row
            if row == selectedRow {
                pickerLabel?.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.bold)
            } else {
                pickerLabel?.font = UIFont.systemFont(ofSize: 20)
            }
            
        }

        pickerLabel?.text = localcriteriainfo.arrName[row]
        return pickerLabel!
        

    }
    
    @objc func donePick() {
        
        self.cPickView.text = localcriteriainfo.arrName[selectedRow]
        localcriteriainfo.code = localcriteriainfo.arrCode[selectedRow]
        localcriteriainfo.pickerValue = localcriteriainfo.arrName[selectedRow]
        self.cPickView.resignFirstResponder()

    }
    
    @objc func cancelPick() {
        
        self.cPickView.text = localcriteriainfo.arrName[0]
        selectedRow = 0
        localcriteriainfo.code = localcriteriainfo.arrCode[0]
        self.criPicker.selectRow(0, inComponent: 0, animated: false)
        self.cPickView.resignFirstResponder()
    }
    
}

