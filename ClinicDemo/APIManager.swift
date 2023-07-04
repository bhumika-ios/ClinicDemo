////
////  APIManager.swift
////  ClinicDemo
////
////  Created by Bhumika Patel on 04/07/23.
////
//

import Foundation
import Combine

class APIManager {
    private let clinicUrl = "https://api.care-uat.psjhealth.org/"
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchClinics() -> AnyPublisher<[Clinic], Error> {
        guard let url = URL(string: clinicUrl + "v1/departments") else {
            return Fail(error: NSError(domain: "Invalid URL", code: 0, userInfo: nil)).eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: url)
            .mapError { $0 as Error }
            .map(\.data)
            .decode(type: [Clinic].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchTimeSlots(for clinic: Clinic) -> AnyPublisher<TimeslotsResponse, Error> {
        guard let url = URL(string: clinicUrl + "v2/departments/\(clinic.urlName)/timeslots?visitTypeName=Illness") else {
            return Fail(error: NSError(domain: "Invalid URL", code: 0, userInfo: nil)).eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: url)
            .mapError { $0 as Error }
            .map(\.data)
            .decode(type: TimeslotsResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
