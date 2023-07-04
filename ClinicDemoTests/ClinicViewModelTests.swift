//
//  ClinicViewModelTests.swift
//  ClinicDemoTests
//
//  Created by Bhumika Patel on 04/07/23.
//

import Foundation
import Combine
import XCTest
@testable import ClinicDemo

class ClinicViewModelTests: XCTestCase {
    var viewModel: ClinicViewModel!
    var apiManager: MAPIManager!

    override func setUp() {
        super.setUp()
        apiManager = MAPIManager()
        viewModel = ClinicViewModel(apiManager: apiManager)
    }

    override func tearDown() {
        viewModel = nil
        apiManager = nil
        super.tearDown()
    }

    func testLoadClinics_Success() {
        apiManager.clinicsResponse = [.init(displayName: "Providence ExpressCare Lake Stevens", urlName: "LakeStevens")]

        viewModel.loadClinics()

//        XCTAssertEqual(viewModel.clinics.count, 1)
//        XCTAssertEqual(viewModel.clinics[0].displayName, "Providence ExpressCare Lake Stevens")
       
    }

    func testLoadClinics_Failure() {
        apiManager.shouldFail = true

        viewModel.loadClinics()
        // respose added

    }

    
    class MAPIManager: APIManager {
        var shouldFail = false
        var clinicsResponse: [Clinic] = []

        override func fetchClinics() -> AnyPublisher<[Clinic], Error> {
            if shouldFail {
                return Fail(error: NSError(domain: "Mock Error", code: 1, userInfo: nil)).eraseToAnyPublisher()
            } else {
                return Just(clinicsResponse).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
        }

       
    }
}

