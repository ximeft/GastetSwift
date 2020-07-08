//
//  LocationViewController.swift
//  Gastet
//
//  Created by Ximena Flores de la Tijera on 2/9/19.
//  Copyright © 2019 ximeft29. All rights reserved.
//

import UIKit
import GoogleMaps

class LocationViewController: UIViewController{


    //Vars
    var locationManager: CLLocationManager!
    var userLocation: CLLocationCoordinate2D?
    var delegate: MapViewControllerProtocol?
    
    //IBOutlet
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var doneButton: UIButton!
    
    //IBAction
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        
        locationSelected()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //funcs
        setupLocationManager()
        
        mapView.delegate = self
        
    }
    
    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func setupViewWhenLocationEnabled() {
        //Obtenemos la ubicación actualizada en tiempo real.
        locationManager.startUpdatingLocation()
        
        //Esta linea agrega el circulito azul de la ubicación deel usuario en el mapa
        mapView.isMyLocationEnabled = true
        
        //Habilitamos el boton del mapa para centrar la camara en la ubicación
        mapView.settings.myLocationButton = true
        
    }
    
    func locationSelected() {
        
        delegate?.selectLocation(location: userLocation!)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension LocationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedAlways,.authorizedWhenInUse:
            setupViewWhenLocationEnabled()
            print("Accesso a la ubicación del usuario")
        default:
            print("No tenemos accesso")
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        if userLocation == nil {
            if let location = locations.first {
                userLocation = location.coordinate
                mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 17, bearing: 0, viewingAngle: 0)
                
            }
        }

        
    }
    
}

extension LocationViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        userLocation = position.target
        doneButton.isEnabled = true
        
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        doneButton.isEnabled = false
    }
}

protocol MapViewControllerProtocol {
    func selectLocation(location: CLLocationCoordinate2D)
}

