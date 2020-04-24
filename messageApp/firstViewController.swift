
import UIKit
import Firebase
import FirebaseAuth

class firstViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var mailAdress: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var userName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mailAdress.delegate = self
        password.delegate = self
        userName.delegate = self
        
       
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
        if mailAdress.text == ""{
            print("メールアドレスを入力して下さい")
        }else if password.text == ""{
            print("パスワードを入力して下さい")
        }else if userName.text == ""{
            print("ユーザー名を入力して下さい")
        }
        
        Auth.auth().createUser(withEmail: mail, password: pass) {authResult,error in
            if let error = error{
                print("DEBUG_ERROR" + error.localizedDescription)
                return
            }
            print("DEBUG_PRINT:アカウント作成成功")
            
            let user = Auth.auth().currentUser
            if let user = user{
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = name
                changeRequest?.commitChanges{(error) in
                    if let error = error{
                        print("DEBUG_PRINT" + error.localizedDescription)
                        return
                    }

                    print("DEBUG_PRINT:ユーザー名を\(user.displayName!)に設定成功")
                    let message = self.storyboard?.instantiateViewController(withIdentifier: "message") as! messageViewController
                    self.present(message,animated: true,completion: nil)
                }
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
