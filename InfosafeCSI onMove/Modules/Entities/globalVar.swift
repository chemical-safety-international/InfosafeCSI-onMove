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
    static var apptype: Int!
}

struct csiclientsearchinfo {
    static var arrProductName: [String]!
    static var arrCompanyName: [String]!
    static var arrIssueData: [String]!
    static var arrDetail: [String]!
    static var arrNo: [String]!
    static var details: String!
}

struct csicriteriainfo {
    static var arrCode: [String] = []
    static var arrName: [String] = []
    static var code: String!
    
}

struct csicurrentSDS {
    static var sdsNo: String!
    static var sdsRowNo: Int!
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
    
    struct column: Codable{
        let checkbox: Int
        let display: Int
        let key: String
        let locked: String
        let name: String
        let order: String
        let tip: String
        let width: Int
    }
    struct data: Codable {
        
    }
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

struct ViewSDSData: Codable {
    var result: Bool!
    var CanPDF: Bool!
    var CanExcel: Bool!
    var html: String!
    var title: String!
    var format: String!
    var subResults: Bool!
    var hasSummary: Bool!
    var message: String!
    var html_0: String!
    var html_2: String!
    var html_4: String!
    var html_1: String!
    var html_3: String!
}
