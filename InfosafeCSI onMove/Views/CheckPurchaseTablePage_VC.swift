//
//  CheckBuyTablePage_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 17/11/20.
//  Copyright © 2020 Chemical Safety International. All rights reserved.
//

import UIKit

class CheckPurchaseTablePage_VC: UIViewController, UISearchBarDelegate {

    var supplierArray = [String]()
    var tableData = [String: Int]()
    var tableDataValue = checkPurchaseSearchSupplierData()
    var checkPurchaseSearchSupplierDataArray: [checkPurchaseSearchSupplierData] = []
    var issueDateArray = [String]()
    var issueDateValueArray = [String]()
    var sdsDataArray = [String]()
    var supplierFullDataValue = checkPurchaseSupplierData()
    var supplierFullData = [checkPurchaseSupplierData]()
    var sortedsupplierFullData = [checkPurchaseSupplierData]()
    
    var checkPurchaseSearchSupplierFilterdData:[checkPurchaseSupplierData] = []
    
    var settingBool: Bool = false
    var sortingBy: String = "Supplier"
    
    var defaultSegmentNumber: Int = 0
    var currentSegmentNumber: Int = 0
    
    @IBOutlet weak var supplierTableView: UITableView!
    @IBOutlet weak var loadmoreLabel: UILabel!
    
    @IBOutlet weak var searchSupplierSearchBar: UISearchBar!
    
    @IBOutlet weak var supplierSortView: UIView!
    @IBOutlet weak var supplierSortingBySegmentControl: UISegmentedControl!
    @IBOutlet weak var supplierSortingAsSegmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigationMultilineTitle()
        setNavigationbar()
        setSearchBar()
        getSupplier()
        getData()
        hideKeyboard()
//        countSDS()
        
        //remove extra separator line in table view
        self.supplierTableView.tableFooterView = UIView()
        self.supplierTableView.tableFooterView?.backgroundColor = UIColor.clear
        self.supplierSortView.isHidden = true
        self.supplierSortView.layer.cornerRadius = 10
        checkPurchaseSearchPassData.loadBool = true
        self.navigationController?.navigationBar.isHidden = false
        self.loadmoreLabel.isHidden = true
        
        checkPurchaseSearchSupplierFilterdData = sortedsupplierFullData
        
        //chang the selected segment text color
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        //event for touch already selected segment
        let segmentedTapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapGestureSegment(_:)))
        supplierSortingAsSegmentControl.addGestureRecognizer(segmentedTapGesture)
        
    }
    
    // function to control if the user tapped the selected segment
        @IBAction func onTapGestureSegment(_ tapGesture: UITapGestureRecognizer) {
            
            let point = tapGesture.location(in: supplierSortingAsSegmentControl)
            let segmentSize = supplierSortingAsSegmentControl.bounds.size.width / CGFloat(supplierSortingAsSegmentControl.numberOfSegments)
            let touchedSegment = Int(point.x / segmentSize)

            if supplierSortingAsSegmentControl.selectedSegmentIndex != touchedSegment {
                // Normal behaviour the segment changes
                supplierSortingAsSegmentControl.selectedSegmentIndex = touchedSegment
            } else {
                // Tap on the already selected segment
                supplierSortingAsSegmentControl.selectedSegmentIndex = touchedSegment
            }
            sortingAsDidChange(supplierSortingAsSegmentControl)
            
        }
    
    //check 
    override func viewWillAppear(_ animated: Bool) {

        if checkPurchaseSearchPassData.loadBool == true {
            checkPurchaseSearchPassData.storedDataArray = localsearchinfo.results
            checkPurchaseSearchPassData.loadBool = false
        } else {
            localsearchinfo.results = checkPurchaseSearchPassData.storedDataArray
        }
        
        //unselect after returning back to this page
        if let indexPath = self.supplierTableView.indexPathForSelectedRow{             self.supplierTableView.deselectRow(at: indexPath, animated: animated)         }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupNavigationMultilineTitle()
    }
    
    //set up the navigation bar
    func setNavigationbar() {

        //change background color & back button color
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.25, green:0.26, blue:0.26, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white

        //change navigation bar text color and font
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18), .foregroundColor: UIColor.white]
        
        self.navigationItem.title = checkPurchaseSearchPassData.passedProductName
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(sortTapped))
    }
    
    //set up the search bar
    func setSearchBar() {
        searchSupplierSearchBar.set(textColor: .black)
        //searchbar text field color
        searchSupplierSearchBar.setTextField(color: UIColor.white)
        searchSupplierSearchBar.setPlaceholder(textColor: .black)
        searchSupplierSearchBar.setSearchImage(color: .black)
    }
    
    func getSupplier() {
        let matchProductName = checkPurchaseSearchPassData.passedProductName
        
        for i in 0..<localsearchinfo.results.count {
            if matchProductName == localsearchinfo.results[i].prodname {
                supplierArray.append(localsearchinfo.results[i].company)
            }
        }
        
        for i in supplierArray {
            if tableData[i] == nil {
                tableData[i] = 1
            } else {
                tableData[i]! += 1
            }
        }
        
//        for (key, value) in tableData {
//            tableDataValue.supplier = "\(key)"
//            tableDataValue.noOfSDS = "\(value)"
//            checkPurchaseSearchSupplierDataArray.append(tableDataValue)
//        }
        
    }
    
    // Operator Overloading Methods
//    static func >(lhs: NSDate, rhs: NSDate) -> Bool {
//        return lhs.compare(rhs) == ComparisonResult.OrderedAscending
//    }
//
//    static func <(lhs: NSDate, rhs: NSDate) -> Bool {
//        return lhs.compare(rhs) == ComparisonResult.OrderedDescending
//    }
    
    func getData() {
        checkPurchaseSearchSupplierDataArray.removeAll()
        let matchProductName = checkPurchaseSearchPassData.passedProductName
        var issueDateRange: String = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        for (key, _) in tableData {
            let matchSupplier = "\(key)"
            sdsDataArray.removeAll()
            issueDateValueArray.removeAll()
            for i in 0..<localsearchinfo.results.count {
                if matchProductName == localsearchinfo.results[i].prodname && matchSupplier == localsearchinfo.results[i].company {
                    
                    let issuedateValue = dateFormatter.string(from: localsearchinfo.results[i].issueDate)
                    issueDateValueArray.append(issuedateValue)
                    
                    let sdsValue = localsearchinfo.results[i].sdsno ?? ""
                    sdsDataArray.append(sdsValue)
                }
            }
            
            //set issue date range
            if issueDateValueArray.count > 1 {

//                var issueDateRangeArray = [Int]()
                var issueDateRangeArray = [Date]()

//                for i in 0..<issueDateValueArray.count {
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "dd/MM/yyyy"
//                    let date = dateFormatter.date(from: issueDateValueArray[i])
//                    dateFormatter.dateFormat = "yyyy"
//                    let date2 = Int(dateFormatter.string(from: date!)) ?? 0000
//                    issueDateRangeArray.append(date2)
//
//                }
//                let minYear = issueDateRangeArray.min() ?? 0
//                let maxYear = issueDateRangeArray.max() ?? 0
//                issueDateRange = "\(minYear) - \(maxYear)"
//                issueDateArray.append(issueDateRange)

                for i in 0..<issueDateValueArray.count {
                    
                    let date = dateFormatter.date(from: issueDateValueArray[i])!
                    issueDateRangeArray.append(date)
                }
                
                let minDate = issueDateValueArray.min()
                let maxDate = issueDateValueArray.max()
                issueDateRange = "\(minDate ?? "") - \(maxDate ?? "")"
//                issueDateRange = "\(dateFormatter.string(from: minDate)) - \(dateFormatter.string(from: maxDate))"
                issueDateArray.append(issueDateRange)
                
                supplierFullDataValue.minIssueDate = dateFormatter.date(from: minDate!)
                supplierFullDataValue.maxIssueDate = dateFormatter.date(from: maxDate!)
            } else {
                
                issueDateRange = issueDateValueArray.first ?? ""
                issueDateArray.append(issueDateValueArray.first ?? "")
                supplierFullDataValue.minIssueDate = dateFormatter.date(from: issueDateRange)
                supplierFullDataValue.maxIssueDate = dateFormatter.date(from: issueDateRange)
            }
            
//            supplierFullDataValue.supplier = matchSupplier
//            //count no of SDS
////            supplierFullDataValue.noOfSDS = uniqueSDSCount.count
//            //changed to count the products
//            supplierFullDataValue.noOfSDS = sdsDataArray.count
//            supplierFullDataValue.issueDate = (issueDateRange)
//            supplierFullData.append(supplierFullDataValue)
            
                supplierFullDataValue.supplier = matchSupplier
                //count no of SDS
//            supplierFullDataValue.noOfSDS = uniqueSDSCount.count
                //changed to count the products
                supplierFullDataValue.noOfSDS = sdsDataArray.count
                supplierFullDataValue.issueDate = (issueDateRange)
                supplierFullData.append(supplierFullDataValue)

        }
        sortDataDefault()
    }
    
    @objc func sortTapped() {
        
        if settingBool == false {
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.orange

            supplierSortView.isHidden = false
            settingBool = true
        } else if settingBool == true {
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            supplierSortView.isHidden = true

            settingBool = false
        }

    }
    
    @IBAction func sortingByDidChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            sortingBy = "Supplier"
            supplierSortingAsSegmentControl.setTitle("A to Z", forSegmentAt: 0)
            supplierSortingAsSegmentControl.setTitle("Z to A", forSegmentAt: 1)
            sortSupplier(updown: true)
            supplierSortingAsSegmentControl.selectedSegmentIndex = 0
        } else if sender.selectedSegmentIndex == 1 {
            sortingBy = "No. Of SDS(s)"
            supplierSortingAsSegmentControl.setTitle("Largest to Smallest", forSegmentAt: 0)
            supplierSortingAsSegmentControl.setTitle("Smallest to Largest", forSegmentAt: 1)
            sortNumberOfSDS(updown: true)
            supplierSortingAsSegmentControl.selectedSegmentIndex = 0
        } else if sender.selectedSegmentIndex == 2 {
            sortingBy = "Issue Date"
            supplierSortingAsSegmentControl.setTitle("Latest to Oldest", forSegmentAt: 0)
            supplierSortingAsSegmentControl.setTitle("Oldest to Latest", forSegmentAt: 1)
            sortIssueDate(updown: true)
            supplierSortingAsSegmentControl.selectedSegmentIndex = 0
        }
    }
    
    @IBAction func sortingAsDidChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            if sortingBy == "Supplier" {
                sortSupplier(updown: true)
                supplierSortView.isHidden = true
                settingBool = false
                self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            } else if sortingBy == "No. Of SDS(s)" {
                sortNumberOfSDS(updown: true)
                supplierSortView.isHidden = true
                settingBool = false
                self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            } else if sortingBy == "Issue Date" {
                sortIssueDate(updown: true)
                supplierSortView.isHidden = true
                settingBool = false
                self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            }
            
            currentSegmentNumber = 0
            defaultSegmentNumber = 0
        } else if sender.selectedSegmentIndex == 1 {
            if sortingBy == "Supplier" {
                sortSupplier(updown: false)
                supplierSortView.isHidden = true
                settingBool = false
                self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            } else if sortingBy == "No. Of SDS(s)" {
                sortNumberOfSDS(updown: false)
                supplierSortView.isHidden = true
                settingBool = false
                self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            } else if sortingBy == "Issue Date" {
                sortIssueDate(updown: false)
                supplierSortView.isHidden = true
                settingBool = false
                self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            }
            
            currentSegmentNumber = 1
            defaultSegmentNumber = 1
        }
    }
    
    //tap the view outside the sort view will dismiss sort view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         let touch = touches.first
        if touch?.view != self.supplierSortView {
            supplierSortView.resignFirstResponder()

            supplierSortView.isHidden = true
            settingBool = false
            navigationItem.rightBarButtonItem?.tintColor = UIColor.white

        } else if touch?.view == self.supplierSortView {
            supplierSortView.resignFirstResponder()
            if currentSegmentNumber == defaultSegmentNumber {
                supplierSortView.isHidden = true
                settingBool = false
                navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            }
        }
    }
    
    
            
    // sort the no of SDS function (changed to sort no of the products)
    func sortDataDefault() {

        sortedsupplierFullData = supplierFullData.sorted {
            $1.supplier > $0.supplier
        }
    }
    
    //sort supplier
    func sortSupplier(updown: Bool) {
        checkPurchaseSearchSupplierFilterdData.removeAll()
        searchSupplierSearchBar.text = ""
        
        if updown == true {
            
            checkPurchaseSearchSupplierFilterdData = supplierFullData.sorted {
                $1.supplier > $0.supplier
            }

            supplierTableView.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            supplierTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            

        } else if updown == false {
            checkPurchaseSearchSupplierFilterdData = supplierFullData.sorted {
                $0.supplier > $1.supplier
            }
            supplierTableView.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            supplierTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            

        }
        
    }
    
    //sort no. of sds
    func sortNumberOfSDS(updown: Bool) {
        checkPurchaseSearchSupplierFilterdData.removeAll()
        searchSupplierSearchBar.text = ""
        
        if updown == true {
            
            checkPurchaseSearchSupplierFilterdData = supplierFullData.sorted {
                $0.noOfSDS > $1.noOfSDS
            }
            supplierTableView.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            supplierTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            

        } else if updown == false {
            checkPurchaseSearchSupplierFilterdData = supplierFullData.sorted {
                $1.noOfSDS > $0.noOfSDS
            }
            supplierTableView.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            supplierTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            
        }
        
    }
    
    //sort issue date
    func sortIssueDate(updown: Bool) {
        checkPurchaseSearchSupplierFilterdData.removeAll()
        searchSupplierSearchBar.text = ""
        
        if updown == true {
            
            checkPurchaseSearchSupplierFilterdData = supplierFullData.sorted {
                $0.maxIssueDate > $1.maxIssueDate
            }
            supplierTableView.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            supplierTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            

        } else if updown == false {
            checkPurchaseSearchSupplierFilterdData = supplierFullData.sorted {
                $1.minIssueDate > $0.minIssueDate
            }
            supplierTableView.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            supplierTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        checkPurchaseSearchSupplierFilterdData = []
        
        if searchText == "" {
            checkPurchaseSearchSupplierFilterdData = sortedsupplierFullData
        } else {
            for item in sortedsupplierFullData {
                if item.supplier.uppercased().contains(searchText.uppercased()) {
                    checkPurchaseSearchSupplierFilterdData.append(item)
                }
            }
        }
        self.supplierTableView.reloadData()
        
    }
    
    //hide keyboard function
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(disKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    //Notify to disKeyboard
    @objc func disKeyboard() {
        searchSupplierSearchBar.endEditing(true)
    }

}

extension CheckPurchaseTablePage_VC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return sortedsupplierFullData.count
        return checkPurchaseSearchSupplierFilterdData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: "checkBuyTableCell", for: indexPath) as! CheckPurchaseTableViewCell
        
        cell.supplierLabel.text = String(self.checkPurchaseSearchSupplierFilterdData[indexPath.row].supplier)
        cell.noOfSDSLabel.text = "No. Of Products: \(String(self.checkPurchaseSearchSupplierFilterdData[indexPath.row].noOfSDS ?? 0))"
        cell.issueDateLabel.text = "Issue Date: \(String(checkPurchaseSearchSupplierFilterdData[indexPath.row].issueDate))"
        
        cell.supplierLabel.textColor = UIColor.white
        cell.noOfSDSLabel.textColor = UIColor.white

        let image = UIImage(named: "CSI-CFBC")
        let imageView = UIImageView(image: image)
        cell.backgroundView = imageView
            
        cell.layer.cornerRadius = 10
//        cell.selectionStyle = .none
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        localsearchinfo.results.removeAll()
        let matchProductName = checkPurchaseSearchPassData.passedProductName
        let matchSupplier = checkPurchaseSearchSupplierFilterdData[indexPath.row].supplier
        
        for i in 0..<checkPurchaseSearchPassData.storedDataArray.count {
            var ritem = item()
            if matchProductName == checkPurchaseSearchPassData.storedDataArray[i].prodname && matchSupplier == checkPurchaseSearchPassData.storedDataArray[i].company{
                ritem.prodname = checkPurchaseSearchPassData.storedDataArray[i].prodname
                ritem.company = checkPurchaseSearchPassData.storedDataArray[i].company
                ritem.issueDate = checkPurchaseSearchPassData.storedDataArray[i].issueDate
                ritem.synno = checkPurchaseSearchPassData.storedDataArray[i].synno
                ritem.unno = checkPurchaseSearchPassData.storedDataArray[i].unno
                ritem.prodtype = checkPurchaseSearchPassData.storedDataArray[i].prodtype
                ritem.prodcode = checkPurchaseSearchPassData.storedDataArray[i].prodcode
                ritem.dgclass = checkPurchaseSearchPassData.storedDataArray[i].dgclass
                ritem.ps = checkPurchaseSearchPassData.storedDataArray[i].ps
                ritem.haz = checkPurchaseSearchPassData.storedDataArray[i].haz
                ritem.Com_Country = checkPurchaseSearchPassData.storedDataArray[i].Com_Country
                ritem.GHS_Pictogram = checkPurchaseSearchPassData.storedDataArray[i].GHS_Pictogram
                localsearchinfo.results.append(ritem)
            }
        }
        
        

        let searchJump = self.storyboard?.instantiateViewController(withIdentifier: "TablePage") as? SearchTablePage_VC
        self.navigationController?.pushViewController(searchJump!, animated: true)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if settingBool == true {
            supplierSortView.isHidden = true
            navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            settingBool = false
        }
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        if (maximumOffset - currentOffset <= -70.0) {
            
            if (sortedsupplierFullData.count < 250) {
                loadmoreLabel.isHidden = false
                loadmoreLabel.text = "All data has been loaded."
            } else if ( sortedsupplierFullData.count > 249) {
                loadmoreLabel.isHidden = false
                loadmoreLabel.text = "Only 250 results have been displayed.\n Please refine your search criteria for more accurate results."
            }
            
        } else {
            loadmoreLabel.isHidden = true
        }
        searchSupplierSearchBar.endEditing(true)
    }
    
}

//for long product name
extension UIViewController {

    func setupNavigationMultilineTitle() {
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        for sview in navigationBar.subviews {
            for ssview in sview.subviews {
                guard let label = ssview as? UILabel else { break }
                if label.text == self.title {
                    label.numberOfLines = 0
                    label.lineBreakMode = .byWordWrapping
                    label.sizeToFit()
//                    UIView.animate(withDuration: 0.3, animations: {
//                        navigationBar.frame.size.height = 57 + label.frame.height
//                    })
                }
            }
        }
    }
}
