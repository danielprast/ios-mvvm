//
//  HomeController.swift
//  Niki MVVM
//
//  Created by Daniel Prastiwa on 29/08/19.
//  Copyright © 2019 Segerwaras. All rights reserved.
//

import UIKit


class EmployeesController: UITableViewController, SetupViewControllerProtocol {
    
    private let TAG = String(describing: EmployeesController.self)
    private var cellId = "cellId"
    private var viewModel = EmployeeListViewModel()
    
    
    // MARK: - Events
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewActions()
        setupViewModel()
        viewModel.fetchEmployeeData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        shout("VC", TAG)
    }
    
    
    deinit {
        shout("VC", "\(TAG) released")
    }
    
    
    // MARK: - Setup View & ViewModel
    
    
    func setupView() {
        navigationItem.title = "All Employees"
        
        view.backgroundColor = .white
        
        tableView.register(EmployeeCell.self, forCellReuseIdentifier: cellId)
        tableView.estimatedRowHeight = 44.0
    }
    
    
    func setupViewActions() {
        // nothing for now
    }
    
    
    func setupViewModel() {
        viewModel.employees.bind { [unowned self] _ in
            self.tableView.reloadData()
        }
        
        viewModel.errorMessage.bind { _ in
            // showing error message
        }
        
        viewModel.showProgress.bind { _ in
            // handle progress indicator
        }
    }
    
}



extension EmployeesController {
    // MARK: - TableView and DataSource Delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.employees.value.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EmployeeCell
        let employee = viewModel.employees.value[indexPath.row]
        cell.configureCell(employeeData: employee)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let employee = viewModel.employees.value[indexPath.row]
        shout("Employee Data", employee)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
