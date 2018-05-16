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
    func makeTimeString(fromMilliseconds value: Int64) -> String
    func makeTimeString(fromPositionValue positionValue: Float) -> String
}

final class TimeStringFactory: TimeStringFactoryProtocol {
    func makeTimeString(fromMilliseconds value: Int64) -> String {
        let valueInSeconds = Int(value / 1000)
        let hours = Int(valueInSeconds / 60 / 60)
        let minutes = Int(valueInSeconds / 60) - (hours * 60)
        let seconds = Int(valueInSeconds) - (minutes * 60)
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func makeTimeString(fromPositionValue positionValue: Float) -> String {
        let positionValueInSeconds = Int64(positionValue / 1000)
        let hours = Int64(positionValueInSeconds / 60 / 60)
        let minutes = Int64(positionValueInSeconds / 60) - (hours * 60)
        let seconds = Int64(positionValueInSeconds) - (minutes * 60)
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
