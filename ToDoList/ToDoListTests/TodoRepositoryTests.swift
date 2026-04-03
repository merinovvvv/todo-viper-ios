import XCTest
@testable import ToDoList

final class TodoRepositoryTests: XCTestCase {
    func testFetchTodosWhenStoreIsEmptyFetchesFromNetworkSavesAndReturnsDomainTodos() {
        let networkService = NetworkServiceMock()
        let coreDataService = CoreDataServiceMock()
        let repository = TodoRepository(networkService: networkService, coreDataService: coreDataService)
        let response = TodoResponseDTO(
            todos: [
                TodoDTO(todo: "Buy milk", completed: false),
                TodoDTO(todo: "Walk dog", completed: true)
            ],
            total: 2,
            skip: 0,
            limit: 2
        )
        let expectation = expectation(description: "fetchTodos completion")

        coreDataService.isStoreEmptyValue = true
        networkService.fetchTodosResult = .success(response)

        repository.fetchTodos { result in
            switch result {
            case .success(let todos):
                XCTAssertEqual(todos.count, 2)
                XCTAssertEqual(todos.map(\.title), ["Buy milk", "Walk dog"])
                XCTAssertEqual(todos.map(\.isCompleted), [false, true])
                XCTAssertEqual(coreDataService.savedTodos.count, 2)
            case .failure(let error):
                XCTFail("Expected success, got \(error)")
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(networkService.fetchTodosCallCount, 1)
    }

    func testFetchTodosWhenStoreIsEmptyReturnsSaveError() {
        let networkService = NetworkServiceMock()
        let coreDataService = CoreDataServiceMock()
        let repository = TodoRepository(networkService: networkService, coreDataService: coreDataService)
        let response = TodoResponseDTO(
            todos: [TodoDTO(todo: "Buy milk", completed: false)],
            total: 1,
            skip: 0,
            limit: 1
        )
        let expectation = expectation(description: "fetchTodos completion")

        coreDataService.isStoreEmptyValue = true
        coreDataService.saveTodoResult = .failure(.saveFailed)
        networkService.fetchTodosResult = .success(response)

        repository.fetchTodos { result in
            switch result {
            case .success:
                XCTFail("Expected failure")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, CoreDataError.saveFailed.localizedDescription)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testFetchTodosWhenStoreHasDataReturnsCoreDataTodos() {
        let networkService = NetworkServiceMock()
        let coreDataService = CoreDataServiceMock()
        let repository = TodoRepository(networkService: networkService, coreDataService: coreDataService)
        let storedTodo = makeTodo(title: "Stored", description: "Saved locally", isCompleted: true)
        let context = makeInMemoryManagedObjectContext()
        let entity = makeTodoEntity(from: storedTodo, in: context)
        let expectation = expectation(description: "fetchTodos completion")

        coreDataService.isStoreEmptyValue = false
        coreDataService.fetchTodosResult = .success([entity])

        repository.fetchTodos { result in
            switch result {
            case .success(let todos):
                XCTAssertEqual(todos.count, 1)
                assert(todo: todos[0], matches: storedTodo)
            case .failure(let error):
                XCTFail("Expected success, got \(error)")
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(networkService.fetchTodosCallCount, 0)
    }

    func testSaveTodoPropagatesCoreDataResult() {
        let networkService = NetworkServiceMock()
        let coreDataService = CoreDataServiceMock()
        let repository = TodoRepository(networkService: networkService, coreDataService: coreDataService)
        let todo = makeTodo()
        let expectation = expectation(description: "saveTodo completion")

        repository.saveTodo(todo) { result in
            switch result {
            case .success:
                XCTAssertEqual(coreDataService.savedTodos.count, 1)
                assert(todo: coreDataService.savedTodos[0], matches: todo)
            case .failure(let error):
                XCTFail("Expected success, got \(error)")
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testUpdateTodoPropagatesCoreDataError() {
        let networkService = NetworkServiceMock()
        let coreDataService = CoreDataServiceMock()
        let repository = TodoRepository(networkService: networkService, coreDataService: coreDataService)
        let expectation = expectation(description: "updateTodo completion")

        coreDataService.updateTodoResult = .failure(.updateFailed)

        repository.updateTodo(makeTodo()) { result in
            switch result {
            case .success:
                XCTFail("Expected failure")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, CoreDataError.updateFailed.localizedDescription)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testDeleteTodoPropagatesSuccess() {
        let networkService = NetworkServiceMock()
        let coreDataService = CoreDataServiceMock()
        let repository = TodoRepository(networkService: networkService, coreDataService: coreDataService)
        let id = UUID()
        let expectation = expectation(description: "deleteTodo completion")

        repository.deleteTodo(id: id) { result in
            switch result {
            case .success:
                XCTAssertEqual(coreDataService.deletedTodoIDs, [id])
            case .failure(let error):
                XCTFail("Expected success, got \(error)")
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }
}
