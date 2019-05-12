//
//  globalVar.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 10/5/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import Foundation

class loginVar {
    var statusBool: Bool
    var client: String
    var clientmemberid: String
    var infosafeid: String
    init(statusBool: Bool, client: String, clientmemberid: String, infosafeid: String) {
        self.statusBool = statusBool
        self.client = client
        self.clientmemberid = clientmemberid
        self.infosafeid = infosafeid
    }

}

var loginVarStatus = loginVar(statusBool: false, client: "", clientmemberid: "", infosafeid: "")
