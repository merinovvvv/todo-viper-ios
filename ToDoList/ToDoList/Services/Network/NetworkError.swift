//
//  NetworkError.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 31.03.26.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case noData
    case decodingFailed
    case serverError(statusCode: Int)
    case noInternetConnection
    case requestTimeout
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received from server"
        case .decodingFailed:
            return "Failed to decode server response"
        case .serverError(let statusCode):
            return "Server returned error with status code: \(statusCode)"
        case .noInternetConnection:
            return "No internet connection"
        case .requestTimeout:
            return "Request timed out"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}
