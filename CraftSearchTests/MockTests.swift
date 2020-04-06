//
//  Mock.swift
//  CraftSearchTests
//
//  Created by mkadam on 4/6/20.
//  Copyright © 2020 Craft Digital. All rights reserved.
//

import UIKit
import XCTest
class MockTests: XCTestCase {
    func getJsonFromFileName(fileName: String) -> [String: AnyObject]? {
        if let path = Bundle(for: type(of: self)).path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                return jsonResult as? [String: AnyObject]
            } catch {
                return nil
            }
        }
        return nil
    }
}
