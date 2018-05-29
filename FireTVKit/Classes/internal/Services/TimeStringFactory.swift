//
//  TimeStringFactory.swift
//  FireTVKit
//
//  Created by crelies on 09.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

protocol TimeStringFactoryProvider {
    var timeStringFactory: TimeStringFactoryProtocol { get }
}

protocol TimeStringFactoryProtocol {
    func makeTimeString(fromMilliseconds milliseconds: Float) -> String
}

final class TimeStringFactory: TimeStringFactoryProtocol {
    func makeTimeString(fromMilliseconds milliseconds: Float) -> String {
        let valueInSeconds = Int(milliseconds / 1000)
        let hours = Int(valueInSeconds / 60 / 60)
        let minutes = Int(valueInSeconds / 60) - (hours * 60)
        let seconds = Int(valueInSeconds) - (hours * 60 * 60) - (minutes * 60)
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
