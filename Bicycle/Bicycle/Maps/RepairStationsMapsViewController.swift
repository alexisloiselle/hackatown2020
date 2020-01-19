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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: (self.lat as NSString).doubleValue, longitude: (self.lng as NSString).doubleValue, zoom: 15)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: (self.lat as NSString).doubleValue, longitude: (self.lng as NSString).doubleValue)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }
    
    
    
    func fetchRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        RepairStationService.getTheRoute(source: source, destination: destination).done {data in
            guard let routes = data["routes"] as? [Any] else {
                return
            }
            
            guard let route = routes[0] as? [String: Any] else {
                return
            }
            
            guard let overview_polyline = route["overview_polyline"] as? [String: Any] else {
                return
            }
            
            guard let polyLineString = overview_polyline["points"] as? String else {
                return
            }
            
            //Call this method to draw path on map
            self.drawPath(from: polyLineString)
        }
        
    }
    
    func drawPath(from polyStr: String){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.map = self.view as! GMSMapView // Google MapView
    }
}
