//
//  ClinicModel.swift
//  ClinicDemo
//
//  Created by Bhumika Patel on 29/06/23.
//

import SwiftUI

struct Clinic: Hashable,Codable {
    let displayName: String
    let urlName: String
}

struct TimeSlot: Hashable,Codable {
    let slotDateTime: String
}

struct TimeslotsResponse: Codable {
    let scheduleDays: [ScheduleDay]
}

struct ScheduleDay: Codable {
    let timeSlots: [TimeSlot]
}
