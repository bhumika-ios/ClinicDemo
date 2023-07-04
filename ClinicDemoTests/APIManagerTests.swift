//
//  APIManagerTests.swift
//  ClinicDemo
//
//  Created by Bhumika Patel on 04/07/23.
//

import Foundation
import Combine
import XCTest
@testable import ClinicDemo

class APIManagerTests: XCTestCase {
    var apiManager: APIManager!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        apiManager = APIManager()
    }

    override func tearDown() {
        apiManager = nil
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        super.tearDown()
    }

    func testFetchClinics() {
      
        let expectation = XCTestExpectation(description: "Fetch clinics")
        
        let publisher = apiManager.fetchClinics()
        
        let cancellable = publisher.sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                XCTFail("Error fetching clinics: \(error.localizedDescription)")
            case .finished:
                expectation.fulfill()
            }
        }, receiveValue: { clinics in
            XCTAssertFalse(clinics.isEmpty, "Fetched clinics should not be empty")
        })
        
        cancellables.insert(cancellable)
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchTimeSlots() {
        
        let clinic = Clinic(displayName: "Providence ExpressCare Lake Stevens", urlName: "LakeStevens") // Provide a valid clinic object
        let expectation = XCTestExpectation(description: "Fetch time slots")
        
        let publisher = apiManager.fetchTimeSlots(for: clinic)
        
        let cancellable = publisher.sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                XCTFail("Error fetching time slots: \(error.localizedDescription)")
            case .finished:
                expectation.fulfill()
            }
        }, receiveValue: { timeslotsResponse in
            // Add response
            
        })
        
        cancellables.insert(cancellable)
        wait(for: [expectation], timeout: 5.0)
    }
}
