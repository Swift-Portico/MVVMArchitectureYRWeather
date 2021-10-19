//
//  WeatherDisplayTableviewCell.swift
//  YRWeatherAppDemo
//
//  Created by Pradeep's Macbook on 07/10/21.
//

import UIKit

class WeatherDisplayTableviewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var weatherSymbolCodeLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    //MARK: - Helper Functions
    
    func populateData(metaData: Data?, with symbolIcon: WeatherIconOptions) {
        self.weatherSymbolCodeLabel.text = metaData?.next_12_hours?.summary?.symbol_code?.capitalizingFirstLetter().replacingOccurrences(of: "_", with: "")
        self.weatherIcon.image = symbolIcon.getWeatherIcon()
    }
    
}
