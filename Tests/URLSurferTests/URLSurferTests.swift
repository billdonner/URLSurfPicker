import XCTest
@testable import URLSurfer

final class URLSurferTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(URLSurfer().text, "URLSurfer")
    }
    func testIsa(){
        
        let vc =             URLSurfPicker([URL(string:"https://apple.com")!,
                                 URL(string:"https://google.com")!])
        
        // now what?
        
    XCTAssertTrue(vc is UINavigationController)
        
    }

    static var allTests = [
        ("testExample", testExample),
          ("testIsa", testIsa),
    ]
}
