//
//  SNInterviewTests.swift
//  SNInterviewTests
//
//  Copyright © 2019 ServiceNow. All rights reserved.
//

import XCTest
@testable import SNInterview

class SNInterviewTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCoffeeShop() {
        let coffeeShop = CoffeeShop(name: "Test Coffee", review: "Test Review", rating: 1)
        XCTAssertEqual(coffeeShop.name, "Test Coffee")
        XCTAssertEqual(coffeeShop.review, "Test Review")
        XCTAssertEqual(coffeeShop.rating, 1)
    }
    
    //test read but corrupt data
    func testLoadFromJSON_fileNotExists() {
        do {
            let list: [CoffeeShop] = try JsonUtils.shared.loadJson(fileName: "")
            XCTAssertEqual(list.count, 5)
        } catch {
            XCTAssert(false, error.localizedDescription)
        }
    }
    
    //use corrupt data to test 
    func testLoadFromJSON_dataCorrupt() {
        do {
            let list: [CoffeeShop] = try JsonUtils.shared.loadJson(fileName: "CoffeeShops")
            XCTAssertEqual(list.count, 5)
        } catch {
            XCTAssert(false, error.localizedDescription)
        }
    }
    
    //test read func but fail by decoder
    func testLoadFromJSON_decodeFail() {
        do {
            struct Test: Decodable { let id : String}
            let list: [Test] = try JsonUtils.shared.loadJson(fileName: "CoffeeShops")
            XCTAssertEqual(list.count, 5)
        } catch {
            XCTAssert(false, error.localizedDescription)
        }
    }
    
    //test read func
    func testLoadFromJSON() {
        do {
            let list: [CoffeeShop] = try JsonUtils.shared.loadJson(fileName: "CoffeeShops")
            XCTAssertEqual(list.count, 5)
        } catch {
            XCTAssert(false, error.localizedDescription)
        }
    }
    
    //test save data to file
    func testSaveToJsonFile() {
        do {
            struct Test: Decodable {}
            let cs = CoffeeShop.init(name: "sadfsa", review: "312asda3", rating: 123)
            try JsonUtils.shared.saveJson(fileName: "CoffeeShops", data: [cs])
            do {
                let read: [CoffeeShop] = try JsonUtils.shared.loadJson(fileName: "CoffeeShops")
                XCTAssertEqual(read.count, 1)
            } catch  {
                XCTAssert(false, error.localizedDescription)
            }
        } catch {
            XCTAssert(false, error.localizedDescription)
        }
    }
    
}
