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

class RepairStationService {
    // Singleton
    static let shared = RepairStationService()
    
}
    
extension RepairStationService {
    @discardableResult
    public static func get(lat: Double, lng: Double) -> Promise<Data> {
        
        let req = ["lat": lat, "lng": lng, "count": 3]
        
        let url: URLConvertible = "http://localhost:8080/api/stations"

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
}
