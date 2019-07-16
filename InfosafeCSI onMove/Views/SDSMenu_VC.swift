//
//  Menu_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 12/6/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

class SDSMenu_VC: UIViewController {
    
    
//    var buttonName = [" ", "Core Info.", "Classification", "First Aid", "Transport", "View SDS"]
//    var buttonImage = ["menu-close-cross", "CSI-Core", "CSI-Class", "CSI-Aid", "CSI-Transport", "CSI-ViewSDS"]
    
    var buttonName = ["View SDS", "Core Info.", "Classification", "First Aid", "Transport"]
    var buttonImage = ["CSI-ViewSDS", "CSI-Core", "CSI-Class", "CSI-Aid", "CSI-Transport"]
    
    var timerForShowScrollIndicator: Timer?

    @IBOutlet weak var menuTable: UITableView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var menuView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuView.layer.cornerRadius = 10
        menuView.backgroundColor = UIColor.init(red: 0.10, green: 0.10, blue: 0.10, alpha: 0.7)
        
        self.menuTable.delegate = self
        self.menuTable.dataSource = self
        
        //remove the line between each cell
        menuTable.separatorStyle = .none
        self.view.backgroundColor = UIColor.clear
        
        //change menu table indicator color
        menuTable.indicatorStyle = UIScrollView.IndicatorStyle.white

        // Do any additional setup after loading the view.
        menuTable.reloadData()
        

    }


    override func viewDidAppear(_ animated: Bool) {
        startTimerForShowScrollIndicator()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        stopTimerForShowScrollIndicator()
    }
    
    @objc func showScrollIndicatorsInContacts() {
        UIView.animate(withDuration: 0.001) {
            self.menuTable.flashScrollIndicators()
        }
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let verticalIndicator = scrollView.subviews.last as? UIImageView
//        verticalIndicator?.backgroundColor = UIColor.white
//    }
    
    func startTimerForShowScrollIndicator() {
        self.timerForShowScrollIndicator = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.showScrollIndicatorsInContacts), userInfo: nil, repeats: true)
    }
    
    func stopTimerForShowScrollIndicator() {
        self.timerForShowScrollIndicator?.invalidate()
        self.timerForShowScrollIndicator = nil
    }
    
    
    
    func menuFunction(index: Int) {
        if buttonName[index] == "View SDS" {
            let sdsJump = storyboard?.instantiateViewController(withIdentifier: "SDSView") as? SDSViewPage_VC
            self.navigationController?.pushViewController(sdsJump!, animated: true)
        }
    
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil)
    }
    
}


extension SDSMenu_VC : UITableViewDelegate, UITableViewDataSource {
    
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
        cell?.backgroundColor = UIColor.clear

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        menuFunction(index: indexPath.row)
    }
    
    func tableScrollDisable() {
        menuTable.isScrollEnabled = false
    }
    func tableScrollEnable() {
        menuTable.isScrollEnabled = true
    }
    
}
