
//
//  StubResponse.swift
//  MoviesTests
//
//  Created by Chirag Kukreja on 02/02/19.
//  Copyright © 2019 Chirag Kukreja. All rights reserved.
//

import UIKit

final class StubResponse {
    static func fromJSONFile(_ fileName: String) -> Data {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            fatalError("Invalid path for json file")
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError("Invalid data from json file")
        }
        return data
    }
}
