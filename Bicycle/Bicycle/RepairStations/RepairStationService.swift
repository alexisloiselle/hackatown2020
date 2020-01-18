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
    public static func get() -> Promise<Data> {
        
        let req = ["lat": 45.510860, "lng":-73.619050, "count":3]
        
        let url: URLConvertible = "http://localhost:8080/api/stations"

        return Promise { (seal) in
            Alamofire.request(url, method: .post, parameters: req, encoding: JSONEncoding.default).validate()
                .responseString { (response) in
//                    var results = JSONDecoder().decode([RepairStation].self, from: response.data!)
                    print(response.data!);
//                    switch response.result {
//                    case .success:
                    seal.fulfill(response.data!);
//            };
        }
    }
}
    
    static func getCloseStations() -> Promise<[RepairStation]> {
        return Promise { seal in
            RepairStationService.get().done{ (data) in
                var stations = try JSONDecoder().decode([RepairStation].self, from: data)
                seal.fulfill(stations)
            }
        }
    }
}
