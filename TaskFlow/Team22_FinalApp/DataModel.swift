//
//  DataModel.swift
//  Team22_FinalApp
//
//  Created by Hidayet Kaya on 12/4/24.
//

import Foundation

enum UrgencyLevel: String, CaseIterable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

struct Task: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var date: Date
    var urgency: UrgencyLevel

    init(id: UUID = UUID(), title: String, description: String, date: Date, urgency: UrgencyLevel) {
        self.id = id
        self.title = title
        self.description = description
        self.date = date
        self.urgency = urgency
    }
}

