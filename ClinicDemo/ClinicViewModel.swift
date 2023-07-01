//
//  ClinicViewModel.swift
//  ClinicDemo
//
//  Created by Bhumika Patel on 29/06/23.
//

import Foundation
import Combine

class ClinicViewModel: ObservableObject {
    @Published var clinics: [Clinic] = []
    @Published var selectedClinic: Clinic?
    @Published var todayTimeSlots: [TimeSlot] = []
    @Published var tomorrowTimeSlots: [TimeSlot] = []
    @Published var showErrorDialog = false
    
    func loadClinics() {
        guard let url = URL(string: "https://api.care-uat.psjhealth.org/v1/departments") else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                do {
                    let clinics = try JSONDecoder().decode([Clinic].self, from: data)
                    DispatchQueue.main.async {
                        self.clinics = clinics
                    }
                } catch {
                    print(error)
                }
            }
        }
        .resume()
    }
    
    func loadTimeSlots(for clinic: Clinic) {
        guard let url = URL(string: "https://api.care-uat.psjhealth.org/v2/departments/\(clinic.urlName)/timeslots?visitTypeName=Illness") else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(TimeslotsResponse.self, from: data)
//                    print(response)
                    DispatchQueue.main.async {
                        if let firstDay = response.scheduleDays.first {
                            self.todayTimeSlots = firstDay.timeSlots
                        } else {
                            self.todayTimeSlots = []
                        }
                        if let secondDay = response.scheduleDays.dropFirst().first {
                            self.tomorrowTimeSlots = secondDay.timeSlots
                        } else {
                            self.tomorrowTimeSlots = []
                        }
                        
                        if self.todayTimeSlots.isEmpty && self.tomorrowTimeSlots.isEmpty {
                            self.showErrorDialog = true
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
        .resume()
    }
}

