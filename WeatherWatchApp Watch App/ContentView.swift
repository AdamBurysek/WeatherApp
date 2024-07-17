//
//  ContentView.swift
//  WeatherWatchApp Watch App
//
//  Created by Adam Buryšek on 17.07.2024.
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @StateObject private var locationManager = LocationManager()
    @State private var cancellables = Set<AnyCancellable>()

    var body: some View {
        VStack {
            if let weather = viewModel.weatherResponse {
                List(weather.properties.timeseries, id: \.time) { timeseries in
                    VStack(alignment: .leading) {
                        Text("Time: \(timeseries.time)")
                        Text("Temp: \(timeseries.data.instant.details.airTemperature)°C")
                        if let precipitation1h = timeseries.data.next_1_hours?.details?.precipitationAmount {
                            Text("Precipitation (1 hour): \(precipitation1h) mm")
                        }
                    }
                    .padding(.vertical, 4)
                }
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            locationManager.$location
                .compactMap { $0 }
                .sink { location in
                    viewModel.fetchWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                }
                .store(in: &cancellables)
            
            locationManager.$locationError
                .compactMap { $0 }
                .sink { error in
                    viewModel.errorMessage = error
                }
                .store(in: &cancellables)

            locationManager.startUpdatingLocation()
        }
    }
}

#Preview {
    ContentView()
}

