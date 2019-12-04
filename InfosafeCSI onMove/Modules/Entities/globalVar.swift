//
//  globalVar.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 10/5/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import Foundation
import UIKit

struct outLoginData: Codable {
    var apptype: Int!
    var clientcode: String!
    var clientid: String!
    var clientlogo: String!
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
    static var clientlogo: String!
    static var clientmemberid: String!
    static var infosafeid: String!
    static var clientfirstname: String!
    static var clientsurname: String!
    static var clientloginstatus: String!
    static var apptype: Int!
    static var error: String!
}

struct localclientcoreData {
    static var username: String = "Username"
    static var password: String = "Password"
    static var image: String = "Image"
    static var remeberstatus: Bool = false
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
    static var supSearchValue: String!
    static var pcodeSearchValue: String!
    
    //multi-search test
    static var type1: String!
    static var type2: String!
    static var type3: String!
    
    static var value1: String!
    static var value2: String!
    static var value3: String!
}


struct localsearchinfo {
    var pcount: Int!
    var ocount: Int!
    var lcount: Int!
    var pageno: Int!
    var result: Bool!
    var pagecount: Int!
    var totalcount: Int!
    
    static var results: [item] = []
    
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
        var prodcode: String!
        var dgclass: String!
        var GHS_Pictogram: String!
        var Com_Country: String!
        var haz: String!
        var ufs: [uf]!
        
        init(sdsno: String? = nil, synno: String? = nil, company: String? = nil, issueDate: String? = nil, prodname: String? = nil, prodtype: String? = nil, ispartial: Bool? = nil, ps: String? = nil, unno: String? = nil, subrisk1: String? = nil, prodcode: String? = nil, dgclass: String? = nil, haz: String? = nil, GHS_Pictogram: String? = nil, Com_Country: String? = nil, ufs: [uf]? = nil) {
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
            self.prodcode = prodcode
            self.dgclass = dgclass
            self.haz = haz
            self.GHS_Pictogram = GHS_Pictogram
            self.Com_Country = Com_Country
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
    init(pcount: Int? = nil, ocount: Int? = nil, lcount: Int? = nil, pageno: Int? = nil, result: Bool? = nil, pagecount: Int? = nil, totalcount: Int? = nil, results: [item]? = nil) {
        self.pcount = pcount
        self.ocount = ocount
        self.lcount = lcount
        self.pageno = pageno
        self.result = result
        self.pagecount = pagecount
        self.totalcount = totalcount
//        self.results = results
    }

    
    
    // set the text and value to amount labels
    static var details: String!
    static var pamount: String!
    static var lamount: String!
    static var oamount: String!
    static var pagenoamount: String!
    
    static var totalamount: String!
    
    
    static var psize: Int!
    static var cpage: Int!
    
    static var totalPage: Int!
}

//struct localtablesize {
//    static var tableHeight: CGFloat!
//}

//struct localErrorCheck {
//    var searchReturn: Bool?
//
//    init() {
//        searchReturn = false
//    }
//
//    init(searchReturn: Bool) {
//        self.searchReturn = searchReturn
//    }
//}


struct localcurrentSDS {
    static var sdsNo: String!
    static var sdsRowNo: Int!
    static var pdfData: Data!
}

struct localDeafultData {
    static var sdsNo: String!
}

struct localSearchData {
    
    var company: String?
    var issueDate: String?
    var prodname: String?
    var prodtype: String?

    var ps: String?
    var unno: String?

    var prodcode: String?
    var dgclass: String?
    var haz: String?
    
    var GHS_Pictogram: String?
    var Com_Country: String?
    
    init() {
        company = ""
        issueDate = ""
        prodcode = ""
        prodname = ""
        prodtype = ""
        ps = ""
        unno = ""
        dgclass = ""
        haz = ""
        GHS_Pictogram = ""
        Com_Country = ""
    }
    
    init(company: String, issueDate: String, prodcode: String, prodname: String, prodtype: String, ps: String, unno: String, dgclass: String, haz: String, GHS_Pictogram: String, Com_Country: String){
        self.company = company
        self.issueDate = issueDate
        self.prodcode = prodcode
        self.prodtype = prodtype
        self.prodname = prodname
        self.ps = ps
        self.unno = unno
        self.dgclass = dgclass
        self.haz = haz
        self.GHS_Pictogram = GHS_Pictogram
        self.Com_Country = Com_Country
    }
}

struct localPDF {
    var sdsno: String?
    var pdfdata: String?
    
    init() {
        sdsno = ""
        pdfdata = ""
    }
    
    init(sdsno: String, pdfdata: String) {
        self.sdsno = sdsno
        self.pdfdata = pdfdata
    }
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
    var pdfString: String!
}

struct localViewSDSCore {
    static var company: String!
    static var dg: String!
    static var emcont: String!
    static var expirydate: String!
    static var hs: String!
    static var issuedate: String!
    static var prodcode: String!
    static var prodname: String!
    static var ps: String!
    static var recomuse: String!
    static var sds: String!
    static var unno: String!
}

struct outViewSDSCore: Codable {
    var company: String!
    var dg: String!
    var emcont: String!
    var expirydate: String!
    var hs: String!
    var issuedate: String!
    var prodcode: String!
    var prodname: String!
    var ps: String!
    var recomuse: String!
    var sds: String!
    var unno: String!
}

struct localViewSDSGHS {
    static var classification: String!
    static var dg: String!
    static var formatcode: String!
    static var hstate: String!
    static var ps: String!
    static var pstate: String!
    static var pic: String!
    static var rphrase: String!
    static var sds: String!
    static var sphrase: String!
    static var picArray: Array<Any>!
    static var ps_disposal: String!
    static var ps_general: String!
    static var ps_prevention: String!
    static var ps_response: String!
    static var ps_storage: String!

}

struct localViewSDSCF {
    static var classification: String!
    static var dg: String!
    static var formatcode: String!
    static var hstate: String!
    static var pic: String!
    static var ps: String!
    static var rphrase: String!
    static var sds: String!
    static var sphrase: String!
}

struct outViewSDSGHS: Codable {
    var classification: String!
    var dg: String!
    var formatcode: String!
    var hstate: String!
    var ps: String!
    var pstate: String!
    var pic: String!
    var rphrase: String!
    var sds: String!
    var sphrase: String!
    var ps_disposal: String!
    var ps_general: String!
    var ps_prevention: String!
    var ps_response: String!
    var ps_storage: String!
    
    
}

struct localViewSDSFA {
    static var sds: String!
    static var inhalation: String!
    static var ingestion: String!
    static var skin: String!
    static var eye: String!
    static var fafacilities: String!
    static var advdoctor: String!
}

struct outViewSDSFA: Codable {
    var sds: String!
    var inhalation: String!
    var ingestion: String!
    var skin: String!
    var eye: String!
    var fafacilities: String!
    var advdoctor: String!
}

struct localViewSDSTIADG {
    static var road_unno: String!
    static var road_dgclass: String!
    static var road_subrisks: String!
    static var road_packgrp: String!
    static var road_psn: String!
    static var road_hazchem: String!
    static var road_epg: String!
    static var road_ierg: String!
    static var road_packmethod: String!
}

struct localViewSDSTIIMDG {
    static var imdg_unno: String!
    static var imdg_dgclass: String!
    static var imdg_subrisks: String!
    static var imdg_packgrp: String!
    static var imdg_psn: String!
    static var imdg_ems: String!
    static var imdg_mp: String!
}

struct localViewSDSTIIATA {
    static var iata_unno: String!
    static var iata_dgclass: String!
    static var iata_subrisks: String!
    static var iata_packgrp: String!
    static var iata_psn: String!
    static var iata_symbol: String!
}

struct outViewSDSTI: Codable {
    var sds: String!
    
    var road_unno: String!
    var road_dgclass: String!
    var road_subrisks: String!
    var road_packgrp: String!
    var road_psn: String!
    var road_hazchem: String!
    var road_epg: String!
    var road_ierg: String!
    var road_packmethod: String!
    
    var imdg_unno: String!
    var imdg_dgclass: String!
    var imdg_subrisks: String!
    var imdg_packgrp: String!
    var imdg_psn: String!
    var imdg_ems: String!
    var imdg_mp: String!
    
    var iata_unno: String!
    var iata_dgclass: String!
    var iata_subrisks: String!
    var iata_packgrp: String!
    var iata_psn: String!
    var iata_symbol: String!
   
}

struct localpictograms {
    var picID: String!
    var picName: String!
    var picCode: String!
    
    init(picID: String? = nil, picName: String? = nil, picCode: String? = nil) {
        self.picID = picID
        self.picName = picName
        self.picCode = picCode
    }
}


