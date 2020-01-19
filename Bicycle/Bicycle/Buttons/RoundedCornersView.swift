//
//  RoundedCornersView.swift
//  Bicycle
//
//  Created by Maxine Mheir on 2020-01-18.
//  Copyright © 2020 William Sevigny. All rights reserved.
//

import UIKit

class RoundedCornersView: UIView {

    required public init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           self.layer.cornerRadius = 10;
       }
}
