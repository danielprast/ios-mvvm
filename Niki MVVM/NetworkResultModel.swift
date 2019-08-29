//
//  NetworkResultModel.swift
//  Niki MVVM
//
//  Created by Daniel Prastiwa on 29/08/19.
//  Copyright © 2019 Segerwaras. All rights reserved.
//

import Foundation


enum RequestResult<D, E: Error> {
    case success(D)
    case failure(E)
}


enum ErrorType {
    case invalidUrl(url: String)
    case requestFailure(reason: String)
    case unauthorized
    case internalServerError
    case parsingError
}


class NError: Error {
    
    static let shared = NError()
    private init() {}
    
    
    var errorType: ErrorType?
    
    
    public var url: String {
        guard let type = errorType else { return "" }
        switch type {
        case .invalidUrl(let url):
            return url
        default:
            break
        }
        return ""
    }
    
    
    public var errorDescription: String {
        guard let type = errorType else { return "" }
        switch type {
        case .invalidUrl(let url):
            return "Invalid URL format: \(url)"
        case .requestFailure(let reason):
            return reason
        case .unauthorized:
            return "Your credential is invalid."
        case .internalServerError:
            return "Internal server error occured"
        case .parsingError:
            return "Parsing error occured"
        }
    }
    
    
    init(type: ErrorType) {
        self.errorType = type
    }
    
}


class NData {
    
    private var data: Data?
    
    
    var jsonString: NSString {
        var theStr = ""
        
        guard
            let data = self.data,
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as Any
            else { return NSString(string: theStr) }
        
        let isValidJson = JSONSerialization.isValidJSONObject(json as Any)
        if isValidJson, let jsonObj = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            theStr = String(data: jsonObj, encoding: String.Encoding.utf8) ?? ""
        }
        
        return NSString(string: theStr)
    }
    
    
    public var jsonData: Data? {
        get {
            guard let str = jsonString as String? else { return nil }
            return str.data(using: String.Encoding.utf8)
        }
    }
    
    
    init(_ data: Data) {
        self.data = data
    }
    
    
    func jsonSerialize(_ data: Data, _ options: JSONSerialization.ReadingOptions = []) -> Any? {
        return try? JSONSerialization.jsonObject(with: data, options: options) as Any
    }
    
    
    func jsonDecode<T: Codable>(_ data: Data) -> T? {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch let err {
            shout("Decoding Error", "Failed to decode json: \(err.localizedDescription)")
        }
        
        return nil
    }
    
}
