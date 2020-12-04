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
    @IBOutlet weak var productNameSearchbar: UISearchBar!
    @IBOutlet weak var searchBtn: UIButton!
    
    @IBOutlet weak var logoffBtn: UIButton!

    
    @IBOutlet weak var supplierSearchbar: UISearchBar!
    @IBOutlet weak var pCodeSearchbar: UISearchBar!

    @IBOutlet weak var noSearchResultLbl: UILabel!
    
    // multi-search test

    @IBOutlet weak var barcodeSearchbar: UISearchBar!
    @IBOutlet weak var multiBtn: UIButton!
    @IBOutlet weak var criteriaCV: UICollectionView!
    @IBOutlet weak var newCriteria2: UISearchBar!
    @IBOutlet weak var newCriteria3: UISearchBar!
    
    @IBOutlet weak var newSBHeight2: NSLayoutConstraint!
    @IBOutlet weak var newSBHeight3: NSLayoutConstraint!
    
    var count = 0
    
    
    // create picker view
    let criPicker = UIPickerView()
    
    var selectedRow: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.removeSpinner()
        //setup no result label
        self.noSearchResultLbl.isHidden = true

        
        
        // load the criteria list for picker
        self.callCriteria()
        
        //button style
        self.logoffBtn.layer.cornerRadius = 5
        self.searchBtn.layer.cornerRadius = 5
        self.cPickView.layer.cornerRadius = 10
        self.multiBtn.layer.cornerRadius = 5
    
        //enable the delegate
        self.cPickView.delegate = self
        self.productNameSearchbar.delegate = self
        

        //setup navigation function
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        
        //setup picker & toolbar
        self.createPicker()
        self.createToolbar()
        
        //setup text field right view
        self.createArrow()
        
        self.hideKeyboard()
        
        localsearchinfo.cpage = 1
        localsearchinfo.psize = 50
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        //revieve the notification from the action
        NotificationCenter.default.addObserver(self, selector: #selector(errorHandle), name: NSNotification.Name("errorSearch"), object: nil)
        
        //get company logo and show in the UIImage
//        if localclientinfo.clientlogo != nil {
//            let comLogo = localclientinfo.clientlogo.toImage()
//            companyLogo.image = comLogo
////            print(comLogo!.size.height)
////            print(comLogo!.size.width)
//        }
        
        self.view.backgroundColor = UIColor(red:0.76, green:0.75, blue:0.75, alpha:1.0)
        setSearchbar()

        //multi-Search test
        cPickView.isHidden = true
        
        criteriaCV.isHidden = true

        newCriteria2.isHidden = true
        newCriteria3.isHidden = true

        newSBHeight2.constant = 0
        newSBHeight3.constant = 0
        

        localcriteriainfo.type2 = ""
        localcriteriainfo.type3 = ""
        
        //disable swipe to back function
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    
    // custom picker view
    func createPicker() {

        criPicker.delegate = self
        criPicker.dataSource = self
        cPickView.inputView = criPicker

        
    }
    
    //custom search bar
    func setSearchbar() {
//        searchbar.placeholder = "Enter"
        productNameSearchbar.set(textColor: .black)
        
        //searchbar text field color
        productNameSearchbar.setTextField(color: UIColor.white)
        
        productNameSearchbar.setPlaceholder(textColor: .black)
        productNameSearchbar.setSearchImage(color: .black)
//        searchbar.setClearButton(color: .red)
        productNameSearchbar.showsBookmarkButton = true
        productNameSearchbar.setImage(UIImage.init(systemName: "camera"), for: .bookmark, state: .normal)
        
        
        supplierSearchbar.set(textColor: .black)
        //searchbar text field color
        supplierSearchbar.setTextField(color: UIColor.white)
        supplierSearchbar.setPlaceholder(textColor: .black)
        supplierSearchbar.setSearchImage(color: .black)
        
        pCodeSearchbar.set(textColor: .black)
        //searchbar text field color
        pCodeSearchbar.setTextField(color: UIColor.white)
        pCodeSearchbar.setPlaceholder(textColor: .black)
        pCodeSearchbar.setSearchImage(color: .black)
        
        barcodeSearchbar.set(textColor: .black)
        //newCriteria text field color
        barcodeSearchbar.setTextField(color: UIColor.white)
        barcodeSearchbar.setPlaceholder(textColor: .black)
        barcodeSearchbar.setSearchImage(color: .black)
        
        barcodeSearchbar.showsBookmarkButton = true
        barcodeSearchbar.setImage(UIImage.init(systemName: "camera"), for: .bookmark, state: .normal)
        
//        barcodeSearchbar.addSubview(barcodeScanButton)
        
        newCriteria2.set(textColor: .black)
        //newCriteria2 text field color
        newCriteria2.setTextField(color: UIColor.white)
        newCriteria2.setPlaceholder(textColor: .black)
        newCriteria2.setSearchImage(color: .black)
        
        newCriteria3.set(textColor: .black)
        //newCriteria3 text field color
        newCriteria3.setTextField(color: UIColor.white)
        newCriteria3.setPlaceholder(textColor: .black)
        newCriteria3.setSearchImage(color: .black)
        
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
    
    
    //add arrow image into pickview
    func createArrow() {
        cPickView.rightViewMode = UITextField.ViewMode.always
        
            // Fallback on earlier versions
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            let image = UIImage(named: "combox-down-arrow")
            imageView.image = image
            cPickView.rightView = imageView

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
    
    //notification function
    @objc private func errorHandle() {
        self.removeSpinner()
        self.showAlert(title: "Connection failure!", message: "Please check the connection and try again!")
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
//        print("search button tapped")
        self.searchData()

    }
    
    func searchData() {
//        print("search Data called")
        productNameSearchbar.text = productNameSearchbar.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        supplierSearchbar.text = supplierSearchbar.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        pCodeSearchbar.text = pCodeSearchbar.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        barcodeSearchbar.text = barcodeSearchbar.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        if productNameSearchbar.text!.isEmpty && supplierSearchbar.text!.isEmpty && pCodeSearchbar.text!.isEmpty && barcodeSearchbar.text!.isEmpty {
            self.removeSpinner()
            productNameSearchbar.text = ""
            supplierSearchbar.text = ""
            pCodeSearchbar.text = ""
            
            self.showAlert(title:"", message: "Search content is empty.")
            
        } else if productNameSearchbar.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" &&  supplierSearchbar.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" && pCodeSearchbar.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" && barcodeSearchbar.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            self.removeSpinner()
            productNameSearchbar.text = ""
            supplierSearchbar.text = ""
            pCodeSearchbar.text = ""
            barcodeSearchbar.text = ""
            self.showAlert(title: "", message: "Search content is empty.")
        } else if productNameSearchbar.text!.count < 3 && productNameSearchbar.text!.isEmpty == false {
            self.removeSpinner()
            self.showAlert(title: "", message: "Please enter more than 2 characters for product name!")
        
        } else if supplierSearchbar.text!.count < 2 && supplierSearchbar.text!.isEmpty == false {
            self.removeSpinner()
            self.showAlert(title: "", message: "Please enter more than 1 characters for supplier!")
            
        } else {
//            print("Called call search")
            self.cPickView.endEditing(true)
            self.showSpinner(onView: self.view)
            
            let searchInPut = productNameSearchbar.text!
            let supplierSearchInput = supplierSearchbar.text!
            let pCodeSeatchInput = pCodeSearchbar.text!
            let barcodeSearchInput = barcodeSearchbar.text!
            
            localcriteriainfo.searchValue = searchInPut
            localcriteriainfo.supSearchValue = supplierSearchInput
            localcriteriainfo.pcodeSearchValue = pCodeSeatchInput
            localcriteriainfo.barcodeSearchValue = barcodeSearchInput
            
            
            
            
            if (newCriteria2.isHidden == false) {
                localcriteriainfo.value2 = newCriteria2.text!
            }
            
            if (newCriteria3.isHidden == false) {
                localcriteriainfo.value3 = newCriteria3.text!
            }
            
            
            noSearchResultLbl.isHidden = true
            
            localsearchinfo.results = []
            localsearchinfo.cpage = 1
            
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
            
            csiWCF_VM().callSearch(pnameInputData: searchInPut, supInputData: supplierSearchInput, pcodeInputData: pCodeSeatchInput, barcode: barcodeSearchInput, session: session) { (completionReturnData) in
                if completionReturnData == true {
                    DispatchQueue.main.async {
                        self.removeSpinner()
                        let searchJump = self.storyboard?.instantiateViewController(withIdentifier: "TablePage") as? SearchTablePage_VC
                        self.navigationController?.pushViewController(searchJump!, animated: true)
                    }
                } else {
                    DispatchQueue.main.async {
                        if (self.view.bounds.height <= 320) {
//                            print(self.view.bounds.height)
                                self.removeSpinner()
                                self.showAlert(title: "", message: "No Search Result Found.")
                        } else {
//                            print(self.view.bounds.height)
                                self.removeSpinner()
                                self.noSearchResultLbl.isHidden = false
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
                    self.cPickView.text = localcriteriainfo.arrName[0]
                    localcriteriainfo.pickerValue = localcriteriainfo.arrName[0]
                    self.criteriaCV.reloadData()

                } else if completionReturnData.contains("false") {
                    self.showAlert(title: "Failed", message: "Cannot get the criteria list!")
                    
                }  else if completionReturnData.contains("Error") {
                    self.showAlert(title: "Failed", message: "Cannot get the criteria list!")
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
        supplierSearchbar.endEditing(true)
        pCodeSearchbar.endEditing(true)
        barcodeSearchbar.endEditing(true)
        newCriteria2.endEditing(true)
        newCriteria3.endEditing(true)
    }
    
    @IBAction func multiSearchBtn(_ sender: Any) {
        
        if (cPickView.isHidden == true) {
//           criteriaCV.isHidden = false
            cPickView.isHidden = false
            multiBtn.setTitle(" Cancel ", for: .normal)
        } else {
//            criteriaCV.isHidden = true
            cPickView.isHidden = true
            multiBtn.setTitle(" Multi-Search ", for: .normal)
            count = 0
            
            newCriteria2.isHidden = true
            newCriteria3.isHidden = true

            newSBHeight2.constant = 0
            newSBHeight3.constant = 0
            
            
            localcriteriainfo.type2 = ""
            localcriteriainfo.value2 = ""
            newCriteria2.text = ""
            
            localcriteriainfo.type3 = ""
            localcriteriainfo.value3 = ""
            newCriteria3.text = ""
        }
        
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
   // control cancel showing in the search bar
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        searchbar.resignFirstResponder()
//        searchbar.setShowsCancelButton(false, animated: true)
//        self.view.endEditing(true)
//        self.searchBtn.isHidden = false
//    }
//
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searchbar.setShowsCancelButton(true, animated: true)
//        guard let firstSub = searchbar.subviews.first else {return}
//        firstSub.subviews.forEach{
//            ($0 as? UITextField)?.clearButtonMode = .never
//        }
//        self.searchBtn.isHidden = true
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchbar.setShowsCancelButton(false, animated: true)
//        searchbar.text = ""
//        searchbar.endEditing(true)
//        self.searchBtn.isHidden = false
//    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        productNameSearchbar.resignFirstResponder()
//        print("search bar return pressed")
        self.searchData()
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

        self.cPickView.text = "Add more criterias"
        
//        self.cPickView.text = localcriteriainfo.arrName[row]
        selectedRow = row
        localcriteriainfo.code = localcriteriainfo.arrCode[row]
        localcriteriainfo.pickerValue = localcriteriainfo.arrName[row]
        
        // updating the attribute of selected row
        criPicker.reloadAllComponents()
        
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
        
        if count == 1 {
            newCriteria2.isHidden = false
            newCriteria2.placeholder = localcriteriainfo.arrName[selectedRow]
            localcriteriainfo.type2 = localcriteriainfo.arrCode[selectedRow]
            newSBHeight2.constant = 56
            count += 1
        } else if count == 2 {
            newCriteria3.isHidden = false
            newCriteria3.placeholder = localcriteriainfo.arrName[selectedRow]
            localcriteriainfo.type3 = localcriteriainfo.arrCode[selectedRow]
            newSBHeight3.constant = 56
            count += 1
        }

    }
    
    @objc func cancelPick() {
        
        self.cPickView.text = localcriteriainfo.arrName[0]
        selectedRow = 0
        localcriteriainfo.code = localcriteriainfo.arrCode[0]
        self.criPicker.selectRow(0, inComponent: 0, animated: false)
        self.cPickView.resignFirstResponder()
    }
    
}

extension UISearchBar {

    func getTextField() -> UITextField? { return value(forKey: "searchField") as? UITextField }
    func set(textColor: UIColor) { if let textField = getTextField() { textField.textColor = textColor } }
    func setPlaceholder(textColor: UIColor) { getTextField()?.setPlaceholder(textColor: textColor) }
    func setClearButton(color: UIColor) { getTextField()?.setClearButton(color: color) }

    func setTextField(color: UIColor) {
        guard let textField = getTextField() else { return }
        switch searchBarStyle {
        case .minimal:
            textField.layer.backgroundColor = color.cgColor
            textField.layer.cornerRadius = 6
        case .prominent, .default: textField.backgroundColor = color
        @unknown default: break
        }
    }

    func setSearchImage(color: UIColor) {
        guard let imageView = getTextField()?.leftView as? UIImageView else { return }
        imageView.tintColor = color
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
    }
}

private extension UITextField {

    private class Label: UILabel {
        private var _textColor = UIColor.lightGray
        override var textColor: UIColor! {
            set { super.textColor = _textColor }
            get { return _textColor }
        }

        init(label: UILabel, textColor: UIColor = .lightGray) {
            _textColor = textColor
            super.init(frame: label.frame)
            self.text = label.text
            self.font = label.font
        }

        required init?(coder: NSCoder) { super.init(coder: coder) }
    }


    private class ClearButtonImage {
        static private var _image: UIImage?
        static private var semaphore = DispatchSemaphore(value: 1)
        static func getImage(closure: @escaping (UIImage?)->()) {
            DispatchQueue.global(qos: .userInteractive).async {
                semaphore.wait()
                DispatchQueue.main.async {
                    if let image = _image { closure(image); semaphore.signal(); return }
                    guard let window = UIApplication.shared.windows.first else { semaphore.signal(); return }
                    let searchBar = UISearchBar(frame: CGRect(x: 0, y: -200, width: UIScreen.main.bounds.width, height: 44))
                    window.rootViewController?.view.addSubview(searchBar)
                    searchBar.text = "txt"
                    searchBar.layoutIfNeeded()
                    _image = searchBar.getTextField()?.getClearButton()?.image(for: .normal)
                    closure(_image)
                    searchBar.removeFromSuperview()
                    semaphore.signal()
                }
            }
        }
    }

    func setClearButton(color: UIColor) {
        ClearButtonImage.getImage { [weak self] image in
            guard   let image = image,
                let button = self?.getClearButton() else { return }
            button.imageView?.tintColor = color
            button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }

    var placeholderLabel: UILabel? { return value(forKey: "placeholderLabel") as? UILabel }

    func setPlaceholder(textColor: UIColor) {
        guard let placeholderLabel = placeholderLabel else { return }
        let label = Label(label: placeholderLabel, textColor: textColor)
        setValue(label, forKey: "placeholderLabel")
    }

    func getClearButton() -> UIButton? { return value(forKey: "clearButton") as? UIButton }
}




extension SearchPage_VC: UICollectionViewDelegate, UICollectionViewDataSource {
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return localcriteriainfo.arrName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = criteriaCV.dequeueReusableCell(withReuseIdentifier: "mscell", for: indexPath) as? MultiSearchCell
        
//        print(localcriteriainfo.arrName[indexPath.row])
        cell?.criteriaLbl.text = localcriteriainfo.arrName[indexPath.row]
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        
        if count == 1 {
            newCriteria2.isHidden = false
            newCriteria2.placeholder = localcriteriainfo.arrName[indexPath.row]
            localcriteriainfo.type2 = localcriteriainfo.arrCode[indexPath.row]
            newSBHeight2.constant = 56
            count += 1
        } else if count == 2 {
            newCriteria3.isHidden = false
            newCriteria3.placeholder = localcriteriainfo.arrName[indexPath.row]
            localcriteriainfo.type3 = localcriteriainfo.arrCode[indexPath.row]
            newSBHeight3.constant = 56
            count += 1
        }
        
    }
    
    
    
}

extension SearchPage_VC : URLSessionDelegate {
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
       //Trust the certificate even if not valid
       let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)

       completionHandler(.useCredential, urlCredential)
    }
}
