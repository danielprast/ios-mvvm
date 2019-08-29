//
//  PeopleService.swift
//  Niki MVVM
//
//  Created by Daniel Prastiwa on 29/08/19.
//  Copyright © 2019 Segerwaras. All rights reserved.
//

import Foundation


class EmployeeService {
    
    func getAllEmployees(failure: @escaping Networking.FailureRequestHandler,
                         completion: @escaping ([Employee]) -> Void)
    {
        let path = Constants.Path.employees
        
        Networking.sharedInstance.requestData(url: Constants.baseURL.appending(path),
                                              method: .get)
        { (result: RequestResult<NData, NError>) in
            switch result {
            case .success(let data):
                guard
                    let dataObj = data.jsonData,
                    let response: EmployeeList = data.jsonDecode(dataObj)
                    else {
                        failure(NError(type: .parsingError))
                        return
                }
                
                completion(response)
                
                break
            case .failure(let error):
                failure(error)
                break
            }
        }
    }
    
}
