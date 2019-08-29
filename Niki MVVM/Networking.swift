//
//  Networking.swift
//  Niki MVVM
//
//  Created by Daniel Prastiwa on 29/08/19.
//  Copyright © 2019 Segerwaras. All rights reserved.
//

import Foundation
import UIKit


enum NetworkingHTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}


class Networking {
    
    //singleton
    static let sharedInstance = Networking()
    private init() {}
    
    private let TAG: String = String(describing: Networking.self)
    
    typealias CompletionHandler = (RequestResult<NData,NError>) -> Void
    typealias FailureRequestHandler = (NError) -> Void
    typealias RequestHeaders = [String:String]
    typealias RequestParameters = [String : Any]
    
    //URLSession
    private lazy var defaultSession = URLSession(configuration: self.sessionConfig)
    private let sessionConfig: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 180.0
        config.timeoutIntervalForResource = 180.0
        return config
    }()
    
    //URLSessionTask
    private var dataTask: URLSessionDataTask?
    private let downloadTask: URLSessionDownloadTask? = nil
    private let uploadTask: URLSessionUploadTask? = nil
    private var errorMessage = ""
    
    
    
    
    // MARK: - Request Tasks
    
    public func requestData(url path: String,
                            method: NetworkingHTTPMethod = .post,
                            headers: RequestHeaders? = nil,
                            parameters: RequestParameters? = nil,
                            completion: @escaping CompletionHandler)
    {
        
        dataTask?.cancel()
        
        guard
            var urlComponent = URLComponents(string: path)
            else {
                let err = NError(type: .invalidUrl(url: path))
                let responseResult: RequestResult<NData, NError> = .failure(err)
                completion(responseResult)
                return
        }
        
        // setup encoded queries
        if method == .get {
            if let params = parameters {
                var queries: [String] = []
                params.forEach({ (key: String, value: Any) in
                    let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
                    let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
                    queries.append(escapedKey + "=" + escapedValue)
                })
                
                urlComponent.query = queries.joined(separator: "&")
            }
        }
        
        guard
            let url = urlComponent.url
            else {
                let err = NError(type: .invalidUrl(url: path))
                let responseResult: RequestResult<NData, NError> = .failure(err)
                completion(responseResult)
                return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let headers = headers {
            for header in headers {
                request.setValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        
        // setup post params
        if method != .get {
            if let params = parameters {
                request.httpBody = params.percentEscaped().data(using: .utf8)
            }
        }
        
        shout("\(TAG) Headers", headers as Any)
        shout("\(TAG) Params", parameters as Any)
        shout("\(TAG) Request", request)
        //dump(request)
        
        dataTask = defaultSession.dataTask(with: request) {
            data, response, error in
            defer { self.dataTask = nil }
            self.handleNetworkingResult(data, response, error, completion)
        }
        
        dataTask?.resume()
    }
    
    
    
    
    public func requestGet(withUrl path: String,
                           queries: String? = nil,
                           headers: RequestHeaders? = [:],
                           completion: @escaping CompletionHandler)
    {
        dataTask?.cancel()
        
        guard
            var urlComponent = URLComponents(string: path)
            else {
                let err = NError(type: .invalidUrl(url: path))
                let responseResult: RequestResult<NData, NError> = .failure(err)
                
                completion(responseResult)
                
                return
        }
        
        if let queries = queries {
            urlComponent.query = queries
        }
        
        guard
            let url = urlComponent.url
            else {
                let err = NError(type: .invalidUrl(url: path))
                let responseResult: RequestResult<NData, NError> = .failure(err)
                
                completion(responseResult)
                
                return
        }
        
        var request = URLRequest(url: url)
        
        if let headers = headers {
            for header in headers {
                request.setValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        
        shout("Data Task", "GET Request")
        shout("urlPath", url)
        shout("queries", "\(queries ?? "")")
        shout("headers", headers as Any)
        
        dataTask = defaultSession.dataTask(with: request, completionHandler: {
            (data: Data?, response: URLResponse?, error: Error?) in
            self.handleNetworkingResult(data, response, error, completion)
        })
        
        dataTask?.resume()
    }
    
    
    
    
    func requestPost(url path: String,
                     headers: RequestHeaders,
                     parameters: RequestParameters? = nil,
                     completion: @escaping CompletionHandler)
    {
        dataTask?.cancel()
        
        guard
            let urlComponent = URLComponents(string: path),
            let url = urlComponent.url
            else {
                let err = NError(type: .invalidUrl(url: path))
                let responseResult: RequestResult<NData, NError> = .failure(err)
                
                completion(responseResult)
                
                return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = NetworkingHTTPMethod.post.rawValue
        
        for header in headers {
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        if let params = parameters {
            request.httpBody = params.percentEscaped().data(using: .utf8)
        }
        
        shout("\(TAG) Request", request)
        //dump(request)
        
        dataTask = defaultSession.dataTask(with: request) {
            data, response, error in
            defer { self.dataTask = nil }
            self.handleNetworkingResult(data, response, error, completion)
        }
        
        dataTask?.resume()
    }
    
    
    
    
    func requestWithMultipart(url path: String,
                              method: String = "POST",
                              headers: RequestHeaders,
                              parameters: RequestParameters? = nil,
                              media: [Media]?,
                              completion: @escaping CompletionHandler)
    {
        
        dataTask?.cancel()
        
        guard
            let urlComponent = URLComponents(string: path),
            let url = urlComponent.url
            else {
                let err = NError(type: .invalidUrl(url: path))
                let responseResult: RequestResult<NData, NError> = .failure(err)
                
                completion(responseResult)
                
                return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        let boundary = generateBoundaryString()
        let formDataBody = createDataBody(withParameters: parameters,
                                          media: media,
                                          boundary: boundary)
        
        for header in headers {
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        request.setValue("multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type")
        
        request.httpBody = formDataBody
        
        dump(request)
        
        dataTask = defaultSession.dataTask(with: request) {
            (data: Data?, response: URLResponse?, error: Error?) in
            defer { self.dataTask = nil }
            self.handleNetworkingResult(data, response, error, completion)
        }
        
        dataTask?.resume()
    }
    
    
    
    
    // MARK: - Private
    
    fileprivate func handleNetworkingResult(_ data: Data?,
                                            _ response: URLResponse?,
                                            _ error: Error?,
                                            _ completion: @escaping CompletionHandler) {
        
        if let error = error {
            shout(TAG, error)
            errorMessage += "Data task error occured: \(error.localizedDescription)\n"
            
            let errObj = NError(type: .requestFailure(reason: errorMessage))
            completion(.failure(errObj))
            
            errorMessage = ""
        } else if let data = data,
            let response = response as? HTTPURLResponse {
            //shout(TAG, "Response: \(response)")
            
            let nData = NData(data)
            shout("\(TAG) NData:", nData.jsonString)
            
            var responseType: RequestResult<NData, NError>
            switch response.statusCode {
            case 200...300:
                responseType = .success(nData)
            case 500:
                let err = NError(type: .internalServerError)
                responseType = .failure(err)
            case 401:
                let err = NError(type: .unauthorized)
                responseType = .failure(err)
            default:
                let err = NError(type: .internalServerError)
                responseType = .failure(err)
            }
            
            completion(responseType)
        }
    }
    
    
    
    
    fileprivate func createDataBody(withParameters params: RequestParameters?,
                                    media: [Media]?,
                                    boundary: String) -> Data {
        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value)\(lineBreak)")
            }
        }
        
        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        return body
    }
    
    
    
    
    fileprivate func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    
    
    
    // MARK: - Request Body Model
    
    struct TextPlainBody {
        let key: String
        let value: String
        let mimeType: String
        
        init(key: String, value: String) {
            self.key = key
            self.value = value
            self.mimeType = "text/plain"
        }
    }
    
    
    
    
    struct Media {
        let key: String
        let filename: String
        let data: Data
        let mimeType: String
        
        init?(withImage image: UIImage, forKey key: String, fileName: String = "") {
            self.key = key
            self.mimeType = "image/jpeg"
            self.filename = fileName.isEmpty ? UUID().uuidString : fileName
            
            guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
            self.data = data
        }
    }
    
}




// MARK: - Extensions

extension String {
    func isValidURL() throws -> URL? {
        guard let url = URL(string: self) else {
            let error = NError(type: .invalidUrl(url: self))
            throw error
        }
        return url
    }
}




extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
            }.joined(separator: "&")
    }
}




extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}




extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
