import XCTest
@testable import ToDoList

final class TaskListInteractorTests: XCTestCase {
    func testFetchTodosOnSuccessForwardsTodosToPresenter() {
        let presenter = TaskListInteractorOutputMock()
        let repository = TodoRepositoryProtocolMock()
        let sut = TaskListInteractor(presenter: presenter, repository: repository)
        let todos = [makeTodo()]
        let expectation = expectation(description: "didFetchTodos")

        presenter.didFetchTodosExpectation = expectation
        repository.fetchTodosResult = .success(todos)

        sut.fetchTodos()

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(presenter.fetchedTodos.count, 1)
        assert(todo: presenter.fetchedTodos[0], matches: todos[0])
    }

    func testUpdateTodoOnSuccessForwardsTodoToPresenter() {
        let presenter = TaskListInteractorOutputMock()
        let repository = TodoRepositoryProtocolMock()
        let sut = TaskListInteractor(presenter: presenter, repository: repository)
        let todo = makeTodo(isCompleted: true)
        let expectation = expectation(description: "didUpdateTodo")

        presenter.didUpdateTodoExpectation = expectation
        repository.updateTodoResult = .success(())

        sut.updateTodo(todo)

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(presenter.updatedTodos.count, 1)
        assert(todo: presenter.updatedTodos[0], matches: todo)
    }

    func testDeleteTodoOnSuccessForwardsIdToPresenter() {
        let presenter = TaskListInteractorOutputMock()
        let repository = TodoRepositoryProtocolMock()
        let sut = TaskListInteractor(presenter: presenter, repository: repository)
        let id = UUID()
        let expectation = expectation(description: "didDeleteTodo")

        presenter.didDeleteTodoExpectation = expectation
        repository.deleteTodoResult = .success(())

        sut.deleteTodo(id: id)

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(presenter.deletedTodoIDs, [id])
    }

    func testFetchTodosOnFailureForwardsErrorToPresenter() {
        let presenter = TaskListInteractorOutputMock()
        let repository = TodoRepositoryProtocolMock()
        let sut = TaskListInteractor(presenter: presenter, repository: repository)
        let expectation = expectation(description: "didFailWithError")

        presenter.didFailExpectation = expectation
        repository.fetchTodosResult = .failure(TestError.sample)

        sut.fetchTodos()

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(presenter.lastError?.localizedDescription, TestError.sample.localizedDescription)
    }
}
