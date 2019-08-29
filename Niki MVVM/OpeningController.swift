//
//  OpeningController.swift
//  Niki MVVM
//
//  Created by Daniel Prastiwa on 29/08/19.
//  Copyright © 2019 Segerwaras. All rights reserved.
//

import UIKit


class OpeningController: UIViewController, SetupViewControllerProtocol {
    
    
    private let TAG = String(describing: OpeningController.self)
    private lazy var ui: OpeningView = {
        let view = OpeningView()
        return view
    }()
    
    
    // MARK: - Events
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewActions()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        shout("VC", TAG)
    }
    
    
    deinit {
        shout("VC", "\(TAG) released")
    }
    
    
    // MARK: - View Actions
    
    
    @objc private func didPressNextButtons(_ sender: UIButton) {
        gotoEmployeeList()
    }
    
    
    // MARK: - View Protocol
    
    
    func setupView() {
        navigationItem.title = "Niki MVVM"
        
        view.backgroundColor = .white
        
        view.addSubview(ui.nextButton)
        
        NSLayoutConstraint.activate(
            [
                ui.nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                ui.nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ]
        )
        
    }
    
    
    func setupViewActions() {
        ui.nextButton.addTarget(self,
                                action: #selector(didPressNextButtons(_:)),
                                for: .touchUpInside)
        
        
    }
    
    
    // MARK: - private
    
    
    private func gotoEmployeeList() {
        let eplVC = EmployeesController()
        navigationController?.pushViewController(eplVC, animated: true)
    }
    
}
