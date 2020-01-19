//
//  ViewController.swift
//  Bicycle
//
//  Created by William Sevigny on 2020-01-18.
//  Copyright © 2020 William Sevigny. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var repairStationTable: UITableView!
    @IBOutlet weak var repairStationTableTitleLabel: UILabel!
    @IBOutlet weak var helpButton: RoundedCorners!
    
    
    @IBAction func askHelp(_ sender: UIButton) {
        SocketService.askHelp(lat: locationManager.location!.coordinate.latitude,lng: locationManager.location!.coordinate.longitude)
    }
    
    private var repairStations: [RepairStation] = []
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get location services
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        self.initSocket()
        
        let repairStationCellNib = UINib.init(nibName: "RepairStationCell", bundle: nil)
        self.repairStationTable.register(repairStationCellNib, forCellReuseIdentifier: "RepairStationCell")
        
        self.repairStationTable.layer.cornerRadius = 10;
        self.repairStationTable.separatorStyle = UITableViewCell.SeparatorStyle.none;
        self.helpButton.backgroundColor = hexStringToUIColor(hex: "#32CD32");
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    override func viewWillAppear(_ animated: Bool){
        self.fetchNearStations()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.initSocket()
        self.fetchNearStations()
    }
    
    func fetchNearStations() -> Void {
        if CLLocationManager.locationServicesEnabled() {
            if (CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse) {
                RepairStationService.getCloseStations(lat: locationManager.location!.coordinate.latitude, lng: locationManager.location!.coordinate.longitude).done { (stations) in
                    self.repairStations = stations;
                    self.repairStationTable.reloadData();
                    self.repairStationTableTitleLabel.text = " \(self.repairStations.count) stations nearby";
                }
            }
        }
    }
    
    func initSocket() -> Void {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            if (CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse) {
                // Connect to socket
                SocketService.start(lat: locationManager.location!.coordinate.latitude, lng: locationManager.location!.coordinate.longitude)
                
                Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { timer in
                    SocketService.updatePosition(lat: self.locationManager.location!.coordinate.latitude, lng: self.locationManager.location!.coordinate.longitude)
                }
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repairStations.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepairStationCell", for: indexPath) as! RepairStationCell
        
        cell.stationOperatorLabel.text = "\(self.repairStations[indexPath.row].stationOperator)";
        cell.distanceLabel.text = "\(self.repairStations[indexPath.row].distance) m"
        
        return cell;
    }
}

