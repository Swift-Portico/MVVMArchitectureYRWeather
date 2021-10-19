//
//  WeatherViewModel.swift
//  YRWeatherAppDemo
//
//  Created by Pradeep's Macbook on 07/10/21.
//

import Combine
import UIKit
import CoreLocation

public enum Section {
    case main
}

typealias WeatherAPIDataSource = UITableViewDiffableDataSource<Section, TimeSeries>
typealias WeatherAPISnapShot = NSDiffableDataSourceSnapshot<Section, TimeSeries>

class WeatherViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    var dataSource: WeatherAPIDataSource!
    @Published var timeseriesArray = [TimeSeries]()
    private var snapshot = WeatherAPISnapShot()
    
    func fetchWeatherData(with coordinates: CLLocationCoordinate2D) {
        NetworkService.sharedInstance.getData(location: CLLocationCoordinate2D.init(latitude: 20.0, longitude: 30.0), type: WeatherForecast.self)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    AlertController.showError(message: error.localizedDescription)
                    OverlayView.sharedInstance.hideOverlay()
                case .finished:
                    print("*** Did Finished Response ***")
                    OverlayView.sharedInstance.hideOverlay()
                    /*AlertController.showSuccess(message: "Finished Loading")*/
                }
            } receiveValue: { [weak self] weatherForecast in
                guard let self = self, let timeseries = weatherForecast.properties?.timeseries else { return }
                self.timeseriesArray = timeseries
                guard self.dataSource != nil else { return }
                self.snapshot.deleteAllItems()
                if self.timeseriesArray.isEmpty
                {
                    self.dataSource.apply(self.snapshot, animatingDifferences: true)
                    return
                }
                self.snapshot.appendSections([.main])
                self.snapshot.appendItems(self.timeseriesArray)
                self.dataSource.apply(self.snapshot, animatingDifferences: true)
            }
            .store(in: &cancellables)
    }
    
    private func getLocation(from address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let clGeoCoder = CLGeocoder()
        clGeoCoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let location = placemarks?.first?.location?.coordinate else { return }
            completion(location)
        }
    }
}

