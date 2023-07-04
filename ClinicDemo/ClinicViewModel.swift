//
//  ClinicViewModel.swift
//  ClinicDemo
//
//  Created by Bhumika Patel on 29/06/23.
//
//
import Foundation
import Combine

class ClinicViewModel: ObservableObject {
    @Published var clinics: [Clinic] = []
    @Published var selectedClinic: Clinic?
    @Published var todayTimeSlots: [TimeSlot] = []
    @Published var tomorrowTimeSlots: [TimeSlot] = []
    @Published var showErrorDialog = false
    @Published var errorMessage: String = ""
    @Published var title: String = ""
    private var cancellables: Set<AnyCancellable> = []
    let apiManager: APIManager

    init(apiManager: APIManager = APIManager()) {
        self.apiManager = apiManager
    }

    func loadClinics() {
        apiManager.fetchClinics()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.handleError(error)
                }
            } receiveValue: { [weak self] clinics in
                self?.clinics = clinics
            }
            .store(in: &cancellables)
    }

    func loadTimeSlots(for clinic: Clinic) {
        apiManager.fetchTimeSlots(for: clinic)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.handleError(error)
                }
            } receiveValue: { [weak self] response in
                if let firstDay = response.scheduleDays.first {
                    self?.todayTimeSlots = firstDay.timeSlots
                } else {
                    self?.todayTimeSlots = []
                }
                if let secondDay = response.scheduleDays.dropFirst().first {
                    self?.tomorrowTimeSlots = secondDay.timeSlots
                } else {
                    self?.tomorrowTimeSlots = []
                }

                if self?.todayTimeSlots.isEmpty ?? true && self?.tomorrowTimeSlots.isEmpty ?? true {
                    self?.errorMessage = "No appointments available."
                    self?.title = "Sorry"
                    self?.showErrorDialog = true
                }
            }
            .store(in: &cancellables)
    }

   

    private func handleError(_ error: Error) {
        title = "Error"
        errorMessage = (error.localizedDescription)
        showErrorDialog = true
    }
   
}
