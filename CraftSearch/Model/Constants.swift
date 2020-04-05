//
//  Constants.swift
//  CraftSearch
//
//  Created by mkadam on 4/5/20.
//  Copyright © 2020 Craft Digital. All rights reserved.
//

import Foundation
struct Constants {
    struct APIHeaderKeys {
        static let apiKey = "x-rapidapi-key"
        static let apiHostkey = "x-rapidapi-host"
    }
    struct ParameterKeys {
        static let autoCorrectKey = "autoCorrect"
        static let pageNumber = "pageNumber"
        static let safeSearchKey = "safeSearch"
        static let pageSizeKey = "pageSize"
        static let queryKey = "q"
    }
}
