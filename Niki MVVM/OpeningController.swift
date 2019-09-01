//
//  OpeningController.swift
//  Niki MVVM
//
//  Created by Daniel Prastiwa on 29/08/19.
//  Copyright © 2019 Segerwaras. All rights reserved.
//

import UIKit


class OpeningController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    private let TAG = String(describing: OpeningController.self)
    
    
    // MARK: - Events
    
    
    override func loadView() {
        let openingView = OpeningView() { [ weak self] in
            self?.didPressNextButtons()
        }
        
        view = openingView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Niki MVVM"
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        shout("VC", TAG)
    }
    
    
    deinit {
        shout("VC", "\(TAG) released")
    }
    
    
    fileprivate func didPressNextButtons() {
        coordinator?.gotoEmployeeList()
    }
}
