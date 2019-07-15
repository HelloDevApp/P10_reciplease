//
//  UserDefaultsTest.swift
//  P10_RecipleaseTests
//
//  Created by macbook pro on 15/07/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import P10_Reciplease
import XCTest

class UserDefaultsTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    var arr = [String]()
    let key = "Test"
    let fakeUserDefaultsManager = FakeUserDefaultsManager()
    
    func resetObjectInFakeUD(key: String) {
        fakeUserDefaultsManager.removeAll(to: &arr, key: key)
    }
    
    func testSetArrayInUserDefaultsShouldBeOK() {
        arr.append("item1")
        fakeUserDefaultsManager.set(to: arr, key: key)
        
        XCTAssertEqual(fakeUserDefaultsManager.key, key)
        XCTAssertEqual(fakeUserDefaultsManager.array, arr)
    }
    
    func testSetItemAndRemoveOfUserDefaultsShouldBeOK() {
        arr.append("item2")
        XCTAssertNotEqual(arr, fakeUserDefaultsManager.array)
        
        fakeUserDefaultsManager.set(to: arr, key: key)
        
        XCTAssertEqual(arr, fakeUserDefaultsManager.array)
        
        let indexPath = IndexPath(row: 0, section: 0)
        fakeUserDefaultsManager.remove(to: &arr, key: key, indexPath: indexPath)
        
        XCTAssertEqual(arr, fakeUserDefaultsManager.array)
    }
    
    func testRemoveAllItemsOfUserDefaults() {
        
        fakeUserDefaultsManager.set(to: ["item2", "Items3", "items4"], key: key)
        XCTAssert(fakeUserDefaultsManager.array.count == 3)
        fakeUserDefaultsManager.get(to: &arr, key: key)
        resetObjectInFakeUD(key: key)
        //        fakeUD.removeObject(forKey: key)
        print(fakeUserDefaultsManager.array.isEmpty)
        XCTAssert(fakeUserDefaultsManager.array.isEmpty)
        
    }
    
    func testGetArrayInUserDefaultsShouldBeCorrect() {
        arr.append("item")
        fakeUserDefaultsManager.get(to: &arr, key: key)
        XCTAssertEqual(fakeUserDefaultsManager.key, key)
        XCTAssertEqual(fakeUserDefaultsManager.array, arr)
        
    }
    
    func testWhenGetArrayEmptyInUserDefault() {
        arr.append("item")
        fakeUserDefaultsManager.set(to: arr, key: key)
        fakeUserDefaultsManager.removeObject(forKey: key)
        fakeUserDefaultsManager.get(to: &arr, key: key)
        XCTAssert(arr.isEmpty)
        XCTAssertEqual(arr, fakeUserDefaultsManager.array)
        
    }
}
