//
//  ViewController.swift
//  COVID Trend Tracker
//
//  Created by James Michalski on 7/18/20.
//  Copyright © 2020 James Michalski. All rights reserved.
//

import UIKit
import SafariServices


class ViewController: UIViewController, UIPickerViewDataSource  {

    var covidManager = CovidManager()

    @IBAction func covidLinkPressed(_ sender: Any) {
        showSafariVC(for: "https://covidtracking.com/")
    }
    @IBOutlet weak var trendArrow: UIImageView!
    @IBOutlet weak var statePicker: UIPickerView!
    @IBOutlet weak var avgLabel: UILabel!
    @IBOutlet weak var labelTable: UIStackView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var trendLabel: UILabel!
    @IBOutlet weak var metricCaption: UILabel!
    @IBAction func didMetricChoiceChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            covidManager.metricChoice = "deaths"
        }
        else {
            covidManager.metricChoice = "cases"
        }
        
        let selectedRow = statePicker.selectedRow(inComponent: 0)
        
        if let statePick = covidManager.stateDictionary[covidManager.stateArray[selectedRow]]{
            covidManager.fetchCovid(state: statePick)
        }
    }
    
    func showSafariVC(for url: String) {
        guard let url = URL(string: url) else {
            //show an invalid URL error alert
            return
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        covidManager.delegate = self
        statePicker.dataSource = self
        statePicker.delegate = self
        // Do any additional setup after loading the view.
        metricCaption.text = "Animated Text"
    }
    
    
}

extension ViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return covidManager.stateArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return covidManager.stateArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let statePick = covidManager.stateDictionary[covidManager.stateArray[row]]{
            covidManager.fetchCovid(state: statePick)
        }
    }
    
}

extension ViewController: CovidManagerDelegate {
    
    
    
    func didGetCovidTrend(covidModel: CovidModel) {
        let dirtyArray = covidModel.metricDataArray
        let cleanArray = covidModel.removeNilFromArray(dataArray: dirtyArray)
        let output = covidModel.calcTrend(dataArray: cleanArray)
        let trendString = String(format: "%.2f", output[1])
        let avgString = String(format: "%.1f",output[0])
        let dateString = String(format: "%.0f", output[2])
        var increaseString = "+"
        var trendArrowDirection = "up"
        if (output[1] < 0) {
            increaseString = ""
            trendArrowDirection = "down"
        }
        var trendArrowChoice = "1"
        if (output[0] != 0) {
            if (abs(output[1]) / output[0] > K.trendThreshold) {
                trendArrowChoice = "2"
            }
        }
        
        trendArrow.image = UIImage(named: "\(trendArrowDirection)\(trendArrowChoice).png")
        labelTable.isHidden = false
        metricCaption.isHidden = true
        avgLabel.text = "\(avgString) /day"
        trendLabel.text = "\(increaseString)\(trendString) /day"
        dateLabel.text = "\(dateString[4..<6])/\(dateString.substring(fromIndex: 6))/\(dateString.substring(toIndex: 4))"
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}


    


