//
//  globalVar.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 10/5/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import Foundation



struct csiclientinfo {
    static var clientid: String!
    static var clientcode: String!
    static var clientmemberid: String!
    static var infosafeid: String!
    static var clientfirstname: String!
    static var clientsurname: String!
    static var clientloginstatus: String!
    
}

struct csiclientsearchinfo {
    static var arrName: [String]!
    static var arrDetail: [String]!
    static var arrNo: [String]!
    static var searchstatus: Bool!
}

struct csicurrentSDS {
    static var sdsNo: String!
}
