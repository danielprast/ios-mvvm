//
//  EmployeeCell.swift
//  Niki MVVM
//
//  Created by Daniel Prastiwa on 29/08/19.
//  Copyright © 2019 Segerwaras. All rights reserved.
//

import UIKit

class EmployeeCell: UITableViewCell {
    
    private var viewModel = EmployeeViewModel()
    
    let employeeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(employeeLabel)
        employeeLabel.text = "-"
        employeeLabel.numberOfLines = 1
        
        employeeLabel.anchor(top: nil, left: leftAnchor,
                             bottom: nil, right: rightAnchor,
                             paddingTop: 0, paddingLeft: 16,
                             paddingBottom: 0, paddingRight: 16,
                             width: 0, height: 30)
        
        employeeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        viewModel.employeeName.bind { [weak self] employeeNameData in
            self?.attachEmployeeNameData(employeeNameData)
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureCell(employeeData epl: Employee) {
        viewModel.updateEmployee(newEmployee: epl)
    }
    
    
    // MARK: - Private
    
    
    private func attachEmployeeNameData(_ name: String) {
        employeeLabel.text = name
    }
    
}
