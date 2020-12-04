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
    

    
    var checkPurchaseSearchDataArray : [checkPurchaseSearchData] = []
    var tableDataValue = checkPurchaseSearchData()
    var productNameArray = [String]()
    var tableData = [String: Int]()
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
        
        productNameTittleLbl.font = UIFont.boldSystemFont(ofSize: 15)
        noOfSupplierTitleLbl.font = UIFont.boldSystemFont(ofSize: 13)
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
        
//        for i in 0..<localsearchinfo.results.count {
//            let productNameData = localsearchinfo.results[i].prodname ?? ""
//            productNameArray.append(productNameData)
//        }
////        print(productNameArray)
//        
//        for i in productNameArray {
//            if tableData[i] == nil {
//                tableData[i] = 1
//            } else {
//                tableData[i]! += 1
//            }
//        }
//        print("collectionData: \(tableData)")
    
//        for (key, value) in tableData {
//            tableDataValue.productName = "\(key)"
//            tableDataValue.noOfSupplier = "\(value)"
//            checkPurchaseSearchDataArray.append(tableDataValue)
//        }
        
//        print("CheckPurchase SearchData Array: \(checkPurchaseSearchDataArray)")
        
        for i in 0..<localsearchinfo.results.count {
            let matchProductName = localsearchinfo.results[i].prodname
            supplierArray.removeAll()
            for i in 0..<localsearchinfo.results.count {
                if matchProductName?.lowercased() == localsearchinfo.results[i].prodname.lowercased() {
                    let supplier = localsearchinfo.results[i].company ?? ""
                    supplierArray.append(supplier)
                }
            }
            tableDataValue.productName = matchProductName
            tableDataValue.noOfSupplier = "\(supplierArray.count)"
            checkPurchaseSearchDataArray.append(tableDataValue)

        }
        
    }
    
    func sortProductName(updown: Bool) {
        checkPurchaseSearchDataArray.removeAll()
        
        if updown == true {
            for (key, value) in self.tableData.sorted(by: { $0.key < $1.key}) {
                tableDataValue.productName = "\(key)"
                tableDataValue.noOfSupplier = "\(value)"
                checkPurchaseSearchDataArray.append(tableDataValue)
            }
            checkPurchaseTableView.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            checkPurchaseTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            productNameUpdownValue = false
        } else if updown == false {
            for (key, value) in self.tableData.sorted(by: { $0.key > $1.key}) {
                tableDataValue.productName = "\(key)"
                tableDataValue.noOfSupplier = "\(value)"
                checkPurchaseSearchDataArray.append(tableDataValue)
            }
            checkPurchaseTableView.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            checkPurchaseTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            productNameUpdownValue = true
        }
        
    }
    
    func sortNoOfSupplier(updown: Bool) {
        checkPurchaseSearchDataArray.removeAll()
        
        if (updown == true) {
            for (key, value) in self.tableData.sorted(by: { $0.value < $1.value}) {
                tableDataValue.productName = "\(key)"
                tableDataValue.noOfSupplier = "\(value)"
                checkPurchaseSearchDataArray.append(tableDataValue)
            }
            checkPurchaseTableView.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            checkPurchaseTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            noOfSupplierUpdownValue = false
        } else if (updown == false) {
            
            for (key, value) in self.tableData.sorted(by: { $0.value > $1.value}) {
                tableDataValue.productName = "\(key)"
                tableDataValue.noOfSupplier = "\(value)"
                checkPurchaseSearchDataArray.append(tableDataValue)
            }
            checkPurchaseTableView.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            checkPurchaseTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            noOfSupplierUpdownValue = true
        }

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
            
            cell.noOfSupplierLabel.text = self.checkPurchaseSearchDataArray[indexPath.row].noOfSupplier
            
            cell.backgroundColor = UIColor.darkGray

            cell.productNameLabel.textColor = UIColor.white
            cell.noOfSupplierLabel.textColor = UIColor.white

        } else if indexPath.row % 2 == 0 && indexPath.row != 0 {
            
            cell.productNameLabel.text = self.checkPurchaseSearchDataArray[indexPath.row].productName
            
            cell.noOfSupplierLabel.text = self.checkPurchaseSearchDataArray[indexPath.row].noOfSupplier
            
            cell.backgroundColor = UIColor.darkGray
            
            cell.productNameLabel.textColor = UIColor.white
            cell.noOfSupplierLabel.textColor = UIColor.white
            
//            print("%2: \(indexPath.section)")
            
        } else {
            cell.productNameLabel.text = self.checkPurchaseSearchDataArray[indexPath.row].productName
            cell.noOfSupplierLabel.text = self.checkPurchaseSearchDataArray[indexPath.row].noOfSupplier
            
            cell.backgroundColor = UIColor.lightGray

            cell.productNameLabel.textColor = UIColor.black
            cell.noOfSupplierLabel.textColor = UIColor.black
//            print("nor: \(indexPath.section)")
        }
        

//            cell.updateConstraints()

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        print(checkPurchaseSearchDataArray[indexPath.row].productName ?? "")
        checkPurchaseSearchPassData.passedProductName = checkPurchaseSearchDataArray[indexPath.row].productName
        
        let sdsJump = self.storyboard?.instantiateViewController(withIdentifier: "SupplierPage") as? CheckPurchaseTablePage_VC
        self.navigationController?.pushViewController(sdsJump!, animated: true)
    
//
    }
    
    
}
