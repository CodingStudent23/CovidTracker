//
//  CovidData.swift
//  COVID Trend Tracker
//
//  Created by James Michalski on 7/18/20.
//  Copyright © 2020 James Michalski. All rights reserved.
//

import Foundation

struct CovidData: Decodable {
    
    var deathIncrease: Int?
    var positiveIncrease: Int?
    var date: Int?
    
}
