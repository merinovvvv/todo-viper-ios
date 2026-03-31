//
//  RequestBuilder.swift.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 1.04.26.
//

import Foundation

final class RequestBuilder {
    static func build(for endpoint: Endpoint) -> Result<URLRequest, NetworkError> {
        guard let url = URL(string: endpoint.baseURL + endpoint.path) else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 30
        
        return .success(request)
    }
}

enum Endpoint {
    case fetchTodos
    
    var baseURL: String {
        return "https://dummyjson.com"
    }
    
    var path: String {
        switch self {
        case .fetchTodos:
            return "/todos"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchTodos:
            return .get
        }
    }
}

enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
}
