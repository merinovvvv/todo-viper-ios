import XCTest
@testable import ToDoList

final class TaskDetailInteractorTests: XCTestCase {
    func testSaveTodoOnSuccessNotifiesPresenter() {
        let presenter = TaskDetailInteractorOutputMock()
        let repository = TodoRepositoryProtocolMock()
        let sut = TaskDetailInteractor(presenter: presenter, repository: repository)
        let expectation = expectation(description: "didSaveTodo")

        presenter.didSaveExpectation = expectation
        repository.saveTodoResult = .success(())

        sut.saveTodo(makeTodo())

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(presenter.didSaveCallCount, 1)
    }

    func testUpdateTodoOnFailureForwardsError() {
        let presenter = TaskDetailInteractorOutputMock()
        let repository = TodoRepositoryProtocolMock()
        let sut = TaskDetailInteractor(presenter: presenter, repository: repository)
        let expectation = expectation(description: "didFailWithError")

        presenter.didFailExpectation = expectation
        repository.updateTodoResult = .failure(TestError.sample)

        sut.updateTodo(makeTodo())

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(presenter.lastError?.localizedDescription, TestError.sample.localizedDescription)
    }
}
