
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase



class messageViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var messageTextfield: UITextField!
    
    @IBOutlet weak var talkTextView: UITextView!
    
    var ref: DatabaseReference!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            print("userName\((Auth.auth().currentUser)!)")
            print("login")
                  userName.text = "name:\((Auth.auth().currentUser?.displayName)!)"
        } else {
            print("no")
            let first = self.storyboard?.instantiateViewController(withIdentifier: "first")
            self.present(first!,animated: true,completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTextfield.delegate = self
        talkTextView.isEditable = false
        talkTextView.isSelectable = false

        ref = Database.database().reference().child("chat")
        ref.observe(.childAdded, with: { (snapshot) -> Void in
            if let data = snapshot.value as? Dictionary<String, AnyObject>{
                if let name = data["name"], let comment = data["comment"] {
                    self.talkTextView.text += "\(name):\(comment)\n"
                return
                }
            }
        })
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageTextfield.resignFirstResponder()
        return true
    }
    

    @IBAction func send(_ sender: Any) {
        ref = Database.database().reference()
        let data = [
            "name" : Auth.auth().currentUser?.displayName!,
            "comment" : messageTextfield.text!
        ]
        ref.child("chat").childByAutoId().setValue(data)
        messageTextfield.text = ""
    }
    
    
}
