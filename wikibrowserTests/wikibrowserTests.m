//
//  wikibrowserTests.m
//  wikibrowserTests
//
//  Created by Patrick Chin on 2015-01-26.
//  Copyright (c) 2015 PatCo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NSString+UrlEncodeForWiki.h"

@interface wikibrowserTests : XCTestCase

@end

@implementation wikibrowserTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testUrlEncodeForWiki {
    NSString *strTitle;
    NSString *strResult;
    
    strTitle = @"Batman";
    strResult = [strTitle urlEncodeForWiki];
    XCTAssertTrue([strResult isEqualToString:@"Batman"]);
    
    strTitle = @"Gotham City";
    strResult = [strTitle urlEncodeForWiki];
    XCTAssertTrue([strResult isEqualToString:@"Gotham_City"]);
}

@end
