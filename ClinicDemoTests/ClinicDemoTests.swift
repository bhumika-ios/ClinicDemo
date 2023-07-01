//
//  ClinicDemoTests.swift
//  ClinicDemoTests
//
//  Created by Bhumika Patel on 01/07/23.
//

import Foundation
import XCTest
@testable import ClinicDemo

class ClinicDemoTests: XCTestCase {

    var clinicViewModel: ClinicViewModel!
    
    override func setUp() {
        super.setUp()
        clinicViewModel = ClinicViewModel()
    }
    override func tearDown() {
        clinicViewModel = nil
        super.tearDown()
    }
    func testLoadClinics() {
       
        let expectation = XCTestExpectation(description: "Clinics loaded")
        
        clinicViewModel.loadClinics()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                   XCTAssertTrue(self.clinicViewModel.clinics.count > 0, "Clinics should be loaded")
                   expectation.fulfill()
               }
               
              // waitForExpectations(timeout: 5, handler: nil)
        }
    func testLoadTimeSlots() {
        
            clinicViewModel.loadTimeSlots(for: Clinic(displayName: "displayName", urlName: "urlName"))
    
            let expectation = XCTestExpectation(description: "Time slots loaded")
    
            let waitTime = TimeInterval(5)

            DispatchQueue.main.asyncAfter(deadline: .now() + waitTime) { [self] in
             
                XCTAssertFalse(clinicViewModel.showErrorDialog, "Error dialog should not be shown")
    
           
                expectation.fulfill()
            }
    
            wait(for: [expectation], timeout: waitTime + 1)
        }
}
