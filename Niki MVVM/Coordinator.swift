//
//  Coordinator.swift
//  Niki MVVM
//
//  Created by Daniel Prastiwa on 30/08/19.
//  Copyright © 2019 Segerwaras. All rights reserved.
//

import UIKit


protocol Coordinator {
    var navigationController: UINavigationController { get set }
    var children: [Coordinator] { get set }
    func start()
}
