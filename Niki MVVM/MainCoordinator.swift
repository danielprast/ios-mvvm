//
//  MainCoordinator.swift
//  Niki MVVM
//
//  Created by Daniel Prastiwa on 30/08/19.
//  Copyright © 2019 Segerwaras. All rights reserved.
//

import UIKit


class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    var children = [Coordinator]()
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
    func start() {
        let openingVC = OpeningController()
        openingVC.coordinator = self
        navigationController.pushViewController(openingVC, animated: true)
    }
    
    
    func gotoEmployeeList() {
        let eplVC = EmployeesController()
        eplVC.coordinator = self
        navigationController.pushViewController(eplVC, animated: true)
    }
    
    
    func show(_ employee: Employee) {
        let detailEmployeeController = DetailEmployeeController()
        detailEmployeeController.employee = employee
        navigationController.pushViewController(detailEmployeeController, animated: true)
    }
}
