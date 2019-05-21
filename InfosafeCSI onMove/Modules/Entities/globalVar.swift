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

struct csicriteriainfo {
    static var arrCode: [String]!
    static var arrName: [String]!
}

struct csicurrentSDS {
    static var sdsNo: String!
    static var sdsRowNo: Int!
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

struct SearchData: Codable {
    
    var column: [String]!
    var data: [String]!
    var result: Bool!
    var size: Int!
    var no: Int!
    var pagecount: Int!
    var count: Int!
    var list: Int!
    var pcount: Int!
    var lcount: Int!
    var ocount: Int!
    var acount: Int!
    var order: String!
    var desc: String!
    var showachive: String!
    
}

struct CriteriaData: Codable {
    struct items : Codable {
        let code: String
        let name: String
    }
    let items: [items]!
}
