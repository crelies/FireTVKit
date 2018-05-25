//
//  Date+StringValue.swift
//  FireTVKit
//
//  Created by crelies on 25.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

extension Date {
    var stringValue: String {
        return Logger.dateFormatter.string(from: self)
    }
}
