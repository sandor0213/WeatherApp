//
//  ForecastViewModel.swift
//  WeatherAppTest
//
//  Created by Shandor Baloh on 01.03.2023.
//

import Foundation

protocol ForecastViewModelInputActionsDelegate {
    func getForecast()
}

protocol ForecastViewModelOutputActionsDelegate: AnyObject {
    func updateUI(model: WeatherAPIResponseModel)
}

final class ForecastViewModel: ForecastViewModelInputActionsDelegate {
    weak var outputViewModelDelegate: ForecastViewModelOutputActionsDelegate?
    
    init(_ view: ForecastViewModelOutputActionsDelegate) {
        self.outputViewModelDelegate = view
    }
    
    func getForecast() {
        let requestCompletion: (WeatherAPIResponseModel?, Error?) -> Void = { [weak self] (model, error) in
            guard error == nil, let model = model else { return }
            DispatchQueue.main.async {
                
                self?.outputViewModelDelegate?.updateUI(model: model)
            }
        }
        
        APIManager.shared.makeRequest(toURL: Constants.baseURL + Constants.forecastPath, withHttpMethod: .get, queryParameters: WeatherAPIRequestModel(key: Constants.apiKey, q: "Budapest", days: 7, aqi: "no", alerts: "no").dict, completion: requestCompletion)
    }
}
