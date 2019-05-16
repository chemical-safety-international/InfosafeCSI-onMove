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

struct ViewSDSData: Codable {
    var result: String!
    var CanPDF: String!
    var CanExcel: String!
    var html: String!
    var title: String!
    var format: String!
    var subResults: String!
    var hasSummary: String!
    var message: String!
}

struct LoginData: Codable {
    var apptype: Int!
    var clientcode: String!
    var clientid: String!
    var clientmemberid: String!
    var error: String!
    var firstname: String!
    var infosafeid: String!
    var passed: Bool!
    var surname: String!
}
