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
    var issueDateArray = [String]()
    var issueDateValueArray = [String]()
    var sdsDataArray = [String]()
    var supplierFullDataValue = checkPurchaseSupplierData()
    var supplierFullData = [checkPurchaseSupplierData]()
    var sortedsupplierFullData = [checkPurchaseSupplierData]()
    
    @IBOutlet weak var supplierTableView: UITableView!
    @IBOutlet weak var loadmoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigationMultilineTitle()
        setNavigationbar()
        getSupplier()
        getData()
//        countSDS()
        
        //remove extra separator line in table view
        self.supplierTableView.tableFooterView = UIView()
        self.supplierTableView.tableFooterView?.backgroundColor = UIColor.clear
        
        checkPurchaseSearchPassData.loadBool = true
//        print("view did load \(checkPurchaseSearchPassData.loadBool)")
        
        self.navigationController?.navigationBar.isHidden = false
        self.loadmoreLabel.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        print("view will appear 1st: \(checkPurchaseSearchPassData.loadBool)")
        if checkPurchaseSearchPassData.loadBool == true {
            checkPurchaseSearchPassData.storedDataArray = localsearchinfo.results
            checkPurchaseSearchPassData.loadBool = false
        } else {
            localsearchinfo.results = checkPurchaseSearchPassData.storedDataArray
        }
//        print("view will appear 2nd: \(checkPurchaseSearchPassData.loadBool)")
        
        //unselect after returning back to this page
        if let indexPath = self.supplierTableView.indexPathForSelectedRow{             self.supplierTableView.deselectRow(at: indexPath, animated: animated)         }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupNavigationMultilineTitle()
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

            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18), .foregroundColor: UIColor.white]
        
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
        
//        for (key, value) in tableData {
//            tableDataValue.supplier = "\(key)"
//            tableDataValue.noOfSDS = "\(value)"
//            checkPurchaseSearchSupplierDataArray.append(tableDataValue)
//        }
        
    }
    
    func getData() {
        checkPurchaseSearchSupplierDataArray.removeAll()
        let matchProductName = checkPurchaseSearchPassData.passedProductName
        var issueDateRange: String = ""
        for (key, _) in tableData {
            let matchSupplier = "\(key)"
            sdsDataArray.removeAll()
            issueDateValueArray.removeAll()
            for i in 0..<localsearchinfo.results.count {
                if matchProductName == localsearchinfo.results[i].prodname && matchSupplier == localsearchinfo.results[i].company {
                    let issuedateValue = localsearchinfo.results[i].issueDate ?? ""
                    issueDateValueArray.append(issuedateValue)
                    
                    let sdsValue = localsearchinfo.results[i].sdsno ?? ""
                    sdsDataArray.append(sdsValue)
                }
            }
            
            //count how many unique SDS
//            let uniqueSDSCount = Array(Set(sdsDataArray))
            
//            tableDataValue.supplier = matchSupplier
//            tableDataValue.noOfSDS = String(uniqueSDSCount.count)
//            checkPurchaseSearchSupplierDataArray.append(tableDataValue)
            
            if issueDateValueArray.count > 1 {
//                print(issueDateValueArray)
//                print("first item is: \(issueDateValueArray.first ?? "")")
//                issueDateArray.append("multi")

                var issueDateRangeArray = [Int]()

                for i in 0..<issueDateValueArray.count {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    let date = dateFormatter.date(from: issueDateValueArray[i])
                    dateFormatter.dateFormat = "yyyy"
                    let date2 = Int(dateFormatter.string(from: date!)) ?? 0000
                    issueDateRangeArray.append(date2)
                }
                let minYear = issueDateRangeArray.min() ?? 0
                let maxYear = issueDateRangeArray.max() ?? 0
                issueDateRange = "\(minYear) - \(maxYear)"
                issueDateArray.append(issueDateRange)

            } else {
                issueDateRange = issueDateValueArray.first ?? ""
                issueDateArray.append(issueDateValueArray.first ?? "")
            }
            
            supplierFullDataValue.supplier = matchSupplier
            //count no of SDS
//            supplierFullDataValue.noOfSDS = uniqueSDSCount.count
            //changed to count the products
            supplierFullDataValue.noOfSDS = sdsDataArray.count
            supplierFullDataValue.issueDate = (issueDateRange)
            supplierFullData.append(supplierFullDataValue)

        }
        sortData()
    }
            
    // sort the no of SDS function (changed to sort no of the products)
    func sortData() {
//        print(supplierFullData)
        sortedsupplierFullData = supplierFullData.sorted {
            $0.noOfSDS > $1.noOfSDS
        }
    }

}

extension CheckPurchaseTablePage_VC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedsupplierFullData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: "checkBuyTableCell", for: indexPath) as! CheckPurchaseTableViewCell
        
        cell.supplierLabel.text = String(self.sortedsupplierFullData[indexPath.row].supplier)
        cell.noOfSDSLabel.text = "No. Of Products: \(String(self.sortedsupplierFullData[indexPath.row].noOfSDS ?? 0))"
        cell.issueDateLabel.text = "Issue Date: \(String(sortedsupplierFullData[indexPath.row].issueDate))"
        
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
        let matchSupplier = sortedsupplierFullData[indexPath.row].supplier
        
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
