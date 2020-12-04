//
//  CheckBuyTablePage_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 17/11/20.
//  Copyright © 2020 Chemical Safety International. All rights reserved.
//

import UIKit

class CheckPurchaseTablePage_VC: UIViewController {

    var supplierArray = [String]()
    var tableData = [String: Int]()
    var tableDataValue = checkPurchaseSearchSupplierData()
    var checkPurchaseSearchSupplierDataArray: [checkPurchaseSearchSupplierData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavigationbar()
        getSupplier()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setNavigationbar() {
//        //change background color
//        DispatchQueue.main.async {
//
//            //change background color & back button color
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.barTintColor = UIColor(red:0.25, green:0.26, blue:0.26, alpha:1.0)
            self.navigationController?.navigationBar.tintColor = UIColor.white

//            //change navigation bar text color and font

            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25), .foregroundColor: UIColor.white]
            self.navigationItem.title = checkPurchaseSearchPassData.passedProductName
               
//        }
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
        
        for (key, value) in tableData {
            tableDataValue.supplier = "\(key)"
            tableDataValue.noOfSDS = "\(value)"
            checkPurchaseSearchSupplierDataArray.append(tableDataValue)
        }
        
    }

}

extension CheckPurchaseTablePage_VC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkPurchaseSearchSupplierDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: "checkBuyTableCell", for: indexPath) as! CheckPurchaseTableViewCell
        
        cell.supplierLabel.text = self.checkPurchaseSearchSupplierDataArray[indexPath.row].supplier
        cell.noOfSDSLabel.text = "No of SDS: \( self.checkPurchaseSearchSupplierDataArray[indexPath.row].noOfSDS ?? "")"
        
        cell.supplierLabel.textColor = UIColor.white
        cell.noOfSDSLabel.textColor = UIColor.white

            
            return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}
