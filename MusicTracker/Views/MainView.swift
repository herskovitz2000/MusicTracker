//
//  MainView.swift
//  MusicTracker
//
//  Created by Nathan Herskovitz on 11/30/24.
//

import SwiftUI

struct MainView: View
{
    @ObservedObject var appState : AppState
    
    init()
    {
        appState = AppState()
    }
    
    var body: some View {
        ZStack{
            switch appState.CurrentView{
            case .LandingPage:
                //LandingPage()
                
                TabView {
                    LandingPage()
                        .tabItem {
                            Label("Library", systemImage: "music.note")
                        }
                    
                    SettingsView()
                        .tabItem {
                            Label("Settings", systemImage: "gear")
                        }
                }
                .accentColor(.blue) // Customize the color of the selected tab item
                 
            }
            
        }
        .environmentObject(appState)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
