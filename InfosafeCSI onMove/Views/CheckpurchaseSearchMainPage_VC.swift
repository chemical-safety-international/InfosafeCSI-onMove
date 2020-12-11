//
//  CheckpurchaseSearchCollectionPage_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 24/11/20.
//  Copyright © 2020 Chemical Safety International. All rights reserved.
//

import UIKit

class CheckpurchaseSearchMainPage_VC: UIViewController {
    
    @IBOutlet weak var checkPurchaseTableView: UITableView!
    
    @IBOutlet weak var productNameTittleLbl: UILabel!
    @IBOutlet weak var noOfSupplierTitleLbl: UILabel!
    
    
    
    @IBOutlet weak var sortProductNameButton: UIButton!
    @IBOutlet weak var sortNoOfSupplierButton: UIButton!
    
    @IBOutlet weak var loadmoreLabel: UILabel!
    
    var checkPurchaseSearchDataArray : [checkPurchaseSearchData] = []
    var checkPurchaseSearchDataArray1 : [checkPurchaseSearchData] = []
    var tableDataValue = checkPurchaseSearchData()
    var productNameArray = [String]()
    var tableData = [String: Int]()
    var tableData1 = [String: Int]()
    var collectionSortedData = [String: Int]()
    var supplierArray = [String]()
    
    var productNameUpdownValue: Bool = true
    var noOfSupplierUpdownValue: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavigationbar()
        setupTitles()
        addData()
        
        self.navigationController?.navigationBar.isHidden = false
        self.loadmoreLabel.isHidden = true
    }
    
    func setupTitles() {
        let productNameTitle = "Product Name"
        let noOfSupplierTitle = "No. Of Suppliers"
        
        productNameTittleLbl.text = productNameTitle
        noOfSupplierTitleLbl.text = noOfSupplierTitle
        
        productNameTittleLbl.backgroundColor = UIColor.orange
        noOfSupplierTitleLbl.backgroundColor = UIColor.orange
        
        productNameTittleLbl.textColor = UIColor.white
        noOfSupplierTitleLbl.textColor = UIColor.white
        
        productNameTittleLbl.layer.borderWidth = 0.5
        noOfSupplierTitleLbl.layer.borderWidth = 0.5
        
        productNameTittleLbl.layer.borderColor = UIColor.white.cgColor
        noOfSupplierTitleLbl.layer.borderColor = UIColor.white.cgColor
        
        productNameTittleLbl.font = UIFont.boldSystemFont(ofSize: 16)
        noOfSupplierTitleLbl.font = UIFont.boldSystemFont(ofSize: 12)
    }
    

    
    func setNavigationbar() {
        //change background color
//        DispatchQueue.main.async {
//
//            //change background color & back button color
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.barTintColor = UIColor(red:0.25, green:0.26, blue:0.26, alpha:1.0)
            self.navigationController?.navigationBar.tintColor = UIColor.white

//            //change navigation bar text color and font
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 23), .foregroundColor: UIColor.white]
            self.navigationItem.title = "Result"
               
            
//        }
    }
    
    func addData() {
        
        //get the product names and no of product name
        for i in 0..<localsearchinfo.results.count {
            let productNameData = localsearchinfo.results[i].prodname ?? ""
            productNameArray.append(productNameData)
        }
//        print(productNameArray)

        //remove duplicates
        for i in productNameArray {
            if tableData[i] == nil {
                tableData[i] = 1
            } else {
                tableData[i]! += 1
            }
        }
//        print("TableData: \(tableData)")

        for (key, value) in tableData {
            tableDataValue.productName = "\(key)"
            tableDataValue.noOfSupplier = Int("\(value)")
            checkPurchaseSearchDataArray.append(tableDataValue)
        }
        
//        print("CheckPurchase SearchData Array: \(checkPurchaseSearchDataArray)")
     
        
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
//        print("CheckPurchase SearchData Array1: \(checkPurchaseSearchDataArray1)")

        
        //match each product with suppliers
        for i in 0..<checkPurchaseSearchDataArray.count {
            let matchProductName = checkPurchaseSearchDataArray[i].productName
            var matchNoOfSupplier = checkPurchaseSearchDataArray[i].noOfSupplier
            for i in 0..<checkPurchaseSearchDataArray1.count {
                if matchProductName == checkPurchaseSearchDataArray1[i].productName {
                    matchNoOfSupplier = checkPurchaseSearchDataArray1[i].noOfSupplier
//                    print("name: \(matchProductName ?? "") \n onriginal no: \(matchNoOfSupplier ?? "")\n current no: \(checkPurchaseSearchDataArray1[i].noOfSupplier ?? "")")
                }
            }
            checkPurchaseSearchDataArray[i].noOfSupplier = matchNoOfSupplier

        }
        
//        print("CheckPurchase SearchData Array: \(checkPurchaseSearchDataArray)")
        
        
        //adding for sort function
        for i in 0..<checkPurchaseSearchDataArray.count {
            tableData1[checkPurchaseSearchDataArray[i].productName] = Int(checkPurchaseSearchDataArray[i].noOfSupplier)
        }
        
        sortProductName(updown: productNameUpdownValue)
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
    
    //sort by name
    func sortProductName(updown: Bool) {
        checkPurchaseSearchDataArray.removeAll()
        
        if updown == true {
            for (key, value) in self.tableData1.sorted(by: { $0.key < $1.key}) {
                tableDataValue.productName = "\(key)"
                tableDataValue.noOfSupplier = Int("\(value)")
                checkPurchaseSearchDataArray.append(tableDataValue)
            }
            checkPurchaseTableView.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            checkPurchaseTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            
            sortProductNameButton.setImage(UIImage.init(systemName: "arrowtriangle.up.fill"), for: .normal)
            sortProductNameButton.tintColor = UIColor.gray
            productNameUpdownValue = false
        } else if updown == false {
            for (key, value) in self.tableData1.sorted(by: { $0.key > $1.key}) {
                tableDataValue.productName = "\(key)"
                tableDataValue.noOfSupplier = Int("\(value)")
                checkPurchaseSearchDataArray.append(tableDataValue)
            }
            checkPurchaseTableView.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            checkPurchaseTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            
            sortProductNameButton.setImage(UIImage.init(systemName: "arrowtriangle.down.fill"), for: .normal)
            sortProductNameButton.tintColor = UIColor.gray
            productNameUpdownValue = true
        }
        
        sortNoOfSupplierButton.tintColor = UIColor.white
        sortNoOfSupplierButton.setImage(UIImage.init(systemName: "arrowtriangle.down.fill"), for: .normal)
        noOfSupplierUpdownValue = true
        
    }
    
    //sort by number
    func sortNoOfSupplier(updown: Bool) {
        checkPurchaseSearchDataArray.removeAll()
        
        if (updown == true) {
            for (key, value) in self.tableData1.sorted(by: { $1.value < $0.value}) {
                tableDataValue.productName = "\(key)"
                tableDataValue.noOfSupplier = Int("\(value)")
                checkPurchaseSearchDataArray.append(tableDataValue)
            }
            checkPurchaseTableView.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            checkPurchaseTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            
            sortNoOfSupplierButton.setImage(UIImage.init(systemName: "arrowtriangle.up.fill"), for: .normal)
            sortNoOfSupplierButton.tintColor = UIColor.gray
            noOfSupplierUpdownValue = false
        } else if (updown == false) {
            
            for (key, value) in self.tableData1.sorted(by: { $0.value < $1.value}) {
                tableDataValue.productName = "\(key)"
                tableDataValue.noOfSupplier = Int("\(value)")
                checkPurchaseSearchDataArray.append(tableDataValue)
            }
            checkPurchaseTableView.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            checkPurchaseTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            
            sortNoOfSupplierButton.setImage(UIImage.init(systemName: "arrowtriangle.down.fill"), for: .normal)
            sortNoOfSupplierButton.tintColor = UIColor.gray
            noOfSupplierUpdownValue = true
        }
        sortProductNameButton.tintColor = UIColor.white
        sortProductNameButton.setImage(UIImage.init(systemName: "arrowtriangle.down.fill"), for: .normal)
        productNameUpdownValue = true
    }
    

    @IBAction func sortProductNameButtonTapped(_ sender: Any) {
    
        sortProductName(updown: productNameUpdownValue)

    }
    
    @IBAction func sortNoOfSupplierButtonTapped(_ sender: Any) {
        sortNoOfSupplier(updown: noOfSupplierUpdownValue)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //unselect after returning back to this page
    override func viewWillAppear(_ animated: Bool) {
        if let indexPath = self.checkPurchaseTableView.indexPathForSelectedRow{             self.checkPurchaseTableView.deselectRow(at: indexPath, animated: animated)         }
    }

}

extension CheckpurchaseSearchMainPage_VC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkPurchaseSearchDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkPurchaseMainTableViewCell", for: indexPath) as! CheckPurchaseMainTableViewCell
        
        cell.productNameLabel.layer.borderWidth = 0.5
        cell.noOfSupplierLabel.layer.borderWidth = 0.5
        
        cell.productNameLabel.layer.borderColor = UIColor.white.cgColor
        cell.noOfSupplierLabel.layer.borderColor = UIColor.white.cgColor
        
        if indexPath.row == 0 {

            cell.productNameLabel.text = self.checkPurchaseSearchDataArray[indexPath.row].productName
            
            cell.noOfSupplierLabel.text = String(self.checkPurchaseSearchDataArray[indexPath.row].noOfSupplier)
            
            cell.backgroundColor = UIColor.darkGray

            cell.productNameLabel.textColor = UIColor.white
            cell.noOfSupplierLabel.textColor = UIColor.white

        } else if indexPath.row % 2 == 0 && indexPath.row != 0 {
            
            cell.productNameLabel.text = self.checkPurchaseSearchDataArray[indexPath.row].productName
            
            cell.noOfSupplierLabel.text = String(self.checkPurchaseSearchDataArray[indexPath.row].noOfSupplier)
            
            cell.backgroundColor = UIColor.darkGray
            
            cell.productNameLabel.textColor = UIColor.white
            cell.noOfSupplierLabel.textColor = UIColor.white
            
//            print("%2: \(indexPath.section)")
            
        } else {
            cell.productNameLabel.text = self.checkPurchaseSearchDataArray[indexPath.row].productName
            cell.noOfSupplierLabel.text = String(self.checkPurchaseSearchDataArray[indexPath.row].noOfSupplier)
            
//            cell.backgroundColor = UIColor.lightGray
            cell.backgroundColor = UIColor.gray

//            cell.productNameLabel.textColor = UIColor.black
//            cell.noOfSupplierLabel.textColor = UIColor.black
            cell.productNameLabel.textColor = UIColor.white
            cell.noOfSupplierLabel.textColor = UIColor.white
//            print("nor: \(indexPath.section)")
        }
        

//            cell.updateConstraints()
//        cell.selectionStyle = .none

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        print(checkPurchaseSearchDataArray[indexPath.row].productName ?? "")
        checkPurchaseSearchPassData.passedProductName = checkPurchaseSearchDataArray[indexPath.row].productName
        
        let sdsJump = self.storyboard?.instantiateViewController(withIdentifier: "SupplierPage") as? CheckPurchaseTablePage_VC
        self.navigationController?.pushViewController(sdsJump!, animated: true)
    
//
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        
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
