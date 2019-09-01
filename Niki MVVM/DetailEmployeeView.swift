//
//  DetailEmployeeView.swift
//  Niki MVVM
//
//  Created by Daniel Prastiwa on 01/09/19.
//  Copyright © 2019 Segerwaras. All rights reserved.
//

import UIKit

class DetailEmployeeView: UIView {
    
    var buttonAction: (() -> Void)?
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.text = "-"
        return label
    }()
    
    
    let button: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Thor, Hit Me!", for: .normal)
        btn.addTarget(self, action: #selector(handleButtonPressed), for: .touchUpInside)
        return btn
    }()
    
    
    init(buttonAction: @escaping () -> Void) {
        super.init(frame: .zero)
        
        self.buttonAction = buttonAction
        
        backgroundColor = .white
        addSubview(titleLabel)
        addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.anchor(top: safeAreaLayoutGuide.topAnchor, left: nil,
                          bottom: nil, right: nil,
                          paddingTop: 0, paddingLeft: 0,
                          paddingBottom: 0, paddingRight: 24,
                          width: 0, height: 32)
        
        NSLayoutConstraint.activate(
            [
                titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                button.centerXAnchor.constraint(equalTo: centerXAnchor),
                button.centerYAnchor.constraint(equalTo: centerYAnchor)
            ]
        )
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - actions
    @objc fileprivate func handleButtonPressed() {
        buttonAction?()
    }
    
}
