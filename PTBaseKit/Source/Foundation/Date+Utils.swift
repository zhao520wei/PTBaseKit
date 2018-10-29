//
//  Date+Utils.swift
//  PTBaseKit
//
//  Created by P36348 on 29/10/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import Foundation

extension Date {
    public func string(withFormat format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
}
