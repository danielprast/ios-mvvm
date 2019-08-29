//
//  Employee.swift
//  Niki MVVM
//
//  Created by Daniel Prastiwa on 29/08/19.
//  Copyright © 2019 Segerwaras. All rights reserved.
//

import Foundation


struct Employee: Codable {
    var id: String = ""
    var employee_name: String = ""
}

typealias EmployeeList = [Employee]
