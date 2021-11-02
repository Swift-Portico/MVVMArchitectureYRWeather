//
//  WeatherViewController.swift
//  YRWeatherAppDemo
//
//  Created by Pradeep's Macbook on 07/10/21.
//

import UIKit
import CoreLocation
import Combine

class WeatherViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var weatherDisplayTableView: UITableView!
    
    //MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let locationManager = CLLocationManager()
    private var weatherViewModel = WeatherViewModel()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewComponents()
    }
    
    //MARK: - ConfigureViewComponents
    
    fileprivate func configureViewComponents(){
        self.initializeDataSource()
        self.checkLocationServices()
    }
    
    fileprivate func checkLocationServices() {
        if(CLLocationManager.locationServicesEnabled()){
            setupLocationManager()
            checkAuthorizationStatus()
        }
    }
    
    fileprivate func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    fileprivate func checkAuthorizationStatus(){
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break;
        case .denied:
            break;
        case .authorizedAlways:
            break;
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }

    //MAR:  - Selectors
}


//MARK: - Extensions

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }
        locationManager.stopUpdatingLocation()
        if(weatherViewModel.dataSource != nil){
            OverlayView.sharedInstance.showOverlay(self.view)
            weatherViewModel.fetchWeatherData(with: .init(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorizationStatus()
    }
    
}

//MARK: - Initialization

extension WeatherViewController {
    
    fileprivate func initializeDataSource() {
        weatherViewModel.dataSource = WeatherAPIDataSource(tableView: self.weatherDisplayTableView, cellProvider: { (tableView, indexPath, model) -> UITableViewCell? in
            let weatherCell: WeatherDisplayTableviewCell  = tableView.dequeueReusableCell(forIndexPath: indexPath)
            guard let hours = model.data?.next_12_hours, let symbolCode = hours.summary?.symbol_code else { return WeatherDisplayTableviewCell() }
            weatherCell.populateData(metaData: model.data, with: WeatherIconOptions.init(rawValue: symbolCode) ?? WeatherIconOptions.rain)
            return weatherCell
        })
    }
}

//MARK: - TableView Delegate Methods

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
