//
//  tabBarViewController.swift
//  messageApp
//
//  Created by Shota Ishii on 2020/04/22.
//  Copyright © 2020 is. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class tabBarViewController: UITabBarController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser == nil{
            let first = self.storyboard?.instantiateViewController(withIdentifier: "first")
            self.present(first!,animated: true,completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
