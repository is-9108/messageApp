//
//  loginViewController.swift
//  messageApp
//
//  Created by Shota Ishii on 2020/04/27.
//  Copyright © 2020 is. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class loginViewController: UIViewController {

    @IBOutlet weak var EmailAdressTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            print("userName\((Auth.auth().currentUser)!)")
        } else {
            let first = self.storyboard?.instantiateViewController(withIdentifier: "first")
            self.present(first!,animated: true,completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EmailAdressTextField.delegate = self
        passwordTextField.delegate = self
        userNameTextField.delegate = self
        
        loginButton.isEnabled = false
        loginButton.backgroundColor = UIColor.orange.withAlphaComponent(0.5)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showKeybord), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeybord), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func showKeybord(notification: Notification){
        let keybordFlame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        
        guard let keybordMinY = keybordFlame?.minY else {return}
        let ButtonMaxY = loginButton.frame.maxY + 20
        let dinstance = keybordMinY - ButtonMaxY
        
        let transform = CGAffineTransform(translationX: 0, y: dinstance)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1,initialSpringVelocity: 1,options: [],animations: {
            self.view.transform = transform
        })
    }
    
    @objc func hideKeybord(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1,initialSpringVelocity: 1,options: [],animations: {
            self.view.transform = .identity
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func login(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: EmailAdressTextField.text!, password: passwordTextField.text!) { [weak self] authResult, error in
        if let error = error{
            print("error: " + error.localizedDescription)
            if error.localizedDescription == "The email address is badly formatted."{
                let alert = UIAlertController(title: "メールアドレスが正しくありません", message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: {
                    (action: UIAlertAction!) -> Void in
                    print("DEBUG_PRINT: mailadress wrong")
                })
                alert.addAction(action)
                self!.present(alert,animated: true, completion: nil)
            }else if error.localizedDescription == "The password is invalid or the user does not have a password."{
                    let alert = UIAlertController(title: "パスワードが正しくありません", message: nil, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .cancel, handler: {
                        (action: UIAlertAction!) -> Void in
                        print("DEBUG_PRINT: password wrong")
                    })
                    alert.addAction(action)
                    self!.present(alert,animated: true, completion: nil)
                }else if error.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted."{
                    let alert = UIAlertController(title: "アカウントが存在しません", message: nil, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .cancel, handler: {
                        (action: UIAlertAction!) -> Void in
                        print("DEBUG_PRINT: acount wrong")
                    })
                    alert.addAction(action)
                    self!.present(alert,animated: true, completion: nil)
                }
            }else{
                guard let strongSelf = self else { return }
                let chat = self?.storyboard?.instantiateViewController(identifier: "Chat") as! ChatViewController
                self?.present(chat,animated: true,completion: nil)
            }
        }
        
    }
    
}

extension loginViewController: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let emailBool = EmailAdressTextField.text?.isEmpty ?? true
        let passwordBool = passwordTextField.text?.isEmpty ?? true
        let userNameBool = userNameTextField.text?.isEmpty ?? true
        
        if emailBool || passwordBool || userNameBool {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.orange.withAlphaComponent(0.5)
        }else{
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.orange.withAlphaComponent(    1)
        }
    }
}
