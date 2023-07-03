//
//  TimeSlotListView.swift
//  ClinicDemo
//
//  Created by Bhumika Patel on 03/07/23.
//

import SwiftUI

struct TimeSlotListView: View {
    let clinic: Clinic
    let todayTimeSlots: [TimeSlot]
    let tomorrowTimeSlots: [TimeSlot]
    var body: some View {
        VStack {
            List {
                Section(header: Text("Today")) {
                    ForEach(todayTimeSlots, id: \.slotDateTime) { timeSlot in
                        Text(timeSlot.slotDateTime)
                    }
                }
                
                Section(header: Text("Tomorrow")) {
                    ForEach(tomorrowTimeSlots, id: \.slotDateTime) { timeSlot in
                        Text(timeSlot.slotDateTime)
                    }
                }
            }
        }
        .navigationTitle(clinic.urlName)
    }
}


//struct TimeSlotListView_Previews: PreviewProvider {
//    static var previews: some View {
//        TimeSlotListView()
//    }
//}
