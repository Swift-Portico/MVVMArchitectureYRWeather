//
//  NetworkService.swift
//  YRWeatherAppDemo
//
//  Created by Pradeep's Macbook on 07/10/21.
//

import UIKit
import Combine
import CoreLocation

enum NetworkError: Error {
    case invalidURL
    case responseError
    case unKnown
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "Invalid response")
        case .unKnown:
            return NSLocalizedString("Unknown error", comment: "Unknown error")
        }
    }
}

class NetworkService {
    
    static let sharedInstance = NetworkService()
    
    private init() {}
    
    private let baseURL = "https://api.met.no/weatherapi/locationforecast/2.0?"
    
    private var cancellables = Set<AnyCancellable>()
    
    func getData<T: Decodable>(location: CLLocationCoordinate2D ,type: T.Type) -> Future<T, Error> {
        return Future<T, Error> { [weak self] promise in
            guard let self = self else { return }
            let urlString = self.baseURL + "lat=\(location.latitude)&lon=\(location.longitude)"
            guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
                promise(.failure(NetworkError.invalidURL))
                return
            }
            print(url)
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { data, response in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw NetworkError.responseError
                    }
                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink { completion in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as NetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(NetworkError.unKnown))
                        }
                    }
                } receiveValue: { promise(.success($0))}
                .store(in: &self.cancellables)
        }
    }
    
}
