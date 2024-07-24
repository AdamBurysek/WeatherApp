//
//  WeatherWatchAppApp.swift
//  WeatherWatchApp Watch App
//
//  Created by Adam Buryšek on 17.07.2024.
//

import SwiftUI

@main
struct WeatherWatchApp_Watch_AppApp: App {
    @WKExtensionDelegateAdaptor(ExtensionDelegate.self) var extensionDelegate
      
      var body: some Scene {
          WindowGroup {
              NavigationView {
                  ContentView()
              }
          }
      }
}

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
    }
    
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        for task in backgroundTasks {
            task.setTaskCompletedWithSnapshot(false)
        }
    }
}
