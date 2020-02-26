//
//  PlaceMarker.swift
//  MeTA
//
//  Created by Kevin J. Zheng on 2/24/20.
//  Copyright © 2020 senior design. All rights reserved.
//

import UIKit
import GoogleMaps

class PlaceMarker: GMSMarker {
    let place: GooglePlace
    
    init(place: GooglePlace) {
      self.place = place
      super.init()
      
      position = place.coordinate
      icon = UIImage(named: place.placeType+"_pin")
      groundAnchor = CGPoint(x: 0.5, y: 1)
      appearAnimation = .pop
    }
}
