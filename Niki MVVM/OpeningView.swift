//
//  OpeningView.swift
//  Niki MVVM
//
//  Created by Daniel Prastiwa on 29/08/19.
//  Copyright © 2019 Segerwaras. All rights reserved.
//

import UIKit

class OpeningView: UIView {
    
    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Lanjooot", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
}
