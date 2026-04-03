import CoreData
import XCTest
@testable import ToDoList

enum TestError: LocalizedError {
    case sample

    var errorDescription: String? {
        "Sample test error"
    }
}

func makeTodo(
    id: UUID = UUID(uuidString: "11111111-1111-1111-1111-111111111111") ?? UUID(),
    title: String = "Test title",
    description: String = "Test description",
    createdAt: Date = Date(timeIntervalSince1970: 1_704_196_800),
    isCompleted: Bool = false
) -> Todo {
    Todo(
        id: id,
        title: title,
        description: description,
        createdAt: createdAt,
        isCompleted: isCompleted
    )
}

func assert(todo actual: Todo, matches expected: Todo, file: StaticString = #filePath, line: UInt = #line) {
    XCTAssertEqual(actual.id, expected.id, file: file, line: line)
    XCTAssertEqual(actual.title, expected.title, file: file, line: line)
    XCTAssertEqual(actual.description, expected.description, file: file, line: line)
    XCTAssertEqual(actual.createdAt, expected.createdAt, file: file, line: line)
    XCTAssertEqual(actual.isCompleted, expected.isCompleted, file: file, line: line)
}

func makeTodoEntity(from todo: Todo, in context: NSManagedObjectContext) -> TodoEntity {
    let entity = TodoEntity(context: context)
    entity.configure(with: todo)
    return entity
}

func makeInMemoryManagedObjectContext() -> NSManagedObjectContext {
    guard let modelURL = Bundle(for: CoreDataStack.self).url(forResource: "ToDoList", withExtension: "momd"),
          let model = NSManagedObjectModel(contentsOf: modelURL) else {
        fatalError("Failed to load Core Data model")
    }

    let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)

    do {
        try persistentStoreCoordinator.addPersistentStore(
            ofType: NSInMemoryStoreType,
            configurationName: nil,
            at: nil,
            options: nil
        )
    } catch {
        fatalError("Failed to create in-memory store: \(error)")
    }

    let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    context.persistentStoreCoordinator = persistentStoreCoordinator
    return context
}

final class NetworkServiceMock: NetworkServiceProtocol {
    var fetchTodosCallCount = 0
    var fetchTodosResult: Result<TodoResponseDTO, NetworkError> = .success(
        TodoResponseDTO(todos: [], total: 0, skip: 0, limit: 0)
    )

    func fetchTodos(completion: @escaping (Result<TodoResponseDTO, NetworkError>) -> Void) {
        fetchTodosCallCount += 1
        completion(fetchTodosResult)
    }
}

final class CoreDataServiceMock: CoreDataServiceProtocol {
    var fetchTodosResult: Result<[TodoEntity], CoreDataError> = .success([])
    var saveTodoResult: Result<Void, CoreDataError> = .success(())
    var updateTodoResult: Result<Void, CoreDataError> = .success(())
    var deleteTodoResult: Result<Void, CoreDataError> = .success(())
    var isStoreEmptyValue = true

    var savedTodos: [Todo] = []
    var updatedTodos: [Todo] = []
    var deletedTodoIDs: [UUID] = []

    func fetchTodos() -> Result<[TodoEntity], CoreDataError> {
        fetchTodosResult
    }

    func saveTodo(_ todo: Todo) -> Result<Void, CoreDataError> {
        savedTodos.append(todo)
        return saveTodoResult
    }

    func updateTodo(_ todo: Todo) -> Result<Void, CoreDataError> {
        updatedTodos.append(todo)
        return updateTodoResult
    }

    func deleteTodo(id: UUID) -> Result<Void, CoreDataError> {
        deletedTodoIDs.append(id)
        return deleteTodoResult
    }

    func isStoreEmpty() -> Bool {
        isStoreEmptyValue
    }
}

final class TaskListViewInputMock: TaskListViewInput {
    var reloadDataCallCount = 0
    var deletedIndices: [Int] = []
    var changeTaskStatusIndices: [Int] = []
    var lastErrorMessage: String?

    func reloadData() {
        reloadDataCallCount += 1
    }

    func deleteTodo(at index: Int) {
        deletedIndices.append(index)
    }

    func showError(_ message: String) {
        lastErrorMessage = message
    }

    func changeTaskStatus(at index: Int) {
        changeTaskStatusIndices.append(index)
    }

    func resetCounters() {
        reloadDataCallCount = 0
        deletedIndices = []
        changeTaskStatusIndices = []
        lastErrorMessage = nil
    }
}

final class TaskListInteractorInputMock: TaskListInteractorInput {
    var fetchTodosCallCount = 0
    var updatedTodo: Todo?
    var deletedTodoIDs: [UUID] = []

    func fetchTodos() {
        fetchTodosCallCount += 1
    }

    func updateTodo(_ todo: Todo) {
        updatedTodo = todo
    }

    func deleteTodo(id: UUID) {
        deletedTodoIDs.append(id)
    }
}

final class TaskListRouterInputMock: TaskListRouterInput {
    var navigateCallCount = 0
    var lastTodo: Todo?

    func navigateToTaskDetail(todo: Todo?) {
        navigateCallCount += 1
        lastTodo = todo
    }
}

final class TaskListInteractorOutputMock: TaskListInteractorOutput {
    var fetchedTodos: [Todo] = []
    var updatedTodos: [Todo] = []
    var deletedTodoIDs: [UUID] = []
    var lastError: Error?

    var didFetchTodosExpectation: XCTestExpectation?
    var didUpdateTodoExpectation: XCTestExpectation?
    var didDeleteTodoExpectation: XCTestExpectation?
    var didFailExpectation: XCTestExpectation?

    func didFetchTodos(_ todos: [Todo]) {
        fetchedTodos = todos
        didFetchTodosExpectation?.fulfill()
    }

    func didUpdateTodo(_ todo: Todo) {
        updatedTodos.append(todo)
        didUpdateTodoExpectation?.fulfill()
    }

    func didDeleteTodo(id: UUID) {
        deletedTodoIDs.append(id)
        didDeleteTodoExpectation?.fulfill()
    }

    func didFailWithError(_ error: Error) {
        lastError = error
        didFailExpectation?.fulfill()
    }
}

final class TodoRepositoryProtocolMock: TodoRepositoryProtocol {
    var fetchTodosResult: Result<[Todo], Error> = .success([])
    var saveTodoResult: Result<Void, Error> = .success(())
    var updateTodoResult: Result<Void, Error> = .success(())
    var deleteTodoResult: Result<Void, Error> = .success(())

    func fetchTodos(completion: @escaping (Result<[Todo], Error>) -> Void) {
        completion(fetchTodosResult)
    }

    func saveTodo(_ todo: Todo, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(saveTodoResult)
    }

    func updateTodo(_ todo: Todo, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(updateTodoResult)
    }

    func deleteTodo(id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(deleteTodoResult)
    }
}

final class TaskDetailViewInputMock: TaskDetailViewInput {
    var shownTodo: TaskDetailViewModel?
    var updatedCompletionStates: [Bool] = []
    var lastErrorMessage: String?

    func showTodo(_ viewModel: TaskDetailViewModel) {
        shownTodo = viewModel
    }

    func updateCompletion(isCompleted: Bool) {
        updatedCompletionStates.append(isCompleted)
    }

    func showError(_ message: String) {
        lastErrorMessage = message
    }
}

final class TaskDetailInteractorInputMock: TaskDetailInteractorInput {
    var savedTodo: Todo?
    var updatedTodo: Todo?

    func saveTodo(_ todo: Todo) {
        savedTodo = todo
    }

    func updateTodo(_ todo: Todo) {
        updatedTodo = todo
    }
}

final class TaskDetailRouterInputMock: TaskDetailRouterInput {
    var closeCallCount = 0

    func close() {
        closeCallCount += 1
    }
}

final class TaskDetailInteractorOutputMock: TaskDetailInteractorOutput {
    var didSaveCallCount = 0
    var lastError: Error?

    var didSaveExpectation: XCTestExpectation?
    var didFailExpectation: XCTestExpectation?

    func didSaveTodo() {
        didSaveCallCount += 1
        didSaveExpectation?.fulfill()
    }

    func didFailWithError(_ error: Error) {
        lastError = error
        didFailExpectation?.fulfill()
    }
}
