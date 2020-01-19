//
//  RepairStationsMapsViewController.swift
//  Bicycle
//
//  Created by Maxine Mheir on 2020-01-18.
//  Copyright © 2020 William Sevigny. All rights reserved.
//

import UIKit
import GoogleMaps

class RepairStationsMapsViewController: UIViewController {
    
    public var lat: String = ""
    public var lng: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
      // Create a GMSCameraPosition that tells the map to display the
      // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: (self.lat as NSString).doubleValue, longitude: (self.lng as NSString).doubleValue, zoom: 15)
      let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
      view = mapView

      // Creates a marker in the center of the map.
      let marker = GMSMarker()
      marker.position = CLLocationCoordinate2D(latitude: (self.lat as NSString).doubleValue, longitude: (self.lng as NSString).doubleValue)
      marker.title = "Sydney"
      marker.snippet = "Australia"
      marker.map = mapView
    }
}
