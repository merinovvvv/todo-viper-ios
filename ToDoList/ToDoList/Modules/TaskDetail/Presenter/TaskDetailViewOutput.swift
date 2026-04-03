//
//  TaskDetailViewOutput.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 1.04.26.
//

import Foundation

protocol TaskDetailViewOutput: AnyObject {
    func viewDidLoad()
    func didTapBack(
        title: String,
        description: String,
        createdAt: Date
    )
    func didTapToggleCompletion()
}
