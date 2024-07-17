//
//  WeatherAPI.swift
//  WeatherApp
//
//  Created by Adam Buryšek on 17.07.2024.
//

import Foundation
import SwiftUI

class WeatherViewModel: ObservableObject {
    @Published var weatherResponse: WeatherResponse?
    @Published var errorMessage: String?
    private let appGroupID = "group.com.apiTest"

    func fetchWeather(latitude: Double, longitude: Double) {
        let urlString = "https://api.met.no/weatherapi/locationforecast/2.0/complete?lat=\(latitude)&lon=\(longitude)"
               guard let url = URL(string: urlString) else {
                   DispatchQueue.main.async {
                       self.errorMessage = "Invalid URL"
                   }
                   return
               }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received"
                }
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                DispatchQueue.main.async {
                    self.weatherResponse = decodedResponse
                    self.saveWeatherData(data)
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to decode data: \(error.localizedDescription)"
                }
            }
        }.resume()
    }

    private func saveWeatherData(_ data: Data) {
        if let sharedDefaults = UserDefaults(suiteName: appGroupID) {
            sharedDefaults.set(data, forKey: "weatherData")
        }
    }
}

