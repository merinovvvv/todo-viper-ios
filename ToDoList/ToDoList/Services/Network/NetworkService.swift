//
//  NetworkService.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 31.03.26.
//

import Foundation

final class NetworkService: NetworkServiceProtocol {
    func fetchTodos(completion: @escaping (Result<TodoResponseDTO, NetworkError>) -> Void) {
        switch RequestBuilder.build(for: .fetchTodos) {
        case .success(let urlRequest):
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error as? URLError {
                    switch error.code {
                    case .notConnectedToInternet, .networkConnectionLost:
                        completion(.failure(.noInternetConnection))
                    case .timedOut:
                        completion(.failure(.requestTimeout))
                    default:
                        completion(.failure(.unknown(error)))
                    }
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200...299:
                        break
                    default:
                        completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
                        return
                    }
                }
                
                guard let data else {
                    completion(.failure(.noData))
                    return
                }
                
                do {
                    let todoResponse = try JSONDecoder().decode(TodoResponseDTO.self, from: data)
                    completion(.success(todoResponse))
                } catch {
                    completion(.failure(.decodingFailed))
                }
            }.resume()
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
