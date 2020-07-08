//
//  CitiesViewController.swift
//  Gastet
//
//  Created by Ximena Flores de la Tijera on 10/12/18.
//  Copyright © 2018 ximeft29. All rights reserved.
//

import UIKit

class CitiesViewController: UIViewController {

    var cities = ["Monterrey"]
    var selectCityHandler: (String)->() = { _ in }
    
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

extension CitiesViewController: UITableViewDelegate, UITableViewDataSource {
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cities.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as? CityCellTableViewCell
    cell?.citiesLabel.text = cities[indexPath.row]
    return cell!
}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       self.selectCityHandler(cities[indexPath.row])
        self.navigationController?.popViewController(animated: true)
        
    }
    
}

