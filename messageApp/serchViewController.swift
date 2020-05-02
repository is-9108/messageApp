//
//  serchViewController.swift
//  messageApp
//
//  Created by Shota Ishii on 2020/05/02.
//  Copyright © 2020 is. All rights reserved.
//

import UIKit

class serchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var serchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var list = [
     "aa",
     "bb",
     "cc",
     "dd"
    ]
    
    var searchList:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        serchBar.delegate = self
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchItems(searchText: searchBar.text!)
    }
    
    func searchItems(searchText: String){
        if searchText != ""{
            searchList = list.filter{ list in return list.contains(searchText)} as Array
        }else{
            searchList = list
        }
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchList.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friend")
        cell?.textLabel?.text = searchList[indexPath.row]
        return cell!
    }

}



