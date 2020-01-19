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
    
    @IBAction func helpPressed(_ sender: Any) {
       let helpMeViewController = storyboard?.instantiateViewController(withIdentifier: "HelpMeViewController") as! HelpMeViewController
        self.present(helpMeViewController, animated: true, completion: nil)
    }
    
   func askHelp(_ sender: UIButton) {
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
        
        self.repairStationTable.separatorStyle = UITableViewCell.SeparatorStyle.none;
    }
    
    override func viewWillAppear(_ animated: Bool){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layoutIfNeeded()
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
        return 120;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepairStationCell", for: indexPath) as! RepairStationCell

        cell.stationOperatorLabel.text = "\(self.repairStations[indexPath.row].stationOperator)";
        cell.distanceLabel.text = "\(Int(self.repairStations[indexPath.row].distance * 1000)) m"
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if #available(iOS 13.0, *) {
            if let repairStationDetailsViewController = storyboard?.instantiateViewController(identifier: "RepairStationDetailsViewController") as? RepairStationDetailsViewController {
                repairStationDetailsViewController.station = self.repairStations[indexPath.row]
                navigationController?.pushViewController(repairStationDetailsViewController, animated: true)
            }
        }
    }
}

