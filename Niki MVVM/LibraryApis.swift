//
//  LibraryApis.swift
//  Niki MVVM
//
//  Created by Daniel Prastiwa on 29/08/19.
//  Copyright © 2019 Segerwaras. All rights reserved.
//

import Foundation

final class LibraryApis {
    
    static let shared = LibraryApis()
    private init() {}
    
    private let TAG = String(describing: LibraryApis.self)
    var employeeService = EmployeeService()
    
}
