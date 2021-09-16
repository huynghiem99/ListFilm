//
//  Dispatcher.swift
//  FilmList
//
//  Created by Nghiêm Huy on 16/09/21.
//

import Foundation
import Alamofire

struct NetworkUtils {
    static let JSON_ENCODING = "json"
    static let FORM_DATA_ENCODING = "multipart/form-data"
}

protocol Dispatcher {
    var host: String { get }
    
    func fetch<Request: NetworkRequest, Response: NetworkResponse>(request: Request, handler: Response, completed: @escaping (Result<Response.Resource, Error>) -> Void)
}

struct DefaultJSONDispatcher: Dispatcher {
    var host: String
    
    func fetch<Request, Response>(request: Request, handler: Response, completed: @escaping (Result<Response.Resource, Error>) -> Void) where Request : NetworkRequest, Response : NetworkResponse {
        let method = HTTPMethod(rawValue: request.method)
        var params = request.parameters
        var encoding: ParameterEncoding = URLEncoding.default
        if request.body == nil {
            encoding = URLEncoding.default
        } else {
            if request.body?.encoding == NetworkUtils.JSON_ENCODING {
                encoding = JSONEncoding.default
                params = request.body?.data as? [String: Any]
            }
        }
        
        let headers = HTTPHeaders(request.headers ?? [:])
        
        AF.request(self.host + request.path, method: method, parameters: params, encoding: encoding, headers: headers, interceptor: nil, requestModifier: nil)
            .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data, let statusCode = response.response?.statusCode, let url = response.response?.url {
                        let result = handler.map(data: data, statusCode: statusCode, url: url)
                        completed(result)
                    }
                case .failure(let error): completed(.failure(error))
                }
            }
        
    }
}

struct UploadDispatcher: Dispatcher {
    var host: String
    
    func fetch<Request, Response>(request: Request, handler: Response, completed: @escaping (Result<Response.Resource, Error>) -> Void) where Request : NetworkRequest, Response : NetworkResponse {
        let method = HTTPMethod(rawValue: request.method)
        guard method != .get else { return }
        guard let body = request.body, body.encoding == NetworkUtils.FORM_DATA_ENCODING else { return }
        let headers = HTTPHeaders(request.headers ?? [:])
        AF.upload(multipartFormData: { (form) in
            if let data = body.data as? [String: Any] {
                data.forEach { (key, value) in
                    if let v = value as? Data {
                        form.append(v, withName: key)
                    } else if let v = value as? URL {
                        form.append(v, withName: key)
                    } else if let v = value as? Int {
                        // v -> data
                        var i = "\(v)"
                        form.append(i.data(using: .utf8)!, withName: key)
                    } else if let v = value as? String {
                        form.append(v.data(using: .utf8)!, withName: key)
                    }
                }
            }
        }, to: self.host + request.path, headers: headers)
        .responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let data = response.data, let statusCode = response.response?.statusCode, let url = response.response?.url {
                    let result = handler.map(data: data, statusCode: statusCode, url: url)
                    completed(result)
                }
            case .failure(let error): completed(.failure(error))
            }
        }
    }
}
