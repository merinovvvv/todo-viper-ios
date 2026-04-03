//
//  TaskDetailAssembly.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 1.04.26.
//

final class TaskDetailAssembly {
    static func build(todo: Todo?) -> TaskDetailViewController {
        let repository = TodoRepository(
            networkService: NetworkService(),
            coreDataService: CoreDataService()
        )
        
        let router = TaskDetailRouter()
        let presenter = TaskDetailPresenter(todo: todo)
        let interactor = TaskDetailInteractor(presenter: presenter, repository: repository)
        let viewController = TaskDetailViewController(presenter: presenter)
        
        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = router
        router.viewController = viewController
        
        return viewController
    }
}
