//
//  SearchSelection_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 20/11/20.
//  Copyright © 2020 Chemical Safety International. All rights reserved.
//

import UIKit

class SearchSelection_VC: UIViewController {

    @IBOutlet weak var goSearchPageButton: UIButton!
    @IBOutlet weak var goCheckBeforeYouPurchaseButton: UIButton!
    @IBOutlet weak var logOffButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setButtonsStyle()
        
        self.navigationItem.title = "Search Selection"
    }
    
    func setButtonsStyle() {
        logOffButton.layer.cornerRadius = 5
        goSearchPageButton.layer.cornerRadius = 18
        goCheckBeforeYouPurchaseButton.layer.cornerRadius = 18
    }
    
    @IBAction func goSearchPageButtonTapped(_ sender: Any) {
        let searchPage = self.storyboard?.instantiateViewController(withIdentifier: "SearchPage") as? SearchPage_VC
        self.navigationController?.pushViewController(searchPage!, animated: true)
    }
    
    
    @IBAction func goCheckBeforeYouPurchaseButtonTapped(_ sender: Any) {
        let checkPurchaseSearchPage = self.storyboard?.instantiateViewController(withIdentifier: "CheckPurchasePage") as? CheckPurchaseSearchPage_VC
        self.navigationController?.pushViewController(checkPurchaseSearchPage!, animated: true)
    }
    
    @IBAction func logOffButtonTapped(_ sender: Any) {
        
    }
    
    //hide the navigation bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = false

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
