//
//  ViewController.swift
//  Bicycle
//
//  Created by William Sevigny on 2020-01-18.
//  Copyright © 2020 William Sevigny. All rights reserved.
//

import UIKit
import CoreLocation

let globalLocationManager = CLLocationManager()

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var repairStationTable: UITableView!
    @IBOutlet weak var repairStationTableTitleLabel: UILabel!
    
    @IBAction func helpPressed(_ sender: Any) {
       let helpMeViewController = storyboard?.instantiateViewController(withIdentifier: "HelpMeViewController") as! HelpMeViewController
        SocketService.delegate = helpMeViewController
        self.present(helpMeViewController, animated: true, completion: nil)
    }

    
    private var repairStations: [RepairStation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get location services
        
//        // Ask for Authorisation from the User.
        globalLocationManager.requestAlwaysAuthorization()
      
//        // For use in foreground
        globalLocationManager.requestWhenInUseAuthorization()
        
        self.initLocationServices()
        
        let repairStationCellNib = UINib.init(nibName: "RepairStationCell", bundle: nil)
        self.repairStationTable.register(repairStationCellNib, forCellReuseIdentifier: "RepairStationCell")
        
        self.repairStationTable.separatorStyle = UITableViewCell.SeparatorStyle.none;
    }
    
    override func viewWillAppear(_ animated: Bool){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layoutIfNeeded()
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        SocketService.updatePosition(lat: locValue.latitude, lng: locValue.longitude)
        
        if CLLocationManager.locationServicesEnabled() {
            if (CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse) {
                if (!SocketService.initialized) {
                    self.initSocket()
                    SocketService.initialized = true
                } else {
                    SocketService.updatePosition(lat: locValue.latitude, lng: locValue.longitude)
                }
                self.fetchNearStations()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.initLocationServices()
    }
    
    func fetchNearStations() -> Void {
        if CLLocationManager.locationServicesEnabled() {
            if (CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse) {
                RepairStationService.getCloseStations(lat: globalLocationManager.location!.coordinate.latitude, lng: globalLocationManager.location!.coordinate.longitude).done { (stations) in
                    self.repairStations = stations;
                    self.repairStationTable.reloadData();
                    self.repairStationTableTitleLabel.text = " \(self.repairStations.count) stations nearby";
                }
            }
        }
    }
    
    func initLocationServices() -> Void {
        if CLLocationManager.locationServicesEnabled() {
            if (CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse) {
                globalLocationManager.delegate = self
                globalLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                globalLocationManager.startUpdatingLocation()
            }
        }
    }
    
    func initSocket() -> Void {
        // Connect to socket
        SocketService.start(lat: globalLocationManager.location!.coordinate.latitude, lng: globalLocationManager.location!.coordinate.longitude, viewController: self)
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
        
        cell.stationOperatorLabel.text = self.repairStations[indexPath.row].stationOperator;
        cell.distanceLabel.text = "\(Int(self.repairStations[indexPath.row].distance * 1000)) m"
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if #available(iOS 13.0, *) {
            if let repairStationDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "RepairStationDetailsViewController") as? RepairStationDetailsViewController {
                repairStationDetailsViewController.station = self.repairStations[indexPath.row]
                navigationController?.pushViewController(repairStationDetailsViewController, animated: true)
            }
        }
    }
}

