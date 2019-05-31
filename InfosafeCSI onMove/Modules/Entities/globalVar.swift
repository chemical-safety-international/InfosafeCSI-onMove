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
    static var error: String!
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
    static var pickerValue: String!
    static var searchValue: String!
}



struct localsearchinfo {
     var pcount: Int!
     var ocount: Int!
     var lcount: Int!
     var pageno: Int!
    
    static var results: [item]!
    
    struct item {

        var sdsno: String!
        var synno: String!
        var company: String!
        var issueDate: String!
        var prodname: String!
        var prodtype: String!
        var ispartial: Bool!
        var ps: String!
        var unno: String!
        var subrisk1: String!
        var ufs: [uf]!
        
        init(sdsno: String? = nil, synno: String? = nil, company: String? = nil, issueDate: String? = nil, prodname: String? = nil, prodtype: String? = nil, ispartial: Bool? = nil, ps: String? = nil, unno: String? = nil, subrisk1: String? = nil, ufs: [uf]? = nil) {
            self.sdsno = sdsno
            self.synno = synno
            self.company = company
            self.issueDate = issueDate
            self.prodname = prodname
            self.prodtype = prodtype
            self.ispartial = ispartial
            self.ps = ps
            self.unno = unno
            self.subrisk1 = subrisk1
            self.ufs = ufs
        }
    }
    struct uf {
        var uftitle: String!
        var uftext: String!
        
        init(uftitle: String? = nil, uftext: String? = nil) {
            self.uftitle = uftitle
            self.uftext = uftext
        }
    }
    init(pcount: Int? = nil, ocount: Int? = nil, lcount: Int? = nil, pageno: Int? = nil, results: [item]? = nil) {
        self.pcount = pcount
        self.ocount = ocount
        self.lcount = lcount
        self.pageno = pageno
//        self.results = results
    }

    
    
    // old methods arrays
    static var details: String!
    static var pdetails: String!
}


var resultData: localsearchinfo!

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
