//
//  MunicipalityViewController.swift
//  Gastet
//
//  Created by Ximena Flores de la Tijera on 10/12/18.
//  Copyright © 2018 ximeft29. All rights reserved.
//

import UIKit

class MunicipalityViewController: UIViewController {

    var municipalities = ["Apodaca", "Escobedo","Guadalupe","Juárez", "Monterrey", "San Nicolás", "San Pedro", "Santa Catarina"]
    var selectMunicipalityHandler: (String)->() = { _ in}
    
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension MunicipalityViewController: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return municipalities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "municipalityCell", for: indexPath) as? MunicipalityCellTableViewCell
        cell?.municipalityLabel.text = municipalities[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectMunicipalityHandler(municipalities[indexPath.row])
        self.navigationController?.popViewController(animated: true)
        
    }
    

}
