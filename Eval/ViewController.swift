//
//  ViewController.swift
//  Eval
//
//  Created by Supinfo on 09/03/2018.
//  Copyright © 2018 IMIE. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
   
    let service = "http://ctexdev.net/arthur/Kaamelott/sound"

    var dataFull : [Any]?
    
    var data : [Any]? {
        didSet {
            DispatchQueue.main.async {
//                self.tableView.isHidden = false
//                self.wheel.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initList()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repliqueCell")
        
        let replique = self.data![indexPath.row] as! [String: String]
//        print(replique["character"] as! String)
//
        cell?.textLabel?.text = replique["title"]
        cell?.detailTextLabel?.text = "\(replique["character"]!) - \(replique["episode"]!)"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data != nil ? self.data!.count : 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let replique = self.data![indexPath.row] as! [String: String];
        let file = replique["file"]!;
        print(file);
        let link = "\(self.service)/\(file)"
        let url = URL(string: link)
        let request = URLRequest(url: url!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, resp, err) in
            Player.shared.playSound(data!)
        }
        task.resume()
    }
    
    func initList() {
        let file = "sounds.json"
        let link = "\(self.service)/\(file)"
        let url = URL(string: link)
        let request = URLRequest(url: url!)
        let session = URLSession.shared
        
        //        self.label.isHidden = true
//        self.tableView.isHidden = true
//        self.wheel.startAnimating()
        
        let task = session.dataTask(with: request) { (data, resp, err) in
            let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [Any]
            self.dataFull = json!
            self.data = json!
        }
        task.resume()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let recherche = searchBar.text
        if (recherche == "") { print("toto") }
        switch(searchBar.selectedScopeButtonIndex) {
        case 0:
            // Titre
            let tmp = self.dataFull?.filter({
                let d = $0 as! [String : String]
                return (d["title"]?.lowercased().contains(recherche!.lowercased()))!
            })
            tmp?.sorted(by: {
                let d = $0 as! [String : String]
                let d1 = $1 as! [String : String]
                return d["title"]! < d1["title"]!
            })
            self.data = tmp?.sorted(by: {
                let d = $0 as! [String : String]
                let d1 = $1 as! [String : String]
                return d["title"]! < d1["title"]!
            })
            break
        case 1:
            // Personnage
            let tmp = self.dataFull?.filter({
                let d = $0 as! [String : String]
                return (d["character"]?.lowercased().contains(recherche!.lowercased()))!
            })
            self.data = tmp?.sorted(by: {
                let d = $0 as! [String : String]
                let d1 = $1 as! [String : String]
                return d["character"]! < d1["character"]!
            })
            break
        case 2:
            // Episode
            let tmp = self.dataFull?.filter({
                let d = $0 as! [String : String]
                return (d["episode"]?.lowercased().contains(recherche!.lowercased()))!
            })
            self.data = tmp?.sorted(by: {
                let d = $0 as! [String : String]
                let d1 = $1 as! [String : String]
                return d["episode"]! < d1["episode"]!
            })
            break
        default:
            break
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        self.data = self.dataFull
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch(selectedScope) {
        case 0:
            // Titre
            self.data = self.data?.sorted(by: {
                let d = $0 as! [String : String]
                let d1 = $1 as! [String : String]
                return d["title"]! < d1["title"]!
            })
            break
        case 1:
            // Personnage
            self.data = self.data?.sorted(by: {
                let d = $0 as! [String : String]
                let d1 = $1 as! [String : String]
                return d["character"]! < d1["character"]!
            })
            break
        case 2:
            // Episode
            self.data = self.data?.sorted(by: {
                let d = $0 as! [String : String]
                let d1 = $1 as! [String : String]
                return d["episode"]! < d1["episode"]!
            })
            break
        default:
            break
        }
    }

}

