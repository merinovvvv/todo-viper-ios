import XCTest
@testable import ToDoList

final class TaskDetailPresenterTests: XCTestCase {
    func testViewDidLoadShowsViewModel() {
        let todo = makeTodo(title: "Buy milk", description: "2 liters", isCompleted: true)
        let sut = TaskDetailPresenter(todo: todo)
        let view = TaskDetailViewInputMock()

        sut.view = view
        sut.viewDidLoad()

        XCTAssertEqual(view.shownTodo?.title, "Buy milk")
        XCTAssertEqual(view.shownTodo?.description, "2 liters")
        XCTAssertEqual(view.shownTodo?.createdAt, "02/01/24")
        XCTAssertTrue(view.shownTodo?.isCompleted == true)
    }

    func testDidTapBackForEmptyNewTodoClosesWithoutSaving() {
        let sut = TaskDetailPresenter(todo: nil)
        let interactor = TaskDetailInteractorInputMock()
        let router = TaskDetailRouterInputMock()
        let createdAt = Date(timeIntervalSince1970: 1_704_196_800)

        sut.interactor = interactor
        sut.router = router
        sut.didTapBack(title: "   ", description: "\n", createdAt: createdAt)

        XCTAssertEqual(router.closeCallCount, 1)
        XCTAssertNil(interactor.savedTodo)
        XCTAssertNil(interactor.updatedTodo)
    }

    func testDidTapBackWithEmptyTitleShowsError() {
        let sut = TaskDetailPresenter(todo: nil)
        let view = TaskDetailViewInputMock()
        let router = TaskDetailRouterInputMock()
        let createdAt = Date(timeIntervalSince1970: 1_704_196_800)

        sut.view = view
        sut.router = router
        sut.didTapBack(title: " ", description: "Description", createdAt: createdAt)

        XCTAssertEqual(view.lastErrorMessage, "Введите название задачи")
        XCTAssertEqual(router.closeCallCount, 0)
    }

    func testDidTapBackForNewTodoSavesTrimmedValues() {
        let sut = TaskDetailPresenter(todo: nil)
        let interactor = TaskDetailInteractorInputMock()
        let createdAt = Date(timeIntervalSince1970: 1_704_196_800)

        sut.interactor = interactor
        sut.didTapBack(title: "  Buy milk  ", description: "  2 liters  ", createdAt: createdAt)

        XCTAssertEqual(interactor.savedTodo?.title, "Buy milk")
        XCTAssertEqual(interactor.savedTodo?.description, "2 liters")
        XCTAssertEqual(interactor.savedTodo?.createdAt, createdAt)
    }

    func testDidTapBackForUnchangedExistingTodoClosesWithoutUpdating() {
        let todo = makeTodo(title: "Buy milk", description: "2 liters", isCompleted: false)
        let sut = TaskDetailPresenter(todo: todo)
        let interactor = TaskDetailInteractorInputMock()
        let router = TaskDetailRouterInputMock()

        sut.interactor = interactor
        sut.router = router
        sut.didTapBack(title: "Buy milk", description: "2 liters", createdAt: todo.createdAt)

        XCTAssertEqual(router.closeCallCount, 1)
        XCTAssertNil(interactor.updatedTodo)
    }

    func testDidTapBackForChangedExistingTodoUpdatesTodo() {
        let todo = makeTodo(title: "Buy milk", description: "2 liters", isCompleted: false)
        let sut = TaskDetailPresenter(todo: todo)
        let interactor = TaskDetailInteractorInputMock()
        let createdAt = Date(timeIntervalSince1970: 1_705_060_800)

        sut.interactor = interactor
        sut.didTapBack(title: "Buy bread", description: "Whole grain", createdAt: createdAt)

        XCTAssertEqual(interactor.updatedTodo?.id, todo.id)
        XCTAssertEqual(interactor.updatedTodo?.title, "Buy bread")
        XCTAssertEqual(interactor.updatedTodo?.description, "Whole grain")
        XCTAssertEqual(interactor.updatedTodo?.createdAt, createdAt)
    }

    func testDidTapBackForDateOnlyChangeUpdatesExistingTodo() {
        let originalDate = Date(timeIntervalSince1970: 1_704_196_800)
        let updatedDate = Date(timeIntervalSince1970: 1_705_060_800)
        let todo = makeTodo(
            title: "Buy milk",
            description: "2 liters",
            createdAt: originalDate,
            isCompleted: false
        )
        let sut = TaskDetailPresenter(todo: todo)
        let interactor = TaskDetailInteractorInputMock()
        let router = TaskDetailRouterInputMock()

        sut.interactor = interactor
        sut.router = router
        sut.didTapBack(title: "Buy milk", description: "2 liters", createdAt: updatedDate)

        XCTAssertEqual(interactor.updatedTodo?.id, todo.id)
        XCTAssertEqual(interactor.updatedTodo?.title, todo.title)
        XCTAssertEqual(interactor.updatedTodo?.description, todo.description)
        XCTAssertEqual(interactor.updatedTodo?.createdAt, updatedDate)
        XCTAssertEqual(router.closeCallCount, 0)
    }

    func testDidTapBackForExistingTodoWithUnchangedDateDoesNotUpdate() {
        let originalDate = Date(timeIntervalSince1970: 1_704_196_800)
        let todo = makeTodo(
            title: "Buy milk",
            description: "2 liters",
            createdAt: originalDate,
            isCompleted: false
        )
        let sut = TaskDetailPresenter(todo: todo)
        let interactor = TaskDetailInteractorInputMock()
        let router = TaskDetailRouterInputMock()

        sut.interactor = interactor
        sut.router = router
        sut.didTapBack(title: "Buy milk", description: "2 liters", createdAt: originalDate)

        XCTAssertNil(interactor.updatedTodo)
        XCTAssertEqual(router.closeCallCount, 1)
    }

    func testDidTapToggleCompletionUpdatesView() {
        let todo = makeTodo(isCompleted: false)
        let sut = TaskDetailPresenter(todo: todo)
        let view = TaskDetailViewInputMock()

        sut.view = view
        sut.didTapToggleCompletion()

        XCTAssertEqual(view.updatedCompletionStates, [true])
    }

    func testDidSaveTodoClosesRouter() {
        let sut = TaskDetailPresenter(todo: nil)
        let router = TaskDetailRouterInputMock()

        sut.router = router
        sut.didSaveTodo()

        XCTAssertEqual(router.closeCallCount, 1)
    }

    func testDidFailWithErrorShowsError() {
        let sut = TaskDetailPresenter(todo: nil)
        let view = TaskDetailViewInputMock()

        sut.view = view
        sut.didFailWithError(TestError.sample)

        XCTAssertEqual(view.lastErrorMessage, TestError.sample.localizedDescription)
    }
}
