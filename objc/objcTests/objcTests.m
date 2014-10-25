//
//  objcTests.m
//
//  Created by Domagoj Tršan on 25/10/14.
//  Copyright (c) 2014 Domagoj Tršan. All rights reserved.
//  Licence: The MIT License (MIT)
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

#import "NSURLRequest+cURL.h"

@interface objcTests : XCTestCase

@end

@implementation objcTests

- (void)testEmptyRequest {

    NSURL *url = [[NSURL alloc] init];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];

    NSString *curlCommand = [request cURL];

    XCTAssertNil(curlCommand);
}

- (void)testRequestWithURLWithoutQueryParameters {

    NSURL *url = [NSURL URLWithString:@"http://www.example.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    NSString *curlCommand = [request cURL];

    NSString *expectedCurlCommand = @"curl 'http://www.example.com'";
    XCTAssertEqualObjects(expectedCurlCommand, curlCommand);
}

- (void)testRequestWithURLWithQueryParameters {

    NSURL *url =
      [NSURL URLWithString:@"http://www.example.com?param1=value1&param2=value2"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];

    NSString *curlCommand = [request cURL];

    NSString *expectedCurlCommand =
      @"curl 'http://www.example.com?param1=value1&param2=value2'";
    XCTAssertEqualObjects(expectedCurlCommand, curlCommand);
}

- (void)testRequestWithNonGETHttpMethod {

    NSURL *url = [NSURL URLWithString:@"http://www.example.com"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"HTTP_METHOD"];

    NSString *curlCommand = [request cURL];

    NSString *expectedCurlCommand =
      @"curl 'http://www.example.com' -X HTTP_METHOD";
    XCTAssertEqualObjects(expectedCurlCommand, curlCommand);
}

- (void)testRequestWithRequestBody {

    NSURL *url = [NSURL URLWithString:@"http://www.example.com"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *httpBody = [@"REQUEST BODY" dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:httpBody];

    NSString *curlCommand = [request cURL];

    NSString *expectedCurlCommand =
      @"curl 'http://www.example.com' --data 'REQUEST BODY'";
    XCTAssertEqualObjects(expectedCurlCommand, curlCommand);
}

- (void)testRequestWithRequestBodyThatContainsSingleQuotes {

    NSURL *url = [NSURL URLWithString:@"http://www.example.com"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *httpBody = [@"REQ'UEST' B'ODY" dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:httpBody];

    NSString *curlCommand = [request cURL];

    NSString *expectedCurlCommand =
      @"curl 'http://www.example.com' --data 'REQ'\\''UEST'\\'' B'\\''ODY'";
    XCTAssertEqualObjects(expectedCurlCommand, curlCommand);
}

- (void)testRequestWithHttpHeaders {

    NSURL *url = [NSURL URLWithString:@"http://www.example.com"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"CONTENT_TYPE" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"USER_AGENT" forHTTPHeaderField:@"User-Agent"];

    NSString *curlCommand = [request cURL];

    NSString *expectedCurlCommand = @"curl 'http://www.example.com' "
                                     "-H 'Content-Type: CONTENT_TYPE' "
                                     "-H 'User-Agent: USER_AGENT'";
    XCTAssertEqualObjects(expectedCurlCommand, curlCommand);
}

@end
