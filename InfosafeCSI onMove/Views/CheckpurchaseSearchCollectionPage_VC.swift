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
    var collectionDataValue = checkPurchaseSearchData()
    var productNameArray = [String]()
    var collectionData = [String: Int]()
    var collectionSortedData = [String: Int]()
    
    var productNameUpdownValue: Bool = true
    var noOfSupplierUpdownValue: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    }
    
    func addData() {
        
        for i in 0..<localsearchinfo.results.count {
            let productNameData = localsearchinfo.results[i].prodname ?? ""
            productNameArray.append(productNameData)
        }
//        print(productNameArray)
        
        for i in productNameArray {
            if collectionData[i] == nil {
                collectionData[i] = 1
            } else {
                collectionData[i]! += 1
            }
        }
        print("collectionData: \(collectionData)")
        
        
        for (key, value) in collectionData {
            collectionDataValue.productName = "\(key)"
            collectionDataValue.noOfSupplier = "\(value)"
            checkPurchaseSearchDataArray.append(collectionDataValue)
        }
        
//        print("CheckPurchase SearchData Array: \(checkPurchaseSearchDataArray)")
    }
    
    func sortProductName(updown: Bool) {
        checkPurchaseSearchDataArray.removeAll()
        
        if updown == true {
            for (key, value) in self.collectionData.sorted(by: { $0.key < $1.key}) {
                collectionDataValue.productName = "\(key)"
                collectionDataValue.noOfSupplier = "\(value)"
                checkPurchaseSearchDataArray.append(collectionDataValue)
            }
            checkPurchaseTableView.reloadData()
            checkPurchaseTableView.setContentOffset(.zero, animated: true)
            productNameUpdownValue = false
        } else if updown == false {
            for (key, value) in self.collectionData.sorted(by: { $0.key > $1.key}) {
                collectionDataValue.productName = "\(key)"
                collectionDataValue.noOfSupplier = "\(value)"
                checkPurchaseSearchDataArray.append(collectionDataValue)
            }
            checkPurchaseTableView.reloadData()
            checkPurchaseTableView.setContentOffset(.zero, animated: true)
            productNameUpdownValue = true
        }
        

        print("sortProductname: \(checkPurchaseSearchDataArray)")
    }
    
    func sortNoOfSupplier(updown: Bool) {
        checkPurchaseSearchDataArray.removeAll()
        
        if (updown == true) {
            for (key, value) in self.collectionData.sorted(by: { $0.value < $1.value}) {
                collectionDataValue.productName = "\(key)"
                collectionDataValue.noOfSupplier = "\(value)"
                checkPurchaseSearchDataArray.append(collectionDataValue)
            }
            checkPurchaseTableView.reloadData()
            checkPurchaseTableView.setContentOffset(.zero, animated: true)
            noOfSupplierUpdownValue = false
        } else if (updown == false) {
            
            for (key, value) in self.collectionData.sorted(by: { $0.value > $1.value}) {
                collectionDataValue.productName = "\(key)"
                collectionDataValue.noOfSupplier = "\(value)"
                checkPurchaseSearchDataArray.append(collectionDataValue)
            }
            checkPurchaseTableView.reloadData()
            checkPurchaseTableView.setContentOffset(.zero, animated: true)
            noOfSupplierUpdownValue = true
        }

        print("sortNoOfSupplier: \(checkPurchaseSearchDataArray)")
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
    
    
}
