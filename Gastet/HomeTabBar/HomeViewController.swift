//
//  HomeViewController.swift
//  Gastet
//
//  Created by Ximena Flores de la Tijera on 5/4/18.
//  Copyright © 2018 ximeft29. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import SDWebImage
import Lottie

class HomeViewController: UIViewController{
    
    //VARS
    var posts = [Posts]()
    var newPostsFound = [Posts]()
    var postsadoption = [Posts]()
    var users = [UserProfile]()
    
    //Gradients
    let colorTop = UIColor(displayP3Red: 224/255, green: 181/255, blue: 107/255, alpha: 1)
    let colorDown = UIColor(displayP3Red: 190/255, green: 126/255, blue: 57/255, alpha: 1)

    
    //REFRESHERS
    var refresherLost: UIRefreshControl = UIRefreshControl()
    var refresherFound: UIRefreshControl = UIRefreshControl()
    var refresherAdoption: UIRefreshControl = UIRefreshControl()
    
    //@IBOUTLETS
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lostView: UIView!
    @IBOutlet weak var foundView: UIView!
    @IBOutlet weak var adoptionView: UIView!
    
    
    @IBOutlet weak var lostCollectionView: UICollectionView!
    @IBOutlet weak var foundCollectionView: UICollectionView!
    @IBOutlet weak var adoptionCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //LOST  UPDATE COLLECTIONVIEW
        scrollView.delegate = self
        lostCollectionView.delegate = self
        lostCollectionView.dataSource = self
        
        //FOUND UPDATE COLLECTIONVIEW
        scrollView.delegate = self
        foundCollectionView.delegate = self
        foundCollectionView.dataSource = self
        
        //ADOPTION UPDATE COLLECTIONVIEW
        scrollView.delegate = self
        adoptionCollectionView.delegate = self
        adoptionCollectionView.dataSource = self

        //Refresher
        refresherLost.addTarget(self, action: #selector(lostCollectionView.reloadData), for: UIControlEvents.valueChanged)
        lostCollectionView.addSubview(refresherLost)
        
        refresherFound.addTarget(self, action: #selector(foundCollectionView.reloadData), for: UIControlEvents.valueChanged)
        foundCollectionView.addSubview(refresherLost)
        
        refresherAdoption.addTarget(self, action: #selector(adoptionCollectionView.reloadData), for: UIControlEvents.valueChanged)
        adoptionCollectionView.addSubview(refresherLost)
        
        //Posts Functions
        observePostsLost()
        observePostsFound()
        observePostsAdoption()
        

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        //Posts Functions
        observePostsLost()
        observePostsFound()
        observePostsAdoption()
        
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    @IBAction func toGoogleMapsViewController(_ sender: UIButton) {
        
        performSegue(withIdentifier: "toGoogleMapView", sender: self)
    }
    

    @objc func observePostsLost() {
        activityIndicator.startAnimating()
        let postsRef = Database.database().reference().child("posts")
        postsRef.queryOrdered(byChild: "postType").queryEqual(toValue: "lost").observe(.value) { (snapshot) in
            var tempPost = [Posts]()
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot {
                    let dict = childSnapshot.value as? [String: Any]
                    let key = childSnapshot.key as String
                    let newLostPost = Posts.transformPost(dict: dict!, key: key)
                    
                    //This will look up all users at once
                    self.fetchUser(userid: newLostPost.userid!, completed: {
                        tempPost.insert(newLostPost, at: 0)
                        DispatchQueue.main.async {
                            self.posts = tempPost
                            self.posts.sort(by: { (p1, p2) -> Bool in
                                return p1.timestamp?.compare(p2.timestamp!) == .orderedDescending
                            })
                            self.activityIndicator.stopAnimating()
                            self.lostCollectionView.reloadData()
                            self.refresherLost.endRefreshing()
                        }
                    })
                }
            }
        }
    }
    
    @objc func observePostsFound() {
        let postsRef = Database.database().reference().child("posts")
        postsRef.queryOrdered(byChild: "postType").queryEqual(toValue: "found").observe(.value) { (snapshot) in
            var tempPost = [Posts]()
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot {
                    let dict = childSnapshot.value as? [String: Any]
                    let key = childSnapshot.key as String
                    let newFoundPost = Posts.transformPost(dict: dict!, key: key)
                    //This will look up all users at once
                    self.fetchUser(userid: newFoundPost.userid!, completed: {
                        
                        tempPost.insert(newFoundPost, at: 0)
                        DispatchQueue.main.async {
                            self.newPostsFound = tempPost
                            self.newPostsFound.sort(by: { (p1, p2) -> Bool in
                                return p1.timestamp?.compare(p2.timestamp!) == .orderedDescending
                            })
                            self.foundCollectionView.reloadData()
                            self.refresherFound.endRefreshing()
                        }
                    })
      
                }
            }
        }
    }

    
    @objc func observePostsAdoption() {
        let postsRef = Database.database().reference().child("posts")
        postsRef.queryOrdered(byChild: "postType").queryEqual(toValue: "adopt").observe(.value) { (snapshot) in
            var tempPost = [Posts]()
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot {
                    let dict = childSnapshot.value as? [String: Any]
                    let key = childSnapshot.key as String
                    let newAdoptiondPost = Posts.transformPost(dict: dict!, key: key)
                    //This will look up all users at once
                    
                    self.fetchUser(userid: newAdoptiondPost.userid!, completed: {
                        tempPost.insert(newAdoptiondPost, at: 0)
                            DispatchQueue.main.async {
                            self.postsadoption = tempPost
                            //esto es lo nuevo
                            self.postsadoption.sort(by: { (p1, p2) -> Bool in
                                    return p1.timestamp?.compare(p2.timestamp!) == .orderedDescending
                                })
                            self.adoptionCollectionView.reloadData()
                            self.refresherAdoption.endRefreshing()
                        }
                })
                }
            }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "commentSegue" {
            let commentVC = segue.destination as! CommentViewController
            let postId = sender as! String
            commentVC.postIdNew = postId
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//// START OF EXTENSIONS FOR COLLECTION VIEWS
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.lostCollectionView {

            return posts.count
        }
            
        if collectionView == self.foundCollectionView {
           
            return newPostsFound.count
            
        }
        
        if collectionView == self.adoptionCollectionView {
            
            return postsadoption.count
        }
        
        else {
            
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        
        case lostCollectionView:

            let lostcell: LostCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Lostcell", for: indexPath) as! LostCollectionViewCell

            let post = posts[indexPath.row]
            let user = users[indexPath.row]
            lostcell.post = post
            lostcell.user = user
            let postId = post.postid
            print("POSTID:" + postId!)

            //Make TextView Clickable
            lostcell.phoneLostTextView.isEditable = false;
            lostcell.phoneLostTextView.dataDetectorTypes = UIDataDetectorTypes.phoneNumber
            
            //Make Comments View Clickable
            lostcell.homeVC = self
            
            //Gradient
            lostcell.commentsView.setGradientBackground(colorOne: colorTop, colorTwo: colorDown)
            
            return lostcell


        case foundCollectionView:
            let foundcell: FoundCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Foundcell", for: indexPath) as! FoundCollectionViewCell

            let post = newPostsFound[indexPath.row]
            let user = users[indexPath.row]
            foundcell.post = post
            foundcell.user = user
            
            //Make TextView Clickable
            foundcell.phoneFoundTextView.isEditable = false;
            foundcell.phoneFoundTextView.dataDetectorTypes = UIDataDetectorTypes.phoneNumber
            
            //Make Comments View Clickable
            foundcell.homeVC = self
            
            //Gradient
            foundcell.commentsView.setGradientBackground(colorOne: colorTop, colorTwo: colorDown)
            
            
            return foundcell
            
    
        case adoptionCollectionView:
            let adoptioncell: AdoptionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Adopotioncell", for: indexPath) as! AdoptionCollectionViewCell

            let post = postsadoption[indexPath.row]
            let user = users[indexPath.row]
            adoptioncell.post = post
            adoptioncell.user = user

            //Make TextView Clickable
            adoptioncell.phoneAdoptionTextView.isEditable = false;
            adoptioncell.phoneAdoptionTextView.dataDetectorTypes = UIDataDetectorTypes.phoneNumber
            
            //Make Comments View Clickable
            adoptioncell.homeVC = self
            
            //Gradient
            adoptioncell.commentsView.setGradientBackground(colorOne: colorTop, colorTwo: colorDown)
            
            
            return adoptioncell

        default:
            return UICollectionViewCell()
        }
    
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        func commentsViewPressed() {
            print("Comments view pressed")
            performSegue(withIdentifier: "commentSegue", sender: self)

        }
        
        switch collectionView {
        
        case lostCollectionView:

            let vc = storyboard?.instantiateViewController(withIdentifier: "lostSelectedViewController") as? LostSelectedViewController
            self.navigationController?.pushViewController(vc!, animated: true)
            vc?.posts = posts[indexPath.row]
            break
        
        case foundCollectionView:
           let vc = storyboard?.instantiateViewController(withIdentifier: "foundSelectedViewController") as? FoundSelectedViewController
           self.navigationController?.pushViewController(vc!, animated: true)
            vc?.posts = newPostsFound[indexPath.row]
            break

        case adoptionCollectionView:
            let vc = storyboard?.instantiateViewController(withIdentifier: "adoptionSelectedViewController") as? AdoptionSelectedViewController
            self.navigationController?.pushViewController(vc!, animated: true)
            vc?.posts = postsadoption[indexPath.row]
            break
        
        default:
            break
        }
    }

}

////SCROLL

extension  HomeViewController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView)
    }
    
}

