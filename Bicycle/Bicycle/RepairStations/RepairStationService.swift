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

class StationService {
    // Singleton
    static let shared = StationService()
    
}
    
extension StationService {
    @discardableResult
    private static func get() -> Promise<Data> {
        let url: URLConvertible = "http://polypaint.me/api/user/AllCanvas"
        let headers = [
            "Authorization": "Bearer " + UserDefaults.standard.string(forKey: "token")!,
            "Accept": "application/json"
        ]
        
        return Promise { (seal) in
            Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON{ (response) in
                switch response.result {
                case .success( _):
                    seal.fulfill(response.data!);
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
}
