//
//  CovidManager.swift
//  COVID Trend Tracker
//
//  Created by James Michalski on 7/18/20.
//  Copyright © 2020 James Michalski. All rights reserved.
//

import Foundation

protocol CovidManagerDelegate {
    func didGetCovidTrend(covidModel: CovidModel)
    func didFailWithError(error: Error)
}

struct CovidManager {
    let covidURL = "https://covidtracking.com/api/v1/states"
    
    let stateArray = ["Alabama", "Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming"]
    
    let stateDictionary = ["Alabama":"al", "Alaska":"ak","Arizona":"az","Arkansas":"ar","California":"ca","Colorado":"co","Connecticut":"ct","Delaware":"de","Florida":"fl","Georgia":"ga","Hawaii":"hi","Idaho":"id","Illinois":"il","Indiana":"in","Iowa":"ia","Kansas":"ks","Kentucky":"ky","Louisiana":"la","Maine":"me","Maryland":"md","Massachusetts": "ma","Michigan":"mi","Minnesota":"mn","Mississippi":"ms","Missouri":"mo","Montana":"mt","Nebraska":"ne","Nevada":"nv","New Hampshire":"nh","New Jersey":"nj","New Mexico":"nm","New York":"ny","North Carolina":"nc","North Dakota":"nd","Ohio":"oh","Oklahoma":"ok","Oregon":"or","Pennsylvania":"pa","Rhode Island":"ri","South Carolina":"sc","South Dakota":"sd","Tennessee":"tn","Texas":"tx","Utah":"ut","Vermont":"vt","Virginia":"va","Washington":"wa","West Virginia":"wv","Wisconsin":"wi","Wyoming":"wy"]
    
    var delegate: CovidManagerDelegate?
    var metricChoice = "deaths"
    
    var metricDataArray = [[Int?]]()
    
    
    func fetchCovid (state: String){
        let urlString = "\(covidURL)/\(state)/daily.json"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
            task.resume()
        }
        
        
    }
    
    
    func handle(data: Data?, response: URLResponse?, error: Error?){
        if error != nil {
            print(error!)
            return
        }
        if let safeData = data {
            if let covid = self.parseJSON(covidData: safeData) {
                DispatchQueue.main.async {
                    self.delegate?.didGetCovidTrend(covidModel: covid)
                }
 
            }
        }
    }
    
    
    func parseJSON(covidData: Data) -> CovidModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode([CovidData].self, from: covidData)
            let deathData = buildArray(jsonoutput: decodedData)
            let covidModel = CovidModel(metricDataArray: deathData)
            return covidModel
        } catch {
            print("XXXXX")
            print(error)
            return nil
        }
    }
    
    func buildArray(jsonoutput: [CovidData]) -> [[Int?]]{
        var dataArray = [[Int?]]()
        if metricChoice == "deaths" {
        for i in 0...13 {
            dataArray.append([i,jsonoutput[i].deathIncrease,jsonoutput[i].date])
        }
        } else {
            for i in 0...13 {
                dataArray.append([i,jsonoutput[i].positiveIncrease,jsonoutput[i].date])
            }
        }

        print(dataArray)
        return dataArray
    }
    
}

