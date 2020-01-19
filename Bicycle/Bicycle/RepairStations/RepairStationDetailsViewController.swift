//
//  RepairStationDetailsViewController.swift
//  Bicycle
//
//  Created by Maxine Mheir on 2020-01-18.
//  Copyright © 2020 William Sevigny. All rights reserved.
//

import UIKit
import GoogleMaps

class RepairStationDetailsViewController: UIViewController {
    @IBOutlet weak var operatorLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!

    public var station: RepairStation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var dist = (self.station!.distance * 1000).rounded()
        self.operatorLabel.text = self.station!.address
        self.distanceLabel.text = String(Int(dist)) + " m"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2113084495, green: 0.8225846887, blue: 0.2536858618, alpha: 1)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layoutIfNeeded()

        (self.children[0] as! RepairStationsMapsViewController).lat = self.station!.lat
        (self.children[0] as! RepairStationsMapsViewController).lng = self.station!.lng
        (self.children[0] as! RepairStationsMapsViewController).loadView()
        let position = CLLocationCoordinate2D(latitude: (self.station!.lat as NSString).doubleValue, longitude: (self.station!.lng as NSString).doubleValue)
        (self.children[0] as! RepairStationsMapsViewController).fetchRoute(from: globalLocationManager.location!.coordinate, to: position)
    }
}
