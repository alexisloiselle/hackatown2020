//
//  RepairStationService.swift
//  Bicycle
//
//  Created by William Sevigny on 2020-01-18.
//  Copyright © 2020 William Sevigny. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit
import Alamofire
import JWTDecode
import CoreLocation


class RepairStationService {
    // Singleton
    static let shared = RepairStationService()
    
}

extension RepairStationService {
    @discardableResult
    public static func get(lat: Double, lng: Double) -> Promise<Data> {
        
        let req = ["lat": lat, "lng": lng, "count": 3]
        
        let url: URLConvertible = "http://10.200.29.158:8080/api/stations"
        
        return Promise { (seal) in
            Alamofire.request(url, method: .post, parameters: req, encoding: JSONEncoding.default).validate()
                .responseString { (response) in
                    print(response.data!);
                    seal.fulfill(response.data!);
            }
        }
    }
    
    static func getCloseStations(lat: Double, lng: Double) -> Promise<[RepairStation]> {
        return Promise { seal in
            RepairStationService.get(lat: lat, lng: lng).done{ (data) in
                var stations = try JSONDecoder().decode([RepairStation].self, from: data)
                seal.fulfill(stations)
            }
        }
    }
    
    static func getRoute(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) -> Promise<Data> {
        
        let url: URLConvertible =  "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&key=AIzaSyAjRg2kTNVBcGRtSLfpziEI7tkV-ggeXbY&mode=walking"
        
        return Promise { (seal) in
            Alamofire.request(url, method: .get, encoding: JSONEncoding.default).validate()
                .responseString { (response) in
                    print(response.data!);
                    seal.fulfill(response.data!);
            }
        }
    }
    
    static func getTheRoute(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) -> Promise<[String:Any]> {
        return Promise { seal in
            RepairStationService.getRoute(source: source, destination: destination).done{ (data) in
                
                let routes = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                //                var routes = data as! Dictionary<String, Any>
                print(routes!)
                seal.fulfill(routes!)
            }
        }
    }
}
