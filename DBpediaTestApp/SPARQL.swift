//
//  SPARQL.swift
//  DBpediaTestApp
//
//  Created by 仲西 渉 on 2016/09/22.
//  Copyright © 2016年 nwatabou. All rights reserved.
//

import Foundation

protocol SPARQLDelegate {
    func parsed(data: Array<Dictionary<String, String>>)
}


class SPARQL: NSObject, XMLParserDelegate {
    var data: Array<Dictionary<String, String>> = Array<Dictionary<String, String>>()
    var temp: Dictionary<String, String> = Dictionary<String, String>()
    var tempname: String = ""
    var flg = false
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "uri" || elementName == "literal" {
            flg = true
        }
        
        if elementName == "result" {
            temp = [:]
            
        }
        
        if elementName == "binding" {
            tempname = attributeDict["name"]! as String
            print("tempname:\(tempname)")
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "result" {
            data.append(temp)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if flg {
            temp[tempname] = string
            flg = false
            print("string:\(string)")
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        delegate.parsed(data: data)
    }
    
    var delegate: SPARQLDelegate!
    
    func query(query: String, delegate: SPARQLDelegate) {
        var url = "http://ja.dbpedia.org/sparql"
        url += "?output=xml&app=dev1&query=" + query.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!
        
        
        let xmlURL:NSURL = NSURL(string: url)!
        
        let parser = XMLParser(contentsOf: xmlURL as URL)
        parser?.delegate = self
        self.delegate = delegate
        parser?.parse()
        
        print("parser終了")
    }
    
    
}
