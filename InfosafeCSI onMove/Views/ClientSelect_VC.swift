//
//  ClientSelect_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 26/10/20.
//  Copyright © 2020 Chemical Safety International. All rights reserved.
//

import UIKit

class ClientSelect_VC: UIViewController {

    @IBOutlet weak var clientListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getClientList()
        
        NotificationCenter.default.addObserver(self, selector: #selector(jumpToSearchPage), name: NSNotification.Name("jumpToSearchPage"), object: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getClientList() {
        var clientList = localclientinfo.clientListItem()
        clientList.clientName = "BUREAU VERITAS ASSET INTEGRITY & RELIABILITY SERVICES PTY LIMITED"
        localclientinfo.clientList.append(clientList)
        clientList.clientName = "BOMBA"
        localclientinfo.clientList.append(clientList)
        clientList.clientName = "LAWSON RISK MANAGEMENT SERVICES PTY LTD"
        localclientinfo.clientList.append(clientList)
    }
    
    @objc func jumpToSearchPage() {
        print("reach jump to page")
        localclientinfo.clientid = "b2c0dd10-fe36-477d-b0dd-adbf3aa18b32"
        localclientinfo.infosafeid = "CSI_IT"
        let searchPage = storyboard?.instantiateViewController(withIdentifier: "SearchPage") as? SearchPage_VC
        self.navigationController?.pushViewController(searchPage!, animated: true)
        
    }

}

extension ClientSelect_VC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localclientinfo.clientList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "clientListCell", for: indexPath) as? ClientListTableViewCell
        
        if localclientinfo.clientList.isEmpty == false {
            cell?.clientSelectButton.setTitle(localclientinfo.clientList[indexPath.row].clientName, for: .normal)
        } else {
            
        }
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
