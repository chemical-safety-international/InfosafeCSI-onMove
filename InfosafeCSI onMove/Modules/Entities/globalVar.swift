//
//  globalVar.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 10/5/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import Foundation

struct outLoginData: Codable {
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

struct localclientinfo {
    static var clientid: String!
    static var clientcode: String!
    static var clientmemberid: String!
    static var infosafeid: String!
    static var clientfirstname: String!
    static var clientsurname: String!
    static var clientloginstatus: String!
    static var apptype: Int!
}

struct outCriteriaData: Codable {
    struct items : Codable {
        let code: String
        let name: String
    }
    let items: [items]!
}

struct localcriteriainfo {
    static var arrCode: [String] = []
    static var arrName: [String] = []
    static var code: String!
}

struct localsearchinfo {
    static var arrProductName: [String]!
    static var arrCompanyName: [String]!
    static var arrIssueDate: [Any]!
    static var arrDetail: [String]!
    static var arrNo: [String]!
    static var details: String!
}

struct localcurrentSDS {
    static var sdsNo: String!
    static var sdsRowNo: Int!
}

struct outViewSDSData: Codable {
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
    var BinaryData: [UInt8]!
    var Base64String: String!
}
