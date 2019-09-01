//
//  OpeningView.swift
//  Niki MVVM
//
//  Created by Daniel Prastiwa on 29/08/19.
//  Copyright © 2019 Segerwaras. All rights reserved.
//

import UIKit

class OpeningView: UIView {
    
    var nextAction: (() -> Void)?
    
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self,
                          action: #selector(didPressNextButtons(_:)),
                          for: .touchUpInside)
        return button
    }()
    
    
    init(nextAction: @escaping () -> Void) {
        self.nextAction = nextAction
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        addSubview(nextButton)
        
        NSLayoutConstraint.activate(
            [
                nextButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                nextButton.centerYAnchor.constraint(equalTo: centerYAnchor)
            ]
        )
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func didPressNextButtons(_ sender: UIButton) {
        nextAction?()
    }
    
    
}
