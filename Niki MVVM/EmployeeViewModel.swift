//
//  EmployeeViewModel.swift
//  Niki MVVM
//
//  Created by Daniel Prastiwa on 29/08/19.
//  Copyright © 2019 Segerwaras. All rights reserved.
//

import Foundation


class EmployeeViewModel {
    
    private var employee: Employee {
        didSet {
            employeeName.value = "Agent \(employee.employee_name)"
        }
    }
    
    var employeeName = Box("")
    
    init(_ employee: Employee = Employee()) {
        self.employee = employee
    }
    
}



extension EmployeeViewModel {
    
    func updateEmployee(newEmployee epl: Employee) {
        self.employee = epl
    }
    
    
    func updateEmployeeName(name: String) {
        var updatedEmployee = employee
        updatedEmployee.employee_name = name
        updateEmployee(newEmployee: updatedEmployee)
    }
    
}
