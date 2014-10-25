//
//  swiftTests.swift
//
//  Created by Domagoj Tršan on 25/10/14.
//  Copyright (c) 2014 Domagoj Tršan. All rights reserved.
//  Licence: The MIT License (MIT)
//

import Cocoa
import XCTest

class swiftTests: XCTestCase {
    
    func testRequestWithURLWithoutQueryParameters() {

        let url = NSURL(string: "http://www.example.com")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"

        let curlCommand = request.cURL()

        let expectedCurlCommand = "curl 'http://www.example.com'"
        XCTAssertEqual(expectedCurlCommand, curlCommand!)
    }
    
    func testRequestWithURLWithQueryParameters() {

        let url =
          NSURL(string: "http://www.example.com?param1=value1&param2=value2")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"

        let curlCommand = request.cURL()

        let expectedCurlCommand =
          "curl 'http://www.example.com?param1=value1&param2=value2'"
        XCTAssertEqual(expectedCurlCommand, curlCommand!)
    }
    
    func testRequestWithNonGETHttpMethod() {

        let url = NSURL(string: "http://www.example.com")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "HTTP_METHOD"

        let curlCommand = request.cURL()

        let expectedCurlCommand = "curl 'http://www.example.com' -X HTTP_METHOD"
        XCTAssertEqual(expectedCurlCommand, curlCommand!)
    }
    
    func testRequestWithRequestBody() {

        let url = NSURL(string: "http://www.example.com")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPBody = "REQUEST BODY".dataUsingEncoding(NSUTF8StringEncoding)

        let curlCommand = request.cURL()

        let expectedCurlCommand =
          "curl 'http://www.example.com' --data 'REQUEST BODY'"
        XCTAssertEqual(expectedCurlCommand, curlCommand!)
    }

    func testRequestWithRequestBodyThatContainsSingleQuotes() {

        let url = NSURL(string: "http://www.example.com")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPBody =
          "REQ'UEST' B'ODY".dataUsingEncoding(NSUTF8StringEncoding)

        let curlCommand = request.cURL()

        let expectedCurlCommand =
          "curl 'http://www.example.com' --data 'REQ'\\''UEST'\\'' B'\\''ODY'"
        XCTAssertEqual(expectedCurlCommand, curlCommand!)
    }

    func testRequestWithHttpHeaders() {

        let url = NSURL(string: "http://www.example.com")
        let request = NSMutableURLRequest(URL: url!)
        request.setValue("CONTENT_TYPE", forHTTPHeaderField: "Content-Type")
        request.setValue("USER_AGENT", forHTTPHeaderField: "User-Agent")

        let curlCommand = request.cURL()

        let expectedCurlCommand = "curl 'http://www.example.com' " +
                                  "-H 'Content-Type: CONTENT_TYPE' " +
                                  "-H 'User-Agent: USER_AGENT'"
        XCTAssertEqual(expectedCurlCommand, curlCommand!)
    }
}
