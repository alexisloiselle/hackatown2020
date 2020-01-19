//
//  HelpMeYesViewController.swift
//  Bicycle
//
//  Created by Maxine Mheir on 2020-01-19.
//  Copyright © 2020 William Sevigny. All rights reserved.
//

import UIKit

class HelpMeYesViewController: UIViewController {
    public var lat: String = ""
    public var lng: String = ""
    public var distance: Double = 0.0
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dist = (self.distance * 1000).rounded()
        self.distanceLabel.text = String(Int(dist)) + " m"
    }

    override func viewWillAppear(_ animated: Bool) {
        (self.children[0] as! RepairStationsMapsViewController).lat = self.lat
        (self.children[0] as! RepairStationsMapsViewController).lng = self.lng
        (self.children[0] as! RepairStationsMapsViewController).loadView()
    }

}
