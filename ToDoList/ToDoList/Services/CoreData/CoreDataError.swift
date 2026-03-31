//
//  CoreDataError.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 1.04.26.
//

import Foundation

enum CoreDataError: LocalizedError {
    case fetchFailed
    case saveFailed
    case deleteFailed
    case updateFailed
    case objectNotFound
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .fetchFailed:
            return "Failed to fetch data from CoreData"
        case .saveFailed:
            return "Failed to save data to CoreData"
        case .deleteFailed:
            return "Failed to delete object from CoreData"
        case .updateFailed:
            return "Failed to update object in CoreData"
        case .objectNotFound:
            return "Object not found in CoreData"
        case .unknown(let error):
            return "Unknown CoreData error: \(error.localizedDescription)"
        }
    }
}
