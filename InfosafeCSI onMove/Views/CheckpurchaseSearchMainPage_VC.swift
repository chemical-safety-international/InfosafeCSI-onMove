//
//  CheckpurchaseSearchCollectionPage_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 24/11/20.
//  Copyright © 2020 Chemical Safety International. All rights reserved.
//

import UIKit

class CheckpurchaseSearchMainPage_VC: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var checkPurchaseTableView: UITableView!
    
    @IBOutlet weak var loadmoreLabel: UILabel!
    
    @IBOutlet weak var searchProductNameSearchBar: UISearchBar!
    @IBOutlet weak var sortView: UIView!
    
    @IBOutlet weak var sortingBySegmentControl: UISegmentedControl!
    @IBOutlet weak var sortingInSegmentControl: UISegmentedControl!
    
    var checkPurchaseSearchDataArray : [checkPurchaseSearchData] = []
    var checkPurchaseSearchDataArray1 : [checkPurchaseSearchData] = []
    var tableDataValue = checkPurchaseSearchData()
    var productNameArray = [String]()
    var tableData = [String: Int]()
    var tableData1 = [String: Int]()
    var collectionSortedData = [String: Int]()
    var supplierArray = [String]()
    
    var checkPurchaseSearchFilterdData: [checkPurchaseSearchData] = []
    
    var productNameUpdownValue: Bool = true
    var noOfSupplierUpdownValue: Bool = true
    
    var settingBool: Bool = false
    var sortingBy: String = "Product Name"
    var defaultSegmentNumber: Int = 0
    var currentSegmentNumber: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavigationbar()
        setSearchBar()
        addData()
        
        self.navigationController?.navigationBar.isHidden = false
        self.loadmoreLabel.isHidden = true
        self.sortView.isHidden = true
        self.sortView.layer.cornerRadius = 10
        checkPurchaseSearchFilterdData = checkPurchaseSearchDataArray
        
        //chang the selected segment text color
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        //event for touch already selected segment
        let segmentedTapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapGestureSegment(_:)))
        sortingInSegmentControl.addGestureRecognizer(segmentedTapGesture)
        
        //default sorting
        sortProductName(updown: true)
    }
    
// function to control if the user tapped the selected segment
    @IBAction func onTapGestureSegment(_ tapGesture: UITapGestureRecognizer) {
        
        let point = tapGesture.location(in: sortingInSegmentControl)
        let segmentSize = sortingInSegmentControl.bounds.size.width / CGFloat(sortingInSegmentControl.numberOfSegments)
        let touchedSegment = Int(point.x / segmentSize)

        if sortingInSegmentControl.selectedSegmentIndex != touchedSegment {
            // Normal behaviour the segment changes
            sortingInSegmentControl.selectedSegmentIndex = touchedSegment
        } else {
            // Tap on the already selected segment
            sortingInSegmentControl.selectedSegmentIndex = touchedSegment
        }
        sortingInDidChanged(sortingInSegmentControl)
        
    }
    
    
    //set up navigation bar
    func setNavigationbar() {
            //change background color & back button color
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.barTintColor = UIColor(red:0.25, green:0.26, blue:0.26, alpha:1.0)
            self.navigationController?.navigationBar.tintColor = UIColor.white

//            //change navigation bar text color and font
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 23), .foregroundColor: UIColor.white]
            self.navigationItem.title = "Result"
               
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(sortTapped))
            
    }
    
    //load data into array
    func addData() {
        
        //get the product names and no of product name
        for i in 0..<localsearchinfo.results.count {
            let productNameData = localsearchinfo.results[i].prodname ?? ""
            productNameArray.append(productNameData)
        }

        //remove duplicates
        for i in productNameArray {
            if tableData[i] == nil {
                tableData[i] = 1
            } else {
                tableData[i]! += 1
            }
        }

        for (key, value) in tableData {
            tableDataValue.productName = "\(key)"
            tableDataValue.noOfSupplier = Int("\(value)")
            checkPurchaseSearchDataArray.append(tableDataValue)
        }

     
        
        //get no of supplier for each product
        for i in 0..<localsearchinfo.results.count {
            let matchProductName = localsearchinfo.results[i].prodname
            supplierArray.removeAll()
            for i in 0..<localsearchinfo.results.count {
                if matchProductName == localsearchinfo.results[i].prodname {
                    let supplier = localsearchinfo.results[i].company ?? ""
                    supplierArray.append(supplier)
                }
            }
            
            //remove duplicates
            supplierArray = uniq(source: supplierArray)

            tableDataValue.productName = matchProductName
            tableDataValue.noOfSupplier = Int("\(supplierArray.count)")
            checkPurchaseSearchDataArray1.append(tableDataValue)

        }

        
        //match each product with suppliers
        for i in 0..<checkPurchaseSearchDataArray.count {
            let matchProductName = checkPurchaseSearchDataArray[i].productName
            var matchNoOfSupplier = checkPurchaseSearchDataArray[i].noOfSupplier
            for i in 0..<checkPurchaseSearchDataArray1.count {
                if matchProductName == checkPurchaseSearchDataArray1[i].productName {
                    matchNoOfSupplier = checkPurchaseSearchDataArray1[i].noOfSupplier
                }
            }
            checkPurchaseSearchDataArray[i].noOfSupplier = matchNoOfSupplier
        }
        
        //adding for sort function
        for i in 0..<checkPurchaseSearchDataArray.count {
            tableData1[checkPurchaseSearchDataArray[i].productName] = Int(checkPurchaseSearchDataArray[i].noOfSupplier)
        }

    }
    
    //uniq function for remove duplicate items in an array
    func uniq<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
    
    //function for navigation button
    @objc func sortTapped() {
        
        if settingBool == false {
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.orange
            
            sortView.isHidden = false
            settingBool = true
        } else if settingBool == true {
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            sortView.isHidden = true
            settingBool = false
        }

    }
    
    @IBAction func sortingByDidChanged(_ sender: UISegmentedControl) {
       
        if sender.selectedSegmentIndex == 0 {
            sortingBy = "Product Name"
            sortingInSegmentControl.setTitle("A to Z", forSegmentAt: 0)
            sortingInSegmentControl.setTitle("Z to A", forSegmentAt: 1)
            sortProductName(updown: true)
            sortingInSegmentControl.selectedSegmentIndex = 0
        } else if sender.selectedSegmentIndex == 1 {
            sortingBy = "No. Of Supplier(s)"
            sortingInSegmentControl.setTitle("Largest to Smallest", forSegmentAt: 0)
            sortingInSegmentControl.setTitle("Smallest to Largest", forSegmentAt: 1)
            sortNoOfSupplier(updown: true)
            sortingInSegmentControl.selectedSegmentIndex = 0
        }
    }
    
    
    @IBAction func sortingInDidChanged(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            if sortingBy == "Product Name" {
                sortProductName(updown: true)
                sortView.isHidden = true
                settingBool = false
                self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            } else if sortingBy == "No. Of Supplier(s)" {
                sortNoOfSupplier(updown: true)
                sortView.isHidden = true
                settingBool = false
                self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            }
            
            currentSegmentNumber = 0
            defaultSegmentNumber = 0
            
        } else if sender.selectedSegmentIndex == 1 {
            if sortingBy == "Product Name" {
                sortProductName(updown: false)
                sortView.isHidden = true
                settingBool = false
                self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            } else if sortingBy == "No. Of Supplier(s)" {
                sortNoOfSupplier(updown: false)
                sortView.isHidden = true
                settingBool = false
                self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            }
            currentSegmentNumber = 1
            defaultSegmentNumber = 1
            
        }
    }
    
    
    //sort by name
    func sortProductName(updown: Bool) {
        checkPurchaseSearchFilterdData.removeAll()
        searchProductNameSearchBar.text = ""
        
        if updown == true {
            for (key, value) in self.tableData1.sorted(by: { $0.key < $1.key}) {
                tableDataValue.productName = "\(key)"
                tableDataValue.noOfSupplier = Int("\(value)")
                checkPurchaseSearchFilterdData.append(tableDataValue)
            }
            checkPurchaseTableView.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            checkPurchaseTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            
            productNameUpdownValue = false
        } else if updown == false {
            for (key, value) in self.tableData1.sorted(by: { $0.key > $1.key}) {
                tableDataValue.productName = "\(key)"
                tableDataValue.noOfSupplier = Int("\(value)")
                checkPurchaseSearchFilterdData.append(tableDataValue)
            }
            checkPurchaseTableView.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            checkPurchaseTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            
            productNameUpdownValue = true
        }
        

        noOfSupplierUpdownValue = true
        
    }
    
    //sort by number
    func sortNoOfSupplier(updown: Bool) {
        checkPurchaseSearchFilterdData.removeAll()
        searchProductNameSearchBar.text = ""
        
        if (updown == true) {
            for (key, value) in self.tableData1.sorted(by: { $1.value < $0.value}) {
                tableDataValue.productName = "\(key)"
                tableDataValue.noOfSupplier = Int("\(value)")
                checkPurchaseSearchFilterdData.append(tableDataValue)
            }
            checkPurchaseTableView.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            checkPurchaseTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            
            noOfSupplierUpdownValue = false
        } else if (updown == false) {
            
            for (key, value) in self.tableData1.sorted(by: { $0.value < $1.value}) {
                tableDataValue.productName = "\(key)"
                tableDataValue.noOfSupplier = Int("\(value)")
                checkPurchaseSearchFilterdData.append(tableDataValue)
            }
            checkPurchaseTableView.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            checkPurchaseTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            
            noOfSupplierUpdownValue = true
        }

        productNameUpdownValue = true
    }
    
    //unselect after returning back to this page
    override func viewWillAppear(_ animated: Bool) {
        if let indexPath = self.checkPurchaseTableView.indexPathForSelectedRow{             self.checkPurchaseTableView.deselectRow(at: indexPath, animated: animated)         }
    }
    
    //tap the view outside the sort view will dismiss sort view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         let touch = touches.first
        if touch?.view != self.sortView {
            sortView.resignFirstResponder()

            sortView.isHidden = true
            settingBool = false
            navigationItem.rightBarButtonItem?.tintColor = UIColor.white

        } else if touch?.view == self.sortView {
            sortView.resignFirstResponder()
            if currentSegmentNumber == defaultSegmentNumber {
                sortView.isHidden = true
                settingBool = false
                navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            }
        }
    }
    
    //catch the action of typing
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        checkPurchaseSearchFilterdData = []
        
        if searchText == "" {
            checkPurchaseSearchFilterdData = checkPurchaseSearchDataArray
        } else {
            for item in checkPurchaseSearchDataArray {
                if item.productName.uppercased().contains(searchText.uppercased()) {
                    checkPurchaseSearchFilterdData.append(item)
                }
            }
        }
        self.checkPurchaseTableView.reloadData()
        
    }
    
    //setup search bar style
    func setSearchBar() {
        searchProductNameSearchBar.set(textColor: .black)
        //searchbar text field color
        searchProductNameSearchBar.setTextField(color: UIColor.white)
        searchProductNameSearchBar.setPlaceholder(textColor: .black)
        searchProductNameSearchBar.setSearchImage(color: .black)
    }

}

//control for tableview
extension CheckpurchaseSearchMainPage_VC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkPurchaseSearchFilterdData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkPurchaseMainTableViewCell", for: indexPath) as! CheckPurchaseMainTableViewCell
        
        cell.productNameLabel.text = self.checkPurchaseSearchFilterdData[indexPath.row].productName
        
        cell.noOfSupplierLabel.text = String(self.checkPurchaseSearchFilterdData[indexPath.row].noOfSupplier)
        
        let image = UIImage(named: "CSI-CFBC")
        let imageView = UIImageView(image: image)
        cell.backgroundView = imageView

        cell.layer.cornerRadius = 10
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        print(checkPurchaseSearchDataArray[indexPath.row].productName ?? "")
        checkPurchaseSearchPassData.passedProductName = checkPurchaseSearchFilterdData[indexPath.row].productName
        
        let sdsJump = self.storyboard?.instantiateViewController(withIdentifier: "SupplierPage") as? CheckPurchaseTablePage_VC
        self.navigationController?.pushViewController(sdsJump!, animated: true)
    
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if settingBool == true {
            sortView.isHidden = true
            navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            settingBool = false
        }
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        if (maximumOffset - currentOffset <= -70.0) {
            
            if (localsearchinfo.results.count < 250) {
                loadmoreLabel.isHidden = false
                loadmoreLabel.text = "All data has been loaded."
            } else if ( localsearchinfo.results.count > 249) {
                loadmoreLabel.isHidden = false
                loadmoreLabel.text = "Only 250 results have been displayed.\n Please refine your search criteria for more accurate results."
            }
            
        } else {
            loadmoreLabel.isHidden = true
        }
        
    }
    
    
}
