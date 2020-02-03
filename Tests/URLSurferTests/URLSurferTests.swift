import XCTest
@testable import URLSurfer

// I really dont know how to write proper unit tests for this, I will look into UI Testing in the future


final class URLSurferTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(URLSurfer().text, "URLSurfer")
    }
    func testIsa(){
        
        let _ =   URLSurfPicker([URL(string:"https://apple.com")!,
                                  URL(string:"https://google.com")!],
                                 foreach: { url in print("got \(url)") },
                                 finally: { allurls in  print ("gotall \(allurls)") })
        
            XCTAssertEqual(URLSurfer().text, "URLSurfer")

    }
    func xtestThatNeedsIOS(){
        // this test presents UI and thus needs to be run in an IOS or OSX
       
           // Create an expectation for a background download task.
              let expectation = XCTestExpectation(description: "Picker test needs Window")
              
           let _ =   URLSurfPicker([URL(string:"https://apple.com")!,
                                     URL(string:"https://google.com")!],
                                    foreach: { url in print("got \(url)") },
                                    finally: { allurls in  print ("gotall \(allurls)")
                                        expectation.fulfill()
                                        
           })
                             
             // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
           wait(for: [expectation], timeout: 10.0)
        XCTAssertEqual(URLSurfer().text, "URLSurfer")
       }

static var allTests = [
    ("testExample", testExample),
    ("testIsa", testIsa),
]
}
