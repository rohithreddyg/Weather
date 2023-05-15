//
//  WeatherViewModelTests.swift
//  WeatherTests
//
//  Created by Rohith Reddy Gurram on 5/14/23.
//

import XCTest
@testable import Weather

final class WeatherViewModelTests: XCTestCase {
    let weatherVM = WeatherViewModel()

    func testTempString() throws {
        let expectedResult = "86ºF"
        let actualResult = weatherVM.tempStringFor(temp: 86.16)
        XCTAssertNotNil(actualResult)
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    func testPressureInHg() throws {
        let actualResult = weatherVM.pressureInHgFrom(pressure: 1010)
        let expectedResult = "29.83 inHg"
        XCTAssertNotNil(actualResult)
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    func testCalculationOfGMT() throws {
        let actualResult = weatherVM.calculateGMT(time: -25200)
        let expectedResult = "GMT-07"
        XCTAssertNotNil(actualResult)
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    func testHourStringFromDate() throws {
        let date = Date(timeIntervalSince1970: 1684150109)
        let actualResult = weatherVM.getHourStringFrom(date: date)
        let expectedResult = "4:28"
        XCTAssertNotNil(actualResult)
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    func testDateStringFromDate() throws {
        let date = Date(timeIntervalSince1970: 1684139721)
        let actualResult = weatherVM.getDateTimeFrom(date: date)
        let expectedResult = "May 15, 2023 at 1:35 AM"
        XCTAssertNotNil(actualResult)
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    func testHourStringFromDateWithTimezone() throws {
        let date = Date(timeIntervalSince1970: 1684199919)
        let actualResult = weatherVM.getHourStringFrom(date: date, timezone: -18000)
        let expectedResult = "8:18"
        XCTAssertNotNil(actualResult)
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    func testDateStringFromDateWithTimezone() throws {
        let date = Date(timeIntervalSince1970: 1684139721)
        let actualResult = weatherVM.getDateTimeFrom(date: date, timezone: -18000)
        let expectedResult = "May 15, 2023 at 3:35 AM"
        XCTAssertNotNil(actualResult)
        XCTAssertEqual(actualResult, expectedResult)
    }

}
