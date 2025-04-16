//
//  AppState.swift
//  MusicTracker
//
//  Created by Nathan Herskovitz on 11/30/24.
//

import Foundation

enum ViewEnum
{
    case LandingPage
}

class AppState: ObservableObject
{
    @Published var CurrentView : ViewEnum = .LandingPage
}
