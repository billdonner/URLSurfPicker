import XCTest
@testable import URLSurfer

// I really dont know how to write a unit test for this


final class URLSurferTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(URLSurfer().text, "URLSurfer")
    }
    func testIsa(){
        
        let vc =   URLSurfPicker([URL(string:"https://apple.com")!,
                                  URL(string:"https://google.com")!],
                                 finally: { url in
                                //XCTAssertTrue(url is URL)
        })
    XCTAssertTrue(vc is UINavigationController) // lame

    }

static var allTests = [
    ("testExample", testExample),
    ("testIsa", testIsa),
]
}
