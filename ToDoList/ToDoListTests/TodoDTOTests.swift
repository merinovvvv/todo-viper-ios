import XCTest
@testable import ToDoList

final class TodoDTOTests: XCTestCase {
    func testToDomainMapsTodoAndCompletion() {
        let dto = TodoDTO(todo: "Buy milk", completed: true)

        let todo = dto.toDomain()

        XCTAssertEqual(todo.title, "Buy milk")
        XCTAssertEqual(todo.description, "here should be some description")
        XCTAssertTrue(todo.isCompleted)
    }
}
