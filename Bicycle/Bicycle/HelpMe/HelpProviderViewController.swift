//
//  HelpProviderViewController.swift
//  Bicycle
//
//  Created by Maxine Mheir on 2020-01-18.
//  Copyright © 2020 William Sevigny. All rights reserved.
//

import UIKit
import GoogleMaps

class HelpProviderViewController: UIViewController {
    @IBOutlet weak var helpNameLabel: UILabel!
    @IBOutlet weak var helpDistanceLabel: UILabel!
    
    @IBAction func yesButton(_ sender: UIButton) {
//        let helpMeYesViewController  = storyboard?.instantiateViewController(withIdentifier: "RepairStationDetailsViewController") as! RepairStationDetailsViewController;
//
//        helpMeYesViewController.operatorLabel.text = "Meet the rider"
//        helpMeYesViewController.distanceLabel.text = String(Int(self.distance))
//        present(helpMeYesViewController, animated: true, completion: nil)
    }
    
    @IBAction func noButton(_ sender: UIButton) {
    }
    public var lat: String = ""
    public var lng: String = ""
    public var distance: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.distance)
        let dist = (self.distance * 1000).rounded()
        self.helpNameLabel.text = "Help!"
        self.helpDistanceLabel.text = String(Int(dist)) + " m"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        (self.children[0] as! RepairStationsMapsViewController).lat = self.lat
        (self.children[0] as! RepairStationsMapsViewController).lng = self.lng
        (self.children[0] as! RepairStationsMapsViewController).loadView()
    }

}
