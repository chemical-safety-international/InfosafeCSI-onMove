//
//  Menu_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 12/6/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

class Menu_VC: UIViewController {
    
    
    var buttonName = ["Core Info.", "Classification", "First Aid", "Transport", "View SDS"]
    var buttonImage = ["CSI-Core", "CSI-Class", "CSI-Aid", "CSI-Transport", "CSI-ViewSDS"]

    @IBOutlet weak var upImg: UIImageView!
    @IBOutlet weak var downImg: UIImageView!
    @IBOutlet weak var menuTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.menuTable.delegate = self
        self.menuTable.dataSource = self
        menuTable.separatorStyle = .none
        self.view.backgroundColor = UIColor.clear
        upImg.layer.cornerRadius = 5
        downImg.layer.cornerRadius = 5
        menuTable.layer.cornerRadius = 5
//        upImg.isHidden = true
//        downImg.isHidden = true


        // Do any additional setup after loading the view.
        menuTable.reloadData()
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


extension Menu_VC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return buttonName.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as? MenuTableViewCell
        
        cell?.btnLbl.text = buttonName[indexPath.row]
        cell?.btnImg.image = UIImage(named: buttonImage[indexPath.row])
        cell?.btnLbl.textColor = UIColor.white
        cell?.backgroundColor = UIColor.init(red: 0.10, green: 0.10, blue: 0.10, alpha: 0.7)
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return downImg
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return upImg
    }
    
}
