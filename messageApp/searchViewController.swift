//
//  searchViewController.swift
//  messageApp
//
//  Created by Shota Ishii on 2020/05/02.
//  Copyright © 2020 is. All rights reserved.
//

import UIKit
import Firebase

class searchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    var user:[String] = []
    
    let db = Firestore.firestore()
    
    var usersData:[String : Any] = [:]
    
    var usersName:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        db.collection("users").getDocuments(){ (QuerySnapshot, err) in
            if let err = err{
                print("error: \(err)")
            }else{
                for document in QuerySnapshot!.documents{
                    self.usersData = document.data()
                    let userName = self.usersData["name"] as! String
                    self.usersName.append(userName)
                 }
                print(self.usersName)
            }
        }

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
            user = usersName.filter{users in
                return users.contains(userName)
            } as Array
        }else{
            user = usersName
        }
        tableView.reloadData()
    }
}

