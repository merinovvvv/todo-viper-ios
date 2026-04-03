import XCTest
@testable import ToDoList

final class TaskListPresenterTests: XCTestCase {
    func testViewDidLoadFetchesTodos() {
        let sut = TaskListPresenter()
        let interactor = TaskListInteractorInputMock()

        sut.interactor = interactor
        sut.viewDidLoad()

        XCTAssertEqual(interactor.fetchTodosCallCount, 1)
    }

    func testDidFetchTodosReloadsViewAndProvidesViewModels() throws {
        let sut = TaskListPresenter()
        let view = TaskListViewInputMock()
        let todos = [
            makeTodo(title: "Buy milk", description: "2 liters", isCompleted: false),
            makeTodo(id: UUID(uuidString: "22222222-2222-2222-2222-222222222222") ?? UUID(),
                     title: "Walk dog",
                     description: "Evening",
                     isCompleted: true)
        ]

        sut.view = view
        sut.didFetchTodos(todos)

        XCTAssertEqual(view.reloadDataCallCount, 1)
        XCTAssertEqual(sut.numberOfRows(), 2)

        let firstViewModel = try XCTUnwrap(sut.viewModel(at: 0))
        XCTAssertEqual(firstViewModel.title, "Buy milk")
        XCTAssertEqual(firstViewModel.description, "2 liters")
        XCTAssertEqual(firstViewModel.createdAt, "02/01/24")
        XCTAssertFalse(firstViewModel.isCompleted)
    }

    func testDidSearchFiltersVisibleTodos() {
        let sut = TaskListPresenter()
        let view = TaskListViewInputMock()
        let todos = [
            makeTodo(title: "Buy milk", description: "Groceries"),
            makeTodo(id: UUID(uuidString: "22222222-2222-2222-2222-222222222222") ?? UUID(),
                     title: "Walk dog",
                     description: "Outside")
        ]

        sut.view = view
        sut.didFetchTodos(todos)
        sut.didSearch(query: "dog")

        XCTAssertEqual(view.reloadDataCallCount, 2)
        XCTAssertEqual(sut.numberOfRows(), 1)
        XCTAssertEqual(sut.viewModel(at: 0)?.title, "Walk dog")
    }

    func testDidTapAddTaskNavigatesToDetailWithNilTodo() {
        let sut = TaskListPresenter()
        let router = TaskListRouterInputMock()

        sut.router = router
        sut.didTapAddTask()

        XCTAssertEqual(router.navigateCallCount, 1)
        XCTAssertNil(router.lastTodo)
    }

    func testDidTapTaskNavigatesToDetailWithSelectedTodo() throws {
        let sut = TaskListPresenter()
        let router = TaskListRouterInputMock()
        let todo = makeTodo(title: "Buy milk")

        sut.router = router
        sut.didFetchTodos([todo])
        sut.didTapTask(id: todo.id)

        XCTAssertEqual(router.navigateCallCount, 1)
        assert(todo: try XCTUnwrap(router.lastTodo), matches: todo)
    }

    func testDidTapChangeStatusSendsToggledTodoToInteractor() throws {
        let sut = TaskListPresenter()
        let interactor = TaskListInteractorInputMock()
        let todo = makeTodo(isCompleted: false)

        sut.interactor = interactor
        sut.didFetchTodos([todo])
        sut.didTapChangeStatus(id: todo.id)

        let updatedTodo = try XCTUnwrap(interactor.updatedTodo)
        XCTAssertEqual(updatedTodo.id, todo.id)
        XCTAssertTrue(updatedTodo.isCompleted)
    }

    func testDidUpdateTodoReloadsSingleRowWhenSearchIsEmpty() {
        let sut = TaskListPresenter()
        let view = TaskListViewInputMock()
        let todo = makeTodo(title: "Buy milk", isCompleted: false)
        let updatedTodo = makeTodo(
            id: todo.id,
            title: todo.title,
            description: todo.description,
            createdAt: todo.createdAt,
            isCompleted: true
        )

        sut.view = view
        sut.didFetchTodos([todo])
        view.resetCounters()

        sut.didUpdateTodo(updatedTodo)

        XCTAssertEqual(view.changeTaskStatusIndices, [0])
        XCTAssertEqual(view.reloadDataCallCount, 0)
        XCTAssertEqual(sut.viewModel(at: 0)?.isCompleted, true)
    }

    func testDidUpdateTodoReloadsWholeListWhenSearchIsActive() {
        let sut = TaskListPresenter()
        let view = TaskListViewInputMock()
        let todo = makeTodo(title: "Buy milk", isCompleted: false)
        let updatedTodo = makeTodo(
            id: todo.id,
            title: todo.title,
            description: todo.description,
            createdAt: todo.createdAt,
            isCompleted: true
        )

        sut.view = view
        sut.didFetchTodos([todo])
        sut.didSearch(query: "buy")
        view.resetCounters()

        sut.didUpdateTodo(updatedTodo)

        XCTAssertEqual(view.reloadDataCallCount, 1)
        XCTAssertTrue(view.changeTaskStatusIndices.isEmpty)
    }

    func testDidTapDeletePassesIdToInteractor() {
        let sut = TaskListPresenter()
        let interactor = TaskListInteractorInputMock()
        let todo = makeTodo()

        sut.interactor = interactor
        sut.didTapDelete(id: todo.id)

        XCTAssertEqual(interactor.deletedTodoIDs, [todo.id])
    }

    func testDidDeleteTodoRemovesVisibleItemAndNotifiesView() {
        let sut = TaskListPresenter()
        let view = TaskListViewInputMock()
        let firstTodo = makeTodo(title: "Buy milk")
        let secondTodo = makeTodo(
            id: UUID(uuidString: "22222222-2222-2222-2222-222222222222") ?? UUID(),
            title: "Walk dog"
        )

        sut.view = view
        sut.didFetchTodos([firstTodo, secondTodo])
        view.resetCounters()

        sut.didDeleteTodo(id: firstTodo.id)

        XCTAssertEqual(view.deletedIndices, [0])
        XCTAssertEqual(sut.numberOfRows(), 1)
        XCTAssertEqual(sut.viewModel(at: 0)?.title, "Walk dog")
    }

    func testDidFailWithErrorShowsMessage() {
        let sut = TaskListPresenter()
        let view = TaskListViewInputMock()

        sut.view = view
        sut.didFailWithError(TestError.sample)

        XCTAssertEqual(view.lastErrorMessage, TestError.sample.localizedDescription)
    }
}
