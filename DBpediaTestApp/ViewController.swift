//
//  ViewController.swift
//  DBpediaTestApp
//
//  Created by 仲西 渉 on 2016/09/22.
//  Copyright © 2016年 nwatabou. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SPARQLDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //var myTableView: UITableView!
    @IBOutlet weak var myTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
    
    
        //get Open Data by SPARQL
        /*
        let query =
            "prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>\n"
          + "prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n"
          + "\n"
          + "select ?name ?img {"
          + " ?uri <http://schema.org/image> ?img;"
          + " rdf:type <http://purl.org/jrrk#CivicPOI>;"
          + " rdfs:label ?name."
          + "} limit 10"
        */
        
        //let query = "select distinct ?label where { <http://ja.dbpedia.org/resource/大阪府> <http://ja.dbpedia.org/property/隣接都道府県> ?pref.?pref <http://www.w3.org/2000/01/rdf-schema#label> ?label.  }"
        
        let query = "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> PREFIX dbpedia-ja: <http://ja.dbpedia.org/resource/> PREFIX prop-ja: <http://ja.dbpedia.org/property/> SELECT DISTINCT ?lable WHERE { dbpedia-ja:高槻市 prop-ja:隣接自治体  ?city . ?city rdfs:label ?lable . }"
        
        print("sparql呼び出し完了")
        
        SPARQL().query(query: query, delegate: self)
    }
    
    var data: Array<Dictionary<String, String>>!
    func parsed(data: Array<Dictionary<String, String>>) {
        self.data = data

        myTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected: \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as UITableViewCell
        var obj = data[indexPath.row]
        print(obj)

        cell.textLabel!.text = obj["lable"]
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

