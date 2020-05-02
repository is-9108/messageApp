//
//  searchViewController.swift
//  messageApp
//
//  Created by Shota Ishii on 2020/05/02.
//  Copyright © 2020 is. All rights reserved.
//

import UIKit

class searchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    let users = [
        "aaa",
        "bbb",
        "ccc"
    ]
    
    var user:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self

    }

}

extension searchViewController:UITableViewDelegate{
    
}

extension searchViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        user.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friend")
        cell?.textLabel?.text = user[indexPath.row]
        return cell!
    }
    
    
}

extension searchViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        getUser(userName: searchBar.text!)
    }
    func getUser(userName:String){
        if userName != ""{
            user = users.filter{users in
                return users.contains(userName)
            } as Array
        }else{
            user = users
        }
        tableView.reloadData()
    }
}

