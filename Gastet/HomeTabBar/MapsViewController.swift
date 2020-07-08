//
//  MapsViewController.swift
//  Gastet
//
//  Created by Ximena Flores de la Tijera on 2/28/19.
//  Copyright © 2019 ximeft29. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase

class MapsViewController: UIViewController {

    //VARS
    var locationManager : CLLocationManager!
    var userLocation: CLLocationCoordinate2D?
    var postLatitude: Double?
    var postLongitude: Double?
    
    //@IBOUTLETS
    
    @IBOutlet weak var googleMap: GMSMapView!
    
    //@IBACTION
    
    @IBAction func toCollectionView(_ sender: UIButton) {
        
     self.navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    
    //Funcs
    
    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    func setupViewWhenLocationEnabled() {
        
    }
    
    
    func fetchFirebase() {
        let postRef = Database.database().reference().child("posts/L_4IPEerjWodfAx1VIY")
        postRef.observe(.value) { (snapshot) in
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot {
                    let dict = childSnapshot.value as? [String: Any]
                    
                    //Latitude
                    let location = dict!["location"] as? [String: Any]
                    let latitude = location!["latitude"] as? Double
                    
                    print(location)
                    print("Aqui esta la latitude: \(latitude!)")
                }
            }
        }
    }
    
    
//    @objc func observePostsLost() {
//        activityIndicator.startAnimating()
//        let postsRef = Database.database().reference().child("posts")
//        postsRef.queryOrdered(byChild: "postType").queryEqual(toValue: "lost").observe(.value) { (snapshot) in
//            var tempPost = [Posts]()
//            for child in snapshot.children {
//                if let childSnapshot = child as? DataSnapshot {
//                    let dict = childSnapshot.value as? [String: Any]
//                    let key = childSnapshot.key as String
//                    let newLostPost = Posts.transformPost(dict: dict!, key: key)
//
//                    //This will look up all users at once
//                    self.fetchUser(userid: newLostPost.userid!, completed: {
//                        tempPost.insert(newLostPost, at: 0)
//                        DispatchQueue.main.async {
//                            self.posts = tempPost
//                            self.posts.sort(by: { (p1, p2) -> Bool in
//                                return p1.timestamp?.compare(p2.timestamp!) == .orderedDescending
//                            })
//                            self.activityIndicator.stopAnimating()
//                            self.lostCollectionView.reloadData()
//                            self.refresherLost.endRefreshing()
//                        }
//                    })
//                }
//            }
//        }
//    }

    func googleMarkers() {
        
        var post = Posts()
        
        let position = CLLocationCoordinate2D(latitude: post.latitude!, longitude: post.longitude!)
        let marker = GMSMarker(position: position)
        marker.map = googleMap
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Functions
        
        setupLocationManager()
        fetchFirebase()
        
    }
}

extension MapsViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedAlways:
            setupViewWhenLocationEnabled()
            print("Si tenemos acceso a la ubicación del usuario")
        case .denied:
            print("No nos dieron autorización para acceso")
            ProgressHUD.showError("No tenemos autorización de obtener tu ubicación. Por favor cambia tus preferencias.")
            self.navigationController?.dismiss(animated: true, completion: nil)
            
        default:
            break
        }
        
        //Obtenemos la ubicación actualizada en tiempo real.
        locationManager.startUpdatingLocation()
        
        //Esta linea agrega el circulito azul de la ubicación deel usuario en el mapa
        googleMap.isMyLocationEnabled = true
        
        //Habilitamos el boton del mapa para centrar la camara en la ubicación
        googleMap.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
   
        if let location = locations.first {
            userLocation = location.coordinate
            googleMap.camera = GMSCameraPosition(target: location.coordinate, zoom: 17, bearing: 0, viewingAngle: 0)
            
        }
        
    }
    
}
