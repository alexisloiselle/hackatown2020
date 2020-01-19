//
//  SomeonesIsViewController.swift
//  Bicycle
//
//  Created by William Sevigny on 2020-01-19.
//  Copyright © 2020 William Sevigny. All rights reserved.
//

import UIKit
import CoreLocation

class SomeonesIsViewController: UIViewController {
    @IBOutlet weak var distanceLabel: UILabel!
    
    public var rider: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dist = ((self.rider["distance"] as! Double) * 1000).rounded()
        self.distanceLabel.text = String(Int(dist)) + " m away"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(self.children)
        print(self.children[0])
        print(self.rider)
        (self.children[0] as! RepairStationsMapsViewController).lat = String(self.rider["lat"] as! Double)
        (self.children[0] as! RepairStationsMapsViewController).lng = String(self.rider["lng"] as! Double)
        let position = CLLocationCoordinate2D(latitude:self.rider["lat"] as! Double, longitude:self.rider["lng"] as! Double)
        (self.children[0] as! RepairStationsMapsViewController).loadView()
        (self.children[0] as! RepairStationsMapsViewController).fetchRoute(from: globalLocationManager.location!.coordinate, to: position)
    }
}
