//
//  EmployeeListViewModel.swift
//  Niki MVVM
//
//  Created by Daniel Prastiwa on 29/08/19.
//  Copyright © 2019 Segerwaras. All rights reserved.
//

import Foundation


class EmployeeListViewModel {
    
    private var employeesDataSource: [Employee] {
        didSet {
            employees.value = employeesDataSource
        }
    }
    
    private var errors = "" {
        didSet {
            errorMessage.value = errors
        }
    }
    
    var errorMessage = Box("")
    var showProgress = Box(false)
    var employees = Box([Employee]())
    
    init(_ employees: [Employee] = [Employee]()) {
        self.employeesDataSource = employees
    }
    
    func employee(at index: Int) -> Employee {
        return employees.value[index]
    }
    
    func employeeTotalCount() -> Int {
        return employees.value.count
    }
    
}


extension EmployeeListViewModel {
    
    func fetchEmployeeData() {
        showProgress.value = true
        LibraryApis.shared.employeeService.getAllEmployees(failure: {
            [ weak self] (error: NError) in
            shout("Error Fetching Employee Data", error.errorDescription)
            DispatchQueue.main.async {
                self?.showProgress.value = false
                self?.errors = error.errorDescription
            }
        }) { [weak self] (employees: [Employee]) in
            DispatchQueue.main.async {
                self?.showProgress.value = false
                self?.employeesDataSource = employees
            }
        }
    }
    
}
