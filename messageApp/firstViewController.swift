
import UIKit
import Firebase
import FirebaseAuth


class firstViewController: UIViewController {
    
    @IBOutlet weak var mailAdress: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var signinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mailAdress.delegate = self
        password.delegate = self
        userName.delegate = self
       
        
        signinButton.isEnabled = false
        signinButton.backgroundColor = UIColor.orange.withAlphaComponent(0.5)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showKeybord), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeybord), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func showKeybord(notification: Notification){
        let keybordFlame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        
        guard let keybordMinY = keybordFlame?.minY else {return}
        let ButtonMaxY = signinButton.frame.maxY + 20
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        mailAdress.resignFirstResponder()
        password.resignFirstResponder()
        userName.resignFirstResponder()
        
        return true
    }

    @IBAction func signIn(_ sender: Any) {
        let mail:String! = mailAdress.text!
        let pass:String! = password.text!
        let name:String! = userName.text!
        
        Auth.auth().createUser(withEmail: mail, password: pass) {authResult,error in
            if let error = error{
                print("DEBUG_ERROR: " + error.localizedDescription)
                if error.localizedDescription == "The email address is badly formatted."{
                    print("adress")
                    let alert: UIAlertController = UIAlertController(title: "メールアドレスが正しくありません", message: nil, preferredStyle: .alert)
                    
                    let action:UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler:{
                        (action: UIAlertAction!) -> Void in
                        print("OK")
                    })
                    alert.addAction(action)
                    self.present(alert,animated: true,completion: nil)
                }else if error.localizedDescription == "The password must be 6 characters long or more."{
                    print("password")
                    let alert: UIAlertController = UIAlertController(title: "パスワードを６文字以上入力して下さい", message: nil, preferredStyle: .alert)
                    
                    let action:UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler:{
                        (action: UIAlertAction!) -> Void in
                        print("OK")
                    })
                    alert.addAction(action)
                    self.present(alert,animated: true,completion: nil)
                }
                
                return
            }else{
                
                var ref : DocumentReference? = nil
                let db = Firestore.firestore()
                ref = db.collection("users").addDocument(data: [
                    "name" : (self.userName.text)!,
                    "Email" : (mail)!,
                    "password" : (pass)!
                ])
            }
            
            print("DEBUG_PRINT: アカウント作成成功")
            
            let user = Auth.auth().currentUser
            if let user = user{
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = name
                changeRequest?.commitChanges{(error) in
                    if let error = error{
                        print("ERROR: " + error.localizedDescription)
                        return
                    }

                    print("DEBUG_PRINT:ユーザー名を\(user.displayName!)に設定成功")
                    let Chat = self.storyboard?.instantiateViewController(withIdentifier: "Chat") as! ChatViewController
                    self.present(Chat,animated: true,completion: nil)
                }
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension firstViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let emailBool = mailAdress.text?.isEmpty ?? true
        let passwordBool = password.text?.isEmpty ?? true
        let userNameBool = userName.text?.isEmpty ?? true
        
        if emailBool || passwordBool || userNameBool {
            signinButton.isEnabled = false
            signinButton.backgroundColor = UIColor.orange.withAlphaComponent(0.5)
        }else{
            signinButton.isEnabled = true
            signinButton.backgroundColor = UIColor.orange.withAlphaComponent(1)
        }
    }
}


