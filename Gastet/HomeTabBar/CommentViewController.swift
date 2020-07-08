//
//  CommentViewController.swift
//  Gastet
//
//  Created by Ximena Flores de la Tijera on 11/21/18.
//  Copyright © 2018 ximeft29. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CommentViewController: UIViewController {

    
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintToBottom: NSLayoutConstraint!
    
    //Vars
    var postId: String!
    var postIdNew : String!
    var comments = [Comment]()
    var users = [UserProfile]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //title
        title = "Comentarios"
        
        sendButton.isEnabled = false
        
        //functions
        handleTextField()
        loadComments()
        empty()
        
        //tableView
        tableView.dataSource = self
        tableView.estimatedRowHeight = 77
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil )
        
             NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil )
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        
        print(notification)
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        print(keyboardFrame!)
        UIView.animate(withDuration: 0.3) {
            self.constraintToBottom.constant = -(keyboardFrame!.height)
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        
        print(notification)
        UIView.animate(withDuration: 0.3) {
            self.constraintToBottom.constant = 0
            self.view.layoutIfNeeded()
        }
        
    }
    
    func loadComments() {
        
        let postCommentRef = Database.database().reference().child("post-comments").child(self.postIdNew)
        postCommentRef.observe(.childAdded) { (snapshot) in
            print("observe key")
            print(snapshot.key)
            Database.database().reference().child("comments").child(snapshot.key).observeSingleEvent(of: .value, with: { (snapshotComment) in
                print(snapshotComment.value!)
                
                if let dict = snapshotComment.value as? [String: Any] {
                    
                    let newComment = Comment.transformComment(dict: dict)
                    self.fetchUser(userid: newComment.userid!, completed: {
                        self.comments.append(newComment)
                        self.tableView.reloadData()
                    })
                }
            })
        }
    }
    
    func fetchUser(userid: String, completed:  @escaping ()-> Void ) {
        
        Database.database().reference().child("users").child(userid).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let user = UserProfile.transformUser(dict: dict)
                self.users.insert(user, at: 0)
                completed()
            }
        }
        
    }
    
    func handleTextField() {
        
        commentTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
    }
    
    @objc func textFieldDidChange() {
        
        if let commentText = commentTextField.text , !commentText.isEmpty {
            sendButton.setTitleColor(UIColor(displayP3Red: 190/255, green: 126/255, blue: 57/255, alpha: 1), for: UIControlState.normal)
            self.sendButton.isEnabled = true
            return
        }
        
        sendButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        self.sendButton.isEnabled = false
        
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        
        let ref = Database.database().reference()
        let commentsReference = ref.child("comments")
        let newCommentId = commentsReference.childByAutoId().key
        let newCommentReference = commentsReference.child(newCommentId!)
        
        //current user information
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        let currentUserId = currentUser.uid
        newCommentReference.setValue(["userid": currentUserId, "commentText": commentTextField.text!]) { (error, ref) in
            
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
                }
            
            let postCommentRef = Database.database().reference().child("post-comments").child(self.postIdNew).child(newCommentId!)
            postCommentRef.setValue(true, withCompletionBlock: { (error, ref) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
            })
            self.empty()
            self.view.endEditing(true)
        }
    }
    
    func empty() {
        self.commentTextField.text = ""
        self.sendButton.isEnabled = false
        self.sendButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
    }

}

extension CommentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentsCell", for: indexPath) as! CommentTableViewCell
        let comment = comments[indexPath.row]
        let user = users[indexPath.row]
        cell.comment = comment
        cell.user = user
        return cell

    }
}
