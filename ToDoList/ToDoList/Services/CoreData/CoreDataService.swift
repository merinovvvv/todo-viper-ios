//
//  CoreDataService.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 31.03.26.
//

import Foundation
import CoreData

final class CoreDataService: CoreDataServiceProtocol {
    
    private let stack: CoreDataStack
    
    init(stack: CoreDataStack = .shared) {
        self.stack = stack
    }
    
    func fetchTodos() -> Result<[Todo], CoreDataError> {
        let context = stack.mainContext
        let request = TodoEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        do {
            let entities = try context.fetch(request)
            return .success(entities.map { $0.toDomain() })
        } catch {
            return .failure(.fetchFailed)
        }
    }
    
    func saveTodo(_ todo: Todo) -> Result<Void, CoreDataError> {
        let context = stack.backgroundContext()
        var result: Result<Void, CoreDataError> = .success(())
        
        context.performAndWait {
            let entity = TodoEntity(context: context)
            entity.configure(with: todo)
            
            do {
                try context.save()
            } catch {
                result = .failure(.saveFailed)
            }
        }
        
        return result
    }
    
    func updateTodo(_ todo: Todo) -> Result<Void, CoreDataError> {
        let context = stack.backgroundContext()
        var result: Result<Void, CoreDataError> = .success(())
        
        context.performAndWait {
            let request = TodoEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", todo.id as CVarArg)
            
            guard let entity = try? context.fetch(request).first else {
                result = .failure(.objectNotFound)
                return
            }
            
            entity.configure(with: todo)
            
            do {
                try context.save()
            } catch {
                result = .failure(.updateFailed)
            }
        }
        
        return result
    }
    
    func deleteTodo(id: UUID) -> Result<Void, CoreDataError> {
        let context = stack.backgroundContext()
        var result: Result<Void, CoreDataError> = .success(())
        
        context.performAndWait {
            let request = TodoEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            guard let entity = try? context.fetch(request).first else {
                result = .failure(.objectNotFound)
                return
            }
            
            context.delete(entity)
            
            do {
                try context.save()
            } catch {
                result = .failure(.deleteFailed)
            }
        }
        
        return result
    }
}
