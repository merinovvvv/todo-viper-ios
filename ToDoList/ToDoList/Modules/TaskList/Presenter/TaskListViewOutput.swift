//
//  TaskListViewOutput.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 1.04.26.
//

import Foundation

protocol TaskListViewOutput: AnyObject {
    func viewDidLoad()
    func numberOfRows() -> Int
    func viewModel(at index: Int) -> TaskListViewModel?
    func didTapAddTask()
    func didTapTask(id: UUID)
    func didTapChangeStatus(id: UUID)
    func didTapDelete(id: UUID)
    func didSearch(query: String)
}
