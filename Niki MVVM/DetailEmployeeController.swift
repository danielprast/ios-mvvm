//
//  DetailEmployeeController.swift
//  Niki MVVM
//
//  Created by Daniel Prastiwa on 01/09/19.
//  Copyright © 2019 Segerwaras. All rights reserved.
//

import UIKit

class DetailEmployeeController: UIViewController {
    
    var employee: Employee!
    fileprivate let TAG = String(describing: DetailEmployeeController.self)
    fileprivate var ui: DetailEmployeeView!
    fileprivate lazy var viewModel: EmployeeViewModel = {
       let vm = EmployeeViewModel(employee)
        return vm
    }()
    
    
    override func loadView() {
        ui = DetailEmployeeView { [weak self] in
            self?.viewModel.updateEmployeeName(name: "Stark")
            self?.ui.titleLabel.text = "love ya 3000!"
        }
        
        view = ui
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.employeeName.bind { [unowned self] in
            self.navigationItem.title = $0
        }
        
        viewModel.updateEmployee(newEmployee: employee)
    }
    
    
    deinit {
        shout("VC", "\(TAG) released")
    }

}
