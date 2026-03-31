//
//  NetworkServiceProtocol.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 31.03.26.
//

protocol NetworkServiceProtocol {
    func fetchTodos(completion: @escaping (Result<TodoResponseDTO, NetworkError>) -> Void)
}
