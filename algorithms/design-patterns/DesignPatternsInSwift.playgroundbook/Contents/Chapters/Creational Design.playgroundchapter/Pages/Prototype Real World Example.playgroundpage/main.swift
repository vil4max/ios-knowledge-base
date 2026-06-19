/*:
# Prototype: Real World Example

You can go back to the [conceptual example](@previous) if you want to review the concepts.
 */
import Foundation

private class Author {
    private var id: Int
    private var username: String
    private var pages = [Page]()

    init(id: Int, username: String) {
        self.id = id
        self.username = username
    }

    func add(page: Page) {
        pages.append(page)
    }

    var pagesCount: Int {
        return pages.count
    }
}

private class Page: NSCopying {
    private(set) var title: String
    private(set) var contents: String
    private weak var author: Author?
    private(set) var comments = [Comment]()

    init(title: String, contents: String, author: Author?) {
        self.title = title
        self.contents = contents
        self.author = author
        author?.add(page: self)
    }

    func add(comment: Comment) {
        comments.append(comment)
    }

    /// MARK: - NSCopying
    func copy(with zone: NSZone? = nil) -> Any {
        return Page(title: "Copy of '" + title + "'", contents: contents, author: author)
    }
}

private struct Comment {
    let date = Date()
    let message: String
}

class PrototypeRealWorld_TestCase {
    func testPrototypeRealWorld() {
        let author = Author(id: 10, username: "Ivan_83")
        let page = Page(title: "My First Page", contents: "Hello world!", author: author)

        page.add(comment: Comment(message: "Keep it up!"))

        /// Since NSCopying returns Any, the copied object should be unwrapped.
        guard let anotherPage = page.copy() as? Page else {
            print("Page was not copied")
            return
        }

        /// Comments should be empty as it is a new page.
        guard anotherPage.comments.isEmpty else {
            print("Comments should be empty as it is a new page")
            return
        }

        /// Note that the author is now referencing two objects.
        guard author.pagesCount == 2 else {
            print("Author should be referencing two objects")
            return
        }

        print("Original title: " + page.title)
        print("Copied title: " + anotherPage.title)
        print("Count of pages: " + String(author.pagesCount))
    }
}

let testCase = PrototypeRealWorld_TestCase()
testCase.testPrototypeRealWorld()
