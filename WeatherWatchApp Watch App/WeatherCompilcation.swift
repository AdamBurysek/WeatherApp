//
//  WeatherCompilation.swift
//  WeatherWatchApp Watch App
//
//  Created by Adam Buryšek on 24.07.2024.
//

import ClockKit
import SwiftUI
import Combine

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    @StateObject private var viewModel = WeatherViewModel()
    @State private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        fetchWeather()
    }
    
    func fetchWeather() {
        let locationManager = LocationManager()
        
        locationManager.$location
            .compactMap { $0 }
            .sink { location in
                self.viewModel.fetchWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            }
            .store(in: &cancellables)
        
        locationManager.startUpdatingLocation()
    }
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        guard let temperature = viewModel.weatherResponse?.properties.timeseries.first?.data.instant.details.airTemperature else {
            handler(nil)
            return
        }
        
        let template = createTemplate(for: complication, temperature: temperature)
        let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
        handler(entry)
    }
    
    func createTemplate(for complication: CLKComplication, temperature: Double) -> CLKComplicationTemplate {
        switch complication.family {
        case .modularSmall:
            let textTemplate = CLKComplicationTemplateModularSmallSimpleText(textProvider: CLKSimpleTextProvider(text: "\(Int(temperature))°"))
            return textTemplate
        case .circularSmall:
            let textTemplate = CLKComplicationTemplateCircularSmallSimpleText(textProvider: CLKSimpleTextProvider(text: "\(Int(temperature))°"))
            return textTemplate
        case .utilitarianSmall:
            let textTemplate = CLKComplicationTemplateUtilitarianSmallFlat(textProvider: CLKSimpleTextProvider(text: "\(Int(temperature))°"))
            return textTemplate
        case .extraLarge:
            let textTemplate = CLKComplicationTemplateExtraLargeSimpleText(textProvider: CLKSimpleTextProvider(text: "\(Int(temperature))°"))
            return textTemplate
        default:
            let textTemplate = CLKComplicationTemplateModularSmallSimpleText(textProvider: CLKSimpleTextProvider(text: "\(Int(temperature))°"))
            return textTemplate
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        handler(nil)
    }

    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(Date())
    }

    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }

    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }

    func getPlaceholderTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        let template = createTemplate(for: complication, temperature: 20)
        handler(template)
    }
}
