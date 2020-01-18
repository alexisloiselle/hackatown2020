//
//  RepairStation.swift
//  Bicycle
//
//  Created by William Sevigny on 2020-01-18.
//  Copyright © 2020 William Sevigny. All rights reserved.
//

import Foundation

struct RepairStation: Codable  {
    var address: String
    var distance: Double
    var stationOperator: String
    var lat: String
    var lng: String
}
