//
//  CovidModel.swift
//  COVID Trend Tracker
//
//  Created by James Michalski on 7/19/20.
//  Copyright © 2020 James Michalski. All rights reserved.
//

import Foundation

struct CovidModel {
    let metricDataArray: [[Int?]]
    
    
    
    func removeNilFromArray(dataArray: [[Int?]]) -> [[Int]] {
        let a = dataArray.count - 1
        var cleanedArray = [[Int]]()
        
        for i in 0...a {
            if let x = dataArray[i][0] {
                if let y = dataArray[i][1]{
                    if let z = dataArray[i][2]{
                      cleanedArray.append([x,y,z])
                    }
                    
                }
            }
        }
        return cleanedArray
    }
    
    func calcTrend(dataArray: [[Int]]) -> [Double] {
        
        let a = dataArray.count - 1
        var xTotal = 0
        var yTotal = 0
        
        for i in 0...a {
            xTotal += dataArray[i][0]
            yTotal += dataArray[i][1]
            }
        
        let xAvg = Double(xTotal) / Double(a)
        let yAvg = Double(yTotal) / Double(a)
        
        print(a)
        print(xAvg)
        print(yAvg)
        
        var num: Double = 0.0
        var denom: Double = 0.0
        
        for j in 0...a {
            num = num + (Double(dataArray[j][0])-xAvg) * (Double(dataArray[j][1])-yAvg)
            denom = denom + (Double(dataArray[j][0])-xAvg) * (Double(dataArray[j][0])-xAvg)
        }
        
        let trend =  num / denom
        print(dataArray)
        let date = Double(dataArray[0][2])
        return [yAvg, trend, date]
    
    }
    
}
