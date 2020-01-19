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

    public var lat: String = ""
    public var lng: String = ""
    public var id: String = ""
    public var distance: Double = 0.0
    
    @IBAction func yesButton(_ sender: UIButton) {
        let helpMeYesViewController  = storyboard?.instantiateViewController(withIdentifier: "HelpMeYesViewController") as! HelpMeYesViewController;

        helpMeYesViewController.lat = String(self.lat)
        helpMeYesViewController.lng = String(self.lng)
        helpMeYesViewController.distance = self.distance
        
        SocketService.provideHelp(lat: Double(self.lat) as! Double, lng: Double(self.lng) as! Double, id: self.id)
        present(helpMeYesViewController, animated: true, completion: nil)
    }
    
    @IBAction func noButton(_ sender: UIButton) {
        SocketService.laisserPourCompte(id: self.id)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dist = (self.distance * 1000).rounded()
        self.helpNameLabel.text = "Help!"
        self.helpDistanceLabel.text = String(Int(dist)) + " m"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        (self.children[0] as! RepairStationsMapsViewController).lat = String(self.lat)
        (self.children[0] as! RepairStationsMapsViewController).lng = String(self.lng)
        (self.children[0] as! RepairStationsMapsViewController).loadView()
    }

}
